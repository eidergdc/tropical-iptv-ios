import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tropical_iptv_ios/helpers/helpers.dart';
import 'package:tropical_iptv_ios/logic/blocs/auth/auth_bloc.dart';
import 'package:tropical_iptv_ios/presentation/widgets/auth_widgets.dart';
import 'package:tropical_iptv_ios/presentation/screens/server_selection_screen.dart';
import 'package:tropical_iptv_ios/repository/firebase/firebase_service.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  final FirebaseService firebaseService = FirebaseService();
  final _codeController = TextEditingController();
  FireUserData? fireUserData;
  FireIptv? selectedAccount;

  @override
  void initState() {
    super.initState();
    // Limpa ao entrar na tela
    _codeController.text = '';
    selectedAccount = null;
  }

  Future<void> _checkFirebaseCode() async {
    if (_codeController.text.trim().isEmpty) {
      _showError('Por favor, insira um código válido.');
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final data =
          await firebaseService.fetchUserData(_codeController.text.trim());

      if (data != null) {
        setState(() {
          _loading = false;
        });

        debugPrint(
            "✅ Código validado! ${data.lists.length} contas encontradas");

        // Navegar para tela de seleção de servidores
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServerSelectionScreen(userData: data),
            ),
          );
        }
      } else {
        setState(() {
          _loading = false;
        });
        _showError(
            'O código inserido não existe. Entre em contato com o suporte.');
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      _showError('Erro ao validar código: $e');
    }
  }

  void _loginFunction() {
    if (selectedAccount == null) {
      _showError('Por favor, selecione uma conta IPTV.');
      return;
    }

    if (fireUserData == null) {
      _showError('Dados do usuário não encontrados.');
      return;
    }

    if (!fireUserData!.paymentStatus) {
      _showError('Pagamento não verificado. Entre em contato com o suporte.');
      return;
    }

    // Verificar se a conta expirou
    if (fireUserData!.expiresAt.isBefore(DateTime.now())) {
      _showError('Sua conta expirou. Entre em contato com o suporte.');
      return;
    }

    try {
      final txt = selectedAccount!.url;
      Uri url = Uri.parse(txt);
      var parameters = url.queryParameters;

      debugPrint("🔗 URL: ${url.scheme}://${url.host}:${url.port}");

      String username = parameters['username'].toString();
      String password = parameters['password'].toString();
      String url0 =
          "${url.scheme}://${url.host}${url.hasPort ? ":${url.port}" : ""}";

      debugPrint("👤 Username: $username");
      debugPrint("🔐 Password: $password");
      debugPrint("🌐 Server: $url0");

      // Disparar evento de login
      context.read<AuthBloc>().add(AuthRegister(username, password, url0));
    } catch (e) {
      _showError('Erro ao processar URL da conta: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kColorPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            _showError('Login falhou. Verifique suas credenciais IPTV.');
          } else if (state is AuthSuccess) {
            _showSuccess('Login realizado com sucesso!');
            // Navegar para a tela principal
            // Navigator.pushReplacementNamed(context, '/home');
          }
        },
        builder: (context, state) {
          final isAuthLoading = state is AuthLoading;
          final isLoading = _loading || isAuthLoading;

          return SafeArea(
            child: IgnorePointer(
              ignoring: isLoading,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo com efeito de brilho
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kColorPrimary.withOpacity(0.3),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Título
                    Text(
                      'Bem-vindo ao Tropical Play',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Subtítulo
                    Text(
                      'Entre para descobrir filmes, séries e TV ao vivo',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: kColorTextSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // Campo de código
                    TropicalTextField(
                      controller: _codeController,
                      hintText: 'Código de Acesso',
                      keyboardType: TextInputType.number,
                      icon: Icons.vpn_key_rounded,
                    ),

                    const SizedBox(height: 24),

                    // Dropdown de contas IPTV (aparece após validar código)
                    if (fireUserData != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: kColorSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: kColorBorder,
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<FireIptv>(
                            hint: Text(
                              selectedAccount == null
                                  ? 'Selecione uma Conta IPTV'
                                  : selectedAccount!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: selectedAccount == null
                                        ? kColorTextSecondary
                                        : Colors.white,
                                  ),
                            ),
                            isExpanded: true,
                            dropdownColor: kColorSurface,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: kColorPrimary,
                            ),
                            items: fireUserData!.lists.map((account) {
                              return DropdownMenuItem<FireIptv>(
                                value: account,
                                child: Text(
                                  account.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              );
                            }).toList(),
                            onChanged: isLoading
                                ? null
                                : (FireIptv? value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedAccount = value;
                                      });
                                    }
                                  },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Informações da conta
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: kColorSurface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: kColorBorder.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  fireUserData!.paymentStatus
                                      ? Icons.check_circle
                                      : Icons.warning,
                                  color: fireUserData!.paymentStatus
                                      ? Colors.green
                                      : Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  fireUserData!.paymentStatus
                                      ? 'Pagamento Verificado'
                                      : 'Pagamento Pendente',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: fireUserData!.paymentStatus
                                            ? Colors.green
                                            : Colors.orange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Expira em: ${_formatDate(fireUserData!.expiresAt)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: kColorTextSecondary,
                                  ),
                            ),
                            Text(
                              'Contas disponíveis: ${fireUserData!.lists.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: kColorTextSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],

                    // Botão de ação
                    CardTallButton(
                      label: selectedAccount == null
                          ? 'Validar Código'
                          : 'Entrar com ${selectedAccount!.name}',
                      onTap: () {
                        if (selectedAccount != null) {
                          _loginFunction();
                        } else if (_codeController.text.isNotEmpty) {
                          _checkFirebaseCode();
                        }
                      },
                      isLoading: isLoading,
                    ),

                    const SizedBox(height: 24),

                    // Link de privacidade
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Ao entrar, você concorda com nossa ',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: kColorTextSecondary,
                                  ),
                        ),
                        InkWell(
                          onTap: () async {
                            final url = Uri.parse(kPrivacy);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Text(
                            'Política de Privacidade',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: kColorPrimary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
