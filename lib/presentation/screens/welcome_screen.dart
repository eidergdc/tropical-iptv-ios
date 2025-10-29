import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tropical_iptv_ios/helpers/helpers.dart';
import 'package:tropical_iptv_ios/logic/blocs/categories/live_caty/live_caty_bloc.dart';
import 'package:tropical_iptv_ios/logic/blocs/categories/movie_caty/movie_caty_bloc.dart';
import 'package:tropical_iptv_ios/logic/blocs/categories/series_caty/series_caty_bloc.dart';
import 'package:tropical_iptv_ios/logic/blocs/auth/auth_bloc.dart';
import 'package:tropical_iptv_ios/repository/locale/locale.dart';
import 'package:tropical_iptv_ios/repository/models/user.dart';
import 'package:tropical_iptv_ios/repository/firebase/firebase_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Carregar categorias ao iniciar a tela
    context.read<LiveCatyBloc>().add(const LoadLiveCaty());
    context.read<MovieCatyBloc>().add(const LoadMovieCaty());
    context.read<SeriesCatyBloc>().add(const LoadSeriesCaty());
  }

  Future<void> _loadUserData() async {
    final user = await LocaleApi.getUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF0F0F0F),
              Color(0xFF0A0A0A),
            ],
            center: Alignment.center,
            radius: 1.5,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header com logo e botão de logout
              _buildHeader(),

              const SizedBox(height: 40),

              // Título de boas-vindas
              _buildWelcomeTitle(),

              const SizedBox(height: 60),

              // Cards de categorias
              Expanded(
                child: _buildCategoryCards(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kColorPrimary.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [kColorPrimary, kColorSecondary],
                      ),
                    ),
                    child: const Icon(
                      Icons.play_circle_outline,
                      size: 30,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),

          // Botão de configurações
          IconButton(
            onPressed: () {
              _showSettingsBottomSheet();
            },
            icon: Icon(
              Icons.settings,
              color: kColorTextSecondary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeTitle() {
    return Column(
      children: [
        Text(
          'Bem-vindo ao',
          style: TextStyle(
            fontSize: 24,
            color: kColorTextSecondary,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [kColorPrimary, kColorSecondary],
          ).createShader(bounds),
          child: const Text(
            'Tropical Play',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Escolha uma categoria para começar',
          style: TextStyle(
            fontSize: 16,
            color: kColorTextSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Live TV Card
          BlocBuilder<LiveCatyBloc, LiveCatyState>(
            builder: (context, state) {
              int categoryCount = 0;
              if (state is LiveCatySuccess) {
                categoryCount = state.categories.length;
              }

              return _buildCategoryCard(
                title: 'TV ao Vivo',
                subtitle: state is LiveCatyLoading
                    ? 'Carregando...'
                    : '$categoryCount categorias',
                icon: Icons.live_tv,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFF6B6B),
                    const Color(0xFFFF8E53),
                  ],
                ),
                onTap: state is LiveCatySuccess
                    ? () {
                        Get.toNamed('/live-tv');
                      }
                    : null,
              );
            },
          ),

          const SizedBox(height: 20),

          // Movies Card
          BlocBuilder<MovieCatyBloc, MovieCatyState>(
            builder: (context, state) {
              int categoryCount = 0;
              if (state is MovieCatySuccess) {
                categoryCount = state.categories.length;
              }

              return _buildCategoryCard(
                title: 'Filmes',
                subtitle: state is MovieCatyLoading
                    ? 'Carregando...'
                    : '$categoryCount categorias',
                icon: Icons.movie,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4E54C8),
                    const Color(0xFF8F94FB),
                  ],
                ),
                onTap: state is MovieCatySuccess
                    ? () {
                        Get.toNamed('/movies');
                      }
                    : null,
              );
            },
          ),

          const SizedBox(height: 20),

          // Series Card
          BlocBuilder<SeriesCatyBloc, SeriesCatyState>(
            builder: (context, state) {
              int categoryCount = 0;
              if (state is SeriesCatySuccess) {
                categoryCount = state.categories.length;
              }

              return _buildCategoryCard(
                title: 'Séries',
                subtitle: state is SeriesCatyLoading
                    ? 'Carregando...'
                    : '$categoryCount categorias',
                icon: Icons.tv,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF11998E),
                    const Color(0xFF38EF7D),
                  ],
                ),
                onTap: state is SeriesCatySuccess
                    ? () {
                        Get.toNamed('/series');
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                icon,
                size: 140,
                color: Colors.white.withOpacity(0.1),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      icon,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.8),
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: kColorElevated2,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: kColorTextSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Título
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: kColorPrimary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Configurações',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Informações da Conta
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kColorElevated1,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: kColorPrimary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: kColorPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Informações da Conta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Código',
                    currentUser?.userInfo?.username ?? 'N/A',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Servidor',
                    _getServerName(currentUser?.serverInfo?.serverUrl),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Status',
                    currentUser?.userInfo?.status ?? 'Active',
                    isStatus: true,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Vencimento',
                    _formatExpiryDate(currentUser?.userInfo?.expDate),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botão Trocar de Servidor
            ElevatedButton.icon(
              onPressed: () async {
                Get.back();

                // Carregar dados do Firebase
                if (currentUser?.userInfo?.username != null) {
                  try {
                    final firebaseService = FirebaseService();
                    final userData = await firebaseService.fetchUserData(
                      currentUser!.userInfo!.username!,
                    );

                    if (userData != null) {
                      Get.offAllNamed(
                        '/server-selection',
                        arguments: userData,
                      );
                    } else {
                      Get.snackbar(
                        'Erro',
                        'Não foi possível carregar os dados do usuário',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } catch (e) {
                    Get.snackbar(
                      'Erro',
                      'Erro ao carregar dados: ${e.toString()}',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  Get.snackbar(
                    'Erro',
                    'Usuário não encontrado',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              icon: const Icon(Icons.swap_horiz, size: 24),
              label: const Text(
                'Trocar de Servidor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),

            const SizedBox(height: 12),

            // Botão Logout
            OutlinedButton.icon(
              onPressed: () {
                Get.back();
                _showLogoutDialog();
              },
              icon: const Icon(Icons.logout, size: 24),
              label: const Text(
                'Sair da Conta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getServerName(String? serverUrl) {
    if (serverUrl == null || serverUrl.isEmpty) return 'N/A';

    // Extrair nome do servidor da URL
    if (serverUrl.contains('server.tropicalplaytv.com')) {
      return 'Tropical Play TV 1';
    } else if (serverUrl.contains('7now.top')) {
      return 'Tropical Play TV 2';
    } else if (serverUrl.contains('premiumserver.xyz')) {
      return 'Tropical Play TV 3';
    }

    // Se não reconhecer, retorna apenas o domínio
    try {
      final uri = Uri.parse(serverUrl);
      return uri.host;
    } catch (e) {
      return 'Servidor Desconhecido';
    }
  }

  String _formatExpiryDate(String? expDate) {
    if (expDate == null || expDate.isEmpty) return 'N/A';

    try {
      // Tentar parsear a data
      final date = DateTime.parse(expDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      // Se falhar, retornar a string original
      return expDate;
    }
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: kColorTextSecondary,
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

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: kColorElevated2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Sair',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Deseja realmente sair da sua conta?',
          style: TextStyle(
            color: kColorTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: kColorTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              context.read<AuthBloc>().add(AuthLogout());
              Get.offAllNamed(screenLogin);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Sair',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
