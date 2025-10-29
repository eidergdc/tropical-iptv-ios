import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tropical_iptv_ios/helpers/helpers.dart';
import 'package:tropical_iptv_ios/logic/blocs/auth/auth_bloc.dart';
import 'package:tropical_iptv_ios/repository/locale/locale.dart';
import 'package:tropical_iptv_ios/repository/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await LocaleApi.getUser();
    if (user != null) {
      // User is logged in, navigate to welcome screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/welcome');
      });
    }
    setState(() {
      currentUser = user;
    });
  }

  void _logout() {
    context.read<AuthBloc>().add(AuthLogout());
    Navigator.pushReplacementNamed(context, screenLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: currentUser == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFDB813),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tropical Play TV',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Color(0xFFFDB813),
                          ),
                          onPressed: _logout,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Success Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.green,
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Success Message
                    const Text(
                      '🎉 Login Realizado com Sucesso!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Você está conectado ao servidor IPTV',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // User Info Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFDB813).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Color(0xFFFDB813),
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Informações da Conta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                            'Username',
                            currentUser?.userInfo?.username ?? 'N/A',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Servidor',
                            currentUser?.serverInfo?.serverUrl ?? 'N/A',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Status',
                            currentUser?.userInfo?.status ?? 'Active',
                            isStatus: true,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Coming Soon Message
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDB813).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFDB813).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.construction,
                            color: Color(0xFFFDB813),
                            size: 40,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Em Desenvolvimento',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'As telas de canais, filmes e séries\nserão implementadas em breve!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Row(
          children: [
            if (isStatus)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
