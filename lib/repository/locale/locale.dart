import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tropical_iptv_ios/repository/models/user.dart';
import 'package:tropical_iptv_ios/repository/models/watching.dart';
import 'package:tropical_iptv_ios/repository/firebase/firebase_service.dart';

part 'favorites.dart';
part 'admob.dart';

class LocaleApi {
  static final GetStorage _box = GetStorage();
  static const String _userKey = 'user';
  static const String _userCodeKey = 'user_code';

  static Future<void> saveUser(UserModel user) async {
    await _box.write(_userKey, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    try {
      final String? userData = _box.read(_userKey);
      if (userData == null) return null;

      final json = jsonDecode(userData);
      return UserModel.fromJson(json, json['server_info']['server_url']);
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteUser() async {
    await _box.remove(_userKey);
  }

  static Future<bool> isUserLoggedIn() async {
    final user = await getUser();
    return user != null;
  }

  // Firebase User Code methods
  static Future<bool> saveUserCode(FireUserData data) async {
    try {
      await _box.write(_userCodeKey, data.toMap());
      debugPrint("✅ User code saved successfully");
      return true;
    } catch (e) {
      debugPrint("❌ Error saveUserCode: $e");
      return false;
    }
  }

  static FireUserData? getUserCode() {
    try {
      final data = _box.read<Map<String, dynamic>>(_userCodeKey);

      if (data != null) {
        return FireUserData.fromMap(data);
      }

      return null;
    } catch (e) {
      debugPrint("❌ Error getUserCode: $e");
      return null;
    }
  }

  static Future<void> deleteUserCode() async {
    await _box.remove(_userCodeKey);
  }
}

class WatchingLocale {
  final GetStorage _box = GetStorage();
  static const String _watchingKey = 'watching_history';

  Future<void> saveWatching(WatchingModel watching) async {
    try {
      final List<WatchingModel> list = await getWatchingList();

      // Remove if already exists
      list.removeWhere(
          (item) => item.id == watching.id && item.type == watching.type);

      // Add to beginning
      list.insert(0, watching);

      // Keep only last 50 items
      if (list.length > 50) {
        list.removeRange(50, list.length);
      }

      final jsonList = list.map((e) => e.toJson()).toList();
      await _box.write(_watchingKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error saving watching: $e');
    }
  }

  Future<List<WatchingModel>> getWatchingList() async {
    try {
      final String? data = _box.read(_watchingKey);
      if (data == null) return [];

      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => WatchingModel.fromJson(e)).toList();
    } catch (e) {
      print('Error getting watching list: $e');
      return [];
    }
  }

  Future<void> removeWatching(String id, String type) async {
    try {
      final List<WatchingModel> list = await getWatchingList();
      list.removeWhere((item) => item.id == id && item.type == type);

      final jsonList = list.map((e) => e.toJson()).toList();
      await _box.write(_watchingKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error removing watching: $e');
    }
  }

  Future<void> clearWatching() async {
    await _box.remove(_watchingKey);
  }

  Future<WatchingModel?> getWatchingById(String id, String type) async {
    try {
      final List<WatchingModel> list = await getWatchingList();
      return list.firstWhere(
        (item) => item.id == id && item.type == type,
        orElse: () => WatchingModel(),
      );
    } catch (e) {
      return null;
    }
  }
}
