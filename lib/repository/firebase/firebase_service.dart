import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tropical_iptv_ios/repository/locale/locale.dart';

class FirebaseService {
  final firebase = FirebaseFirestore.instance;

  Future<FireUserData?> fetchUserData(String userNumber) async {
    try {
      debugPrint("🔍 Buscando userNumber: '${userNumber.trim()}'");

      final data = await firebase
          .collection("devices")
          .where("userNumber", isEqualTo: userNumber.trim())
          .limit(1)
          .get();

      debugPrint("🔎 Total de documentos encontrados: ${data.docs.length}");

      if (data.docs.isEmpty) {
        debugPrint("❌ No DATA FOUND for userNumber: $userNumber");
        return null;
      } else {
        final docData = data.docs.first.data();
        debugPrint("🔥 Documento encontrado: $docData");

        final code = FireUserData.fromMap(docData);

        // Salvar código do usuário localmente
        await LocaleApi.saveUserCode(code);

        return code;
      }
    } on FirebaseException catch (e) {
      debugPrint("❌ Firebase Error fetchUserData: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      debugPrint("❌ Error fetchUserData: $e");
      return null;
    }
  }

  Future<bool> updatePaymentStatus(String userNumber, bool status) async {
    try {
      debugPrint("🔄 Updating payment status for: $userNumber");

      final data = await firebase
          .collection("devices")
          .where("userNumber", isEqualTo: userNumber.trim())
          .limit(1)
          .get();

      if (data.docs.isEmpty) {
        debugPrint("❌ User not found for update");
        return false;
      }

      await data.docs.first.reference.update({
        'paymentStatus': status,
      });

      debugPrint("✅ Payment status updated successfully");
      return true;
    } catch (e) {
      debugPrint("❌ Error updating payment status: $e");
      return false;
    }
  }

  Future<bool> createUser(FireUserData userData) async {
    try {
      debugPrint("📝 Creating new user: ${userData.userNumber}");

      await firebase.collection("devices").add(userData.toMap());

      debugPrint("✅ User created successfully");
      return true;
    } catch (e) {
      debugPrint("❌ Error creating user: $e");
      return false;
    }
  }
}

class FireUserData {
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<FireIptv> lists;
  final bool paymentStatus;
  final String userNumber;

  FireUserData({
    required this.createdAt,
    required this.expiresAt,
    required this.lists,
    required this.paymentStatus,
    required this.userNumber,
  });

  factory FireUserData.fromMap(dynamic map) {
    return FireUserData(
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      expiresAt: (map['expiresAt'] as Timestamp).toDate(),
      lists: map['lists'] == null
          ? []
          : (map['lists'] as List<dynamic>)
              .map((item) => FireIptv.fromMap(item))
              .toList(),
      paymentStatus: map['paymentStatus'] ?? false,
      userNumber: map['userNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'lists': lists.map((e) => e.toMap()).toList(),
      'paymentStatus': paymentStatus,
      'userNumber': userNumber,
    };
  }

  // Método para compatibilidade com código existente
  List<FireIptv>? get iptvAccounts => lists;

  @override
  String toString() {
    return 'FireUserData(userNumber: $userNumber, paymentStatus: $paymentStatus, lists: ${lists.length})';
  }
}

class FireIptv {
  final String name;
  final String url;

  FireIptv({required this.name, required this.url});

  factory FireIptv.fromMap(dynamic map) {
    return FireIptv(
      name: map['name'] ?? '',
      url: map['url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }

  @override
  String toString() {
    return 'FireIptv(name: $name, url: $url)';
  }
}
