# 🔄 Fluxo Completo de Login - Tropical IPTV iOS

## 📱 O Que Acontece Após Escolher um Servidor?

### Passo a Passo Detalhado:

---

## 1️⃣ **Usuário Seleciona um Servidor**

Na tela `ServerSelectionScreen`, o usuário:
- Vê a lista de servidores disponíveis
- Clica em um servidor (ex: "Tropical Play TV 1")
- O card fica destacado em amarelo ✨
- Botão muda para "Conectar ao Tropical Play TV 1"

---

## 2️⃣ **Usuário Clica em "Conectar"**

### O que acontece no código:

```dart
Future<void> _connectToServer() async {
  // 1. Pega o servidor selecionado
  final selectedAccount = widget.userData.lists[selectedServerIndex!];
  
  // 2. Extrai credenciais da URL
  final uri = Uri.parse(selectedAccount.url);
  // URL exemplo: http://server.tropicalplaytv.com:80/get.php?username=648718886&password=161225219&type=m3u_plus&output=ts
  
  final username = uri.queryParameters['username'];  // "648718886"
  final password = uri.queryParameters['password'];  // "161225219"
  final server = '${uri.scheme}://${uri.host}:${uri.port}';  // "http://server.tropicalplaytv.com:80"
  
  // 3. Dispara evento de login
  context.read<AuthBloc>().add(
    AuthRegister(username, password, server),
  );
}
```

### Logs no Console:
```
🔗 Conectando ao servidor: http://server.tropicalplaytv.com:80
👤 Username: 648718886
🔐 Password: 161225219
🌐 Server: http://server.tropicalplaytv.com:80
```

---

## 3️⃣ **AuthBloc Processa o Login**

### No arquivo `auth_bloc.dart`:

```dart
Future<void> _onAuthRegister(
  AuthRegister event,
  Emitter<AuthState> emit,
) async {
  // 1. Emite estado de loading
  emit(AuthLoading());

  try {
    // 2. Chama API IPTV para validar credenciais
    final user = await _authApi.registerUser(
      event.username,  // "648718886"
      event.password,  // "161225219"
      event.url,       // "http://server.tropicalplaytv.com:80"
    );

    if (user != null) {
      // 3. Login bem-sucedido!
      emit(AuthSuccess(user));
    } else {
      // 4. Login falhou
      emit(AuthFailed('Login failed. Please check your credentials.'));
    }
  } catch (e) {
    emit(AuthFailed('An error occurred: ${e.toString()}'));
  }
}
```

---

## 4️⃣ **API IPTV Valida as Credenciais**

### No arquivo `auth.dart`:

A API faz uma requisição para o servidor IPTV:

```dart
Future<User?> registerUser(String username, String password, String url) async {
  try {
    // Monta URL de autenticação
    final authUrl = '$url/player_api.php?username=$username&password=$password';
    
    // Faz requisição HTTP
    final response = await http.get(Uri.parse(authUrl));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // Cria objeto User com dados do servidor
      final user = User(
        username: username,
        password: password,
        serverUrl: url,
        userInfo: data['user_info'],
        serverInfo: data['server_info'],
      );
      
      // Salva localmente
      await LocaleApi.saveUser(user);
      
      return user;
    }
    
    return null;
  } catch (e) {
    return null;
  }
}
```

### O que a API retorna:

```json
{
  "user_info": {
    "username": "648718886",
    "password": "161225219",
    "message": "Active",
    "auth": 1,
    "status": "Active",
    "exp_date": "1777608000",
    "is_trial": "0",
    "active_cons": "0",
    "created_at": "1746563722",
    "max_connections": "1",
    "allowed_output_formats": ["m3u8", "ts", "rtmp"]
  },
  "server_info": {
    "url": "http://server.tropicalplaytv.com:80",
    "port": "80",
    "https_port": "443",
    "server_protocol": "http",
    "rtmp_port": "1935",
    "timezone": "America/Sao_Paulo",
    "timestamp_now": 1730000000,
    "time_now": "2024-10-29 15:00:00"
  }
}
```

---

## 5️⃣ **BlocListener Reage ao Estado**

### Na `ServerSelectionScreen`:

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      // ✅ LOGIN BEM-SUCEDIDO!
      
      // Opção 1: Navegar para tela Welcome (se existir)
      Navigator.pushReplacementNamed(context, '/welcome');
      
      // Opção 2: Navegar para tela de categorias Live
      Navigator.pushReplacementNamed(context, '/categories-live');
      
      // Opção 3: Navegar para tela principal (Home)
      // Navigator.pushReplacementNamed(context, '/home');
      
    } else if (state is AuthFailed) {
      // ❌ LOGIN FALHOU
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: // ... UI da tela
)
```

---

## 6️⃣ **Navegação Pós-Login**

### Atualmente, o projeto tem estas rotas definidas:

```dart
const String screenSplash = "/";
const String screenLogin = "/login";
const String screenWelcome = "/welcome";           // ← Próxima tela?
const String screenIntro = "/intro";
const String screenRegister = "/register";
const String screenRegisterTv = "/register-tv";
const String screenSettings = "/settings";
const String screenFavourite = "/favourite";
const String screenCatchUp = "/catchup";
const String screenMovies = "/movies";
const String screenSeries = "/series";
const String screenLiveCategories = "/categories-live";  // ← Ou esta?
const String screenMovieCategories = "/categories-movie";
const String screenSeriesCategories = "/categories-series";
```

### 🎯 Próxima Tela Sugerida:

**Opção 1: Welcome Screen** (Tela de boas-vindas)
- Mostra informações do usuário
- Botões para: TV ao Vivo, Filmes, Séries
- Acesso rápido a favoritos

**Opção 2: Live Categories** (Categorias de TV ao Vivo)
- Lista de categorias de canais
- Ex: Esportes, Notícias, Entretenimento, etc.

---

## 🔄 Fluxo Visual Completo

```
┌─────────────────────────────────────┐
│     1. Login Screen                 │
│     Digite código: 648718886        │
│     [Validar Código]                │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  2. Server Selection Screen         │
│  ○ Tropical Play TV 1               │
│  ○ Tropical Play TV 2               │
│  ● Tropical Play TV 3 (selecionado) │
│  [Conectar ao Tropical Play TV 3]   │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  3. Loading...                      │
│  🔄 Conectando ao servidor...       │
│  Validando credenciais IPTV...      │
└─────────────────────────────────────┘
              ↓
        ┌─────┴─────┐
        │           │
    ✅ Sucesso   ❌ Falha
        │           │
        ↓           ↓
┌───────────┐  ┌────────────┐
│  Welcome  │  │   Erro     │
│  Screen   │  │  Mensagem  │
│           │  │  [Tentar   │
│  ou       │  │   Novamente]│
│           │  └────────────┘
│  Live     │
│Categories │
└───────────┘
```

---

## 📊 Estados do AuthBloc

### Estados Possíveis:

1. **AuthInitial** - Estado inicial
2. **AuthLoading** - Processando login
3. **AuthSuccess(User user)** - Login bem-sucedido ✅
4. **AuthFailed(String message)** - Login falhou ❌
5. **AuthLoggedOut** - Usuário fez logout

---

## 🎯 O Que Precisa Ser Implementado

### ⏳ Pendente:

1. **BlocListener na ServerSelectionScreen**
   - Adicionar listener para reagir aos estados
   - Navegar para próxima tela em caso de sucesso
   - Mostrar erro em caso de falha

2. **Definir Tela de Destino**
   - Welcome Screen (se existir)
   - Live Categories (se existir)
   - Ou criar uma nova Home Screen

3. **Tratamento de Erros**
   - Mensagens de erro mais específicas
   - Opção de tentar novamente
   - Voltar para seleção de servidor

---

## 💡 Exemplo de Implementação Completa

### Adicionar ao `ServerSelectionScreen`:

```dart
@override
Widget build(BuildContext context) {
  return BlocListener<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthSuccess) {
        // Login bem-sucedido!
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Login realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navegar para próxima tela
        Navigator.pushReplacementNamed(context, '/welcome');
        
      } else if (state is AuthFailed) {
        // Login falhou
        setState(() {
          isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${state.message}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Tentar Novamente',
              textColor: Colors.white,
              onPressed: () {
                // Tentar conectar novamente
                _connectToServer();
              },
            ),
          ),
        );
      }
    },
    child: Scaffold(
      // ... resto da UI
    ),
  );
}
```

---

## 🎉 Resumo

### O que acontece após escolher um servidor:

1. ✅ Extrai credenciais da URL do servidor
2. ✅ Dispara evento `AuthRegister` no BLoC
3. ✅ AuthBloc chama API IPTV para validar
4. ✅ API retorna dados do usuário e servidor
5. ✅ Dados são salvos localmente
6. ✅ Estado muda para `AuthSuccess`
7. ⏳ **Navega para próxima tela** (a ser implementado)

### Próximo Passo:

Adicionar o `BlocListener` na `ServerSelectionScreen` para navegar automaticamente para a próxima tela após login bem-sucedido!

---

**Status Atual:** ✅ Lógica de login implementada  
**Pendente:** ⏳ Navegação pós-login e tela de destino
