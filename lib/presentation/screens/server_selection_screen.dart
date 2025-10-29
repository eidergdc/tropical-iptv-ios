import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tropical_iptv_ios/helpers/helpers.dart';
import 'package:tropical_iptv_ios/logic/blocs/auth/auth_bloc.dart';
import 'package:tropical_iptv_ios/repository/firebase/firebase_service.dart';
import 'package:tropical_iptv_ios/presentation/widgets/auth_widgets.dart';

class ServerSelectionScreen extends StatefulWidget {
  final FireUserData userData;

  const ServerSelectionScreen({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<ServerSelectionScreen> createState() => _ServerSelectionScreenState();
}

class _ServerSelectionScreenState extends State<ServerSelectionScreen> {
  int? selectedServerIndex;
  bool isLoading = false;

  void _selectServer(int index) {
    setState(() {
      selectedServerIndex = index;
    });
  }

  Future<void> _connectToServer() async {
    if (selectedServerIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um servidor'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final selectedAccount = widget.userData.lists[selectedServerIndex!];
      final uri = Uri.parse(selectedAccount.url);

      final username = uri.queryParameters['username'] ?? '';
      final password = uri.queryParameters['password'] ?? '';
      final server = '${uri.scheme}://${uri.host}:${uri.port}';

      print('🔗 Conectando ao servidor: $server');
      print('👤 Username: $username');
      print('🔐 Password: $password');

      // Dispara evento de registro no AuthBloc
      context.read<AuthBloc>().add(
            AuthRegister(username, password, server),
          );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao processar servidor: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Login bem-sucedido!
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Login realizado com sucesso!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Navegar para tela Home
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthFailed) {
          // Login falhou
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.message}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Tentar Novamente',
                textColor: Colors.white,
                onPressed: () {
                  _connectToServer();
                },
              ),
            ),
          );
        } else if (state is AuthLoading) {
          // Mantém loading state
          if (!isLoading) {
            setState(() {
              isLoading = true;
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Escolha o Servidor',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.only(left: 56),
                  child: Text(
                    'Selecione qual servidor deseja usar',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // User Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFDB813).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            widget.userData.paymentStatus
                                ? Icons.verified
                                : Icons.warning,
                            color: widget.userData.paymentStatus
                                ? Colors.green
                                : Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.userData.paymentStatus
                                ? 'Pagamento Verificado'
                                : 'Pagamento Pendente',
                            style: TextStyle(
                              color: widget.userData.paymentStatus
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Código: ${widget.userData.userNumber}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Válido até: ${widget.userData.expiresAt.day}/${widget.userData.expiresAt.month}/${widget.userData.expiresAt.year}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Servers List
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.userData.lists.length,
                    itemBuilder: (context, index) {
                      final server = widget.userData.lists[index];
                      final isSelected = selectedServerIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => _selectServer(index),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFDB813).withOpacity(0.15)
                                  : const Color(0xFF121212),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFDB813)
                                    : const Color(0xFFFDB813).withOpacity(0.2),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFFFDB813)
                                            .withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                // Server Icon
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFFDB813)
                                        : const Color(0xFFFDB813)
                                            .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.dns_rounded,
                                    color: isSelected
                                        ? Colors.black
                                        : const Color(0xFFFDB813),
                                    size: 28,
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // Server Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        server.name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Servidor ${index + 1}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Selection Indicator
                                if (isSelected)
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFDB813),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                  )
                                else
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Connect Button
                CardTallButton(
                  label: selectedServerIndex != null
                      ? 'Conectar ao ${widget.userData.lists[selectedServerIndex!].name}'
                      : 'Selecione um Servidor',
                  onTap: _connectToServer,
                  isLoading: isLoading,
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
