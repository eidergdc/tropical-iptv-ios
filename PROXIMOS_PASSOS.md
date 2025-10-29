# 🚀 Próximos Passos - Tropical IPTV iOS

## ✅ O Que Já Está Pronto

### Infraestrutura Completa (60% do projeto)
- ✅ Projeto Flutter configurado
- ✅ Firebase integrado (iOS)
- ✅ 9 modelos de dados criados
- ✅ 4 repositórios/APIs implementados
- ✅ 7 helpers utilitários
- ✅ Configurações iOS (Info.plist)
- ✅ 114 dependências instaladas
- ✅ Estrutura de pastas organizada

## 📋 Fase 5: BLoCs e Cubits (PRÓXIMO)

### 1. AuthBloc
**Arquivo:** `lib/logic/blocs/auth_bloc.dart`

**Estados:**
- AuthInitial
- AuthLoading
- AuthSuccess (UserModel)
- AuthError (String message)

**Eventos:**
- LoginRequested (username, password, serverUrl)
- LogoutRequested
- CheckAuthStatus

**Implementação:**
```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApi _authApi = AuthApi();
  
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authApi.registerUser(
        event.username,
        event.password,
        event.serverUrl,
      );
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthError('Credenciais inválidas'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
```

### 2. CategoryBlocs (3 arquivos)

#### LiveCategoryBloc
**Arquivo:** `lib/logic/blocs/live_category_bloc.dart`
- Gerencia categorias de canais ao vivo
- Usa `IpTvApi().getCategories('get_live_categories')`

#### MovieCategoryBloc
**Arquivo:** `lib/logic/blocs/movie_category_bloc.dart`
- Gerencia categorias de filmes
- Usa `IpTvApi().getCategories('get_vod_categories')`

#### SeriesCategoryBloc
**Arquivo:** `lib/logic/blocs/series_category_bloc.dart`
- Gerencia categorias de séries
- Usa `IpTvApi().getCategories('get_series_categories')`

### 3. ChannelsBloc
**Arquivo:** `lib/logic/blocs/channels_bloc.dart`

**Responsabilidades:**
- Carregar canais por categoria
- Suportar Live, Movies e Series
- Paginação e busca

### 4. Cubits Simples

#### VideoCubit
**Arquivo:** `lib/logic/cubits/video_cubit.dart`
```dart
class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoInitial());
  
  void play(String url) => emit(VideoPlaying(url));
  void pause() => emit(VideoPaused());
  void stop() => emit(VideoStopped());
  void updateProgress(Duration position, Duration duration) {
    emit(VideoProgress(position, duration));
  }
}
```

#### FavoritesCubit
**Arquivo:** `lib/logic/cubits/favorites_cubit.dart`
- Gerencia favoritos usando `FavoriteLocale`
- Estados: loading, loaded, error

#### WatchingCubit
**Arquivo:** `lib/logic/cubits/watching_cubit.dart`
- Gerencia histórico usando `WatchingLocale`
- Salva progresso de visualização

#### SettingsCubit
**Arquivo:** `lib/logic/cubits/settings_cubit.dart`
- Tema, idioma, qualidade de vídeo
- Preferências do usuário

## 📱 Fase 7: Telas (UI)

### 1. SplashScreen
**Arquivo:** `lib/presentation/screens/splash_screen.dart`

**Funcionalidade:**
- Logo animado
- Verificar autenticação
- Navegar para Intro ou Welcome

**Código base:**
```dart
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }
  
  Future<void> _checkAuth() async {
    await Future.delayed(Duration(seconds: 2));
    final isLoggedIn = await LocaleApi.isUserLoggedIn();
    
    if (isLoggedIn) {
      Get.offAllNamed(screenWelcome);
    } else {
      Get.offAllNamed(screenIntro);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: kGradientPrimary,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.tv, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                kAppName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 2. IntroScreen
**Arquivo:** `lib/presentation/screens/intro_screen.dart`

**Funcionalidade:**
- Slides de apresentação
- Botão "Começar"
- Navegar para RegisterScreen

### 3. RegisterScreen
**Arquivo:** `lib/presentation/screens/register_screen.dart`

**Funcionalidade:**
- Formulário de login
- Campos: username, password, server URL
- BlocConsumer<AuthBloc, AuthState>
- Validação de campos
- Loading indicator
- Navegar para WelcomeScreen após sucesso

**Widgets necessários:**
- TextFormField customizado
- Botão de login
- Logo

### 4. WelcomeScreen (Home)
**Arquivo:** `lib/presentation/screens/welcome_screen.dart`

**Funcionalidade:**
- Bottom Navigation Bar (Live, Movies, Series, Favorites)
- AppBar com logo e configurações
- Drawer com opções

**Estrutura:**
```dart
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    LiveScreen(),
    MoviesScreen(),
    SeriesScreen(),
    FavouritesScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kAppName),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Get.toNamed(screenSettings),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Filmes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Séries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
```

### 5. LiveScreen
**Arquivo:** `lib/presentation/screens/live/live_screen.dart`

**Funcionalidade:**
- Lista de categorias (horizontal)
- Grid de canais
- BlocBuilder<LiveCategoryBloc>
- Ao clicar: abrir PlayerScreen

### 6. MoviesScreen
**Arquivo:** `lib/presentation/screens/movies/movies_screen.dart`

**Funcionalidade:**
- Categorias de filmes
- Grid de filmes com capas
- Ao clicar: MovieDetailScreen

### 7. MovieDetailScreen
**Arquivo:** `lib/presentation/screens/movies/movie_detail_screen.dart`

**Funcionalidade:**
- Capa grande
- Sinopse, elenco, diretor
- Rating
- Botão "Assistir"
- Botão "Favoritar"
- Trailer (YouTube)

### 8. SeriesScreen
**Arquivo:** `lib/presentation/screens/series/series_screen.dart`

**Funcionalidade:**
- Categorias de séries
- Grid de séries
- Ao clicar: SerieDetailScreen

### 9. SerieDetailScreen
**Arquivo:** `lib/presentation/screens/series/serie_detail_screen.dart`

**Funcionalidade:**
- Info da série
- Lista de temporadas
- Lista de episódios
- Botão play por episódio

### 10. PlayerScreen
**Arquivo:** `lib/presentation/screens/player/player_screen.dart`

**Funcionalidade:**
- Video player (VLC ou Pod Player)
- Controles customizados
- Fullscreen
- Orientação landscape automática
- Controle de volume
- Seek bar
- Botão Chromecast
- EPG (para live)

**Estrutura:**
```dart
class PlayerScreen extends StatefulWidget {
  final String url;
  final String title;
  final String type; // live, movie, series
  
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VlcPlayerController _controller;
  bool _showControls = true;
  
  @override
  void initState() {
    super.initState();
    _initPlayer();
  }
  
  void _initPlayer() {
    _controller = VlcPlayerController.network(
      widget.url,
      autoPlay: true,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: VlcPlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
          ),
          if (_showControls)
            PlayerControls(
              controller: _controller,
              title: widget.title,
            ),
        ],
      ),
    );
  }
}
```

### 11. FavouritesScreen
**Arquivo:** `lib/presentation/screens/favourites_screen.dart`

**Funcionalidade:**
- Tabs: Live, Movies, Series
- Lista de favoritos
- BlocBuilder<FavoritesCubit>

### 12. SettingsScreen
**Arquivo:** `lib/presentation/screens/settings_screen.dart`

**Funcionalidade:**
- Qualidade de vídeo
- Tema
- Sobre
- Logout

## 🎨 Fase 8: Widgets

### Cards
1. **LiveChannelCard** - Card de canal ao vivo
2. **MovieCard** - Card de filme com capa
3. **SerieCard** - Card de série
4. **CategoryCard** - Card de categoria

### Listas
1. **CategoryList** - Lista horizontal de categorias
2. **ChannelGrid** - Grid de canais/filmes/séries
3. **EpisodeList** - Lista de episódios

### Dialogs
1. **LoadingDialog** - Dialog de carregamento
2. **ErrorDialog** - Dialog de erro
3. **ConfirmDialog** - Dialog de confirmação

### Player
1. **PlayerControls** - Controles do player
2. **SeekBar** - Barra de progresso
3. **VolumeControl** - Controle de volume

## 🧪 Fase 9: Testes

### Testes no Simulador iOS
```bash
# Abrir simulador
open -a Simulator

# Rodar app
cd tropical_iptv_ios
flutter run
```

### Checklist de Testes
- [ ] Splash screen aparece
- [ ] Navegação funciona
- [ ] Login com credenciais válidas
- [ ] Carregar categorias
- [ ] Carregar canais
- [ ] Abrir player
- [ ] Reproduzir vídeo
- [ ] Controles do player
- [ ] Favoritar item
- [ ] Ver histórico
- [ ] Logout

## 🔨 Comandos Úteis

### Desenvolvimento
```bash
# Rodar no simulador
flutter run

# Rodar no iPhone físico
flutter run -d 00008130-000229C80A93803A

# Hot reload
r

# Hot restart
R

# Limpar build
flutter clean

# Atualizar dependências
flutter pub get

# Analisar código
flutter analyze

# Formatar código
flutter format lib/
```

### Build
```bash
# Build iOS
flutter build ios

# Build para release
flutter build ios --release

# Criar IPA
flutter build ipa
```

## 📚 Recursos Úteis

### Documentação
- [Flutter Docs](https://docs.flutter.dev/)
- [BLoC Pattern](https://bloclibrary.dev/)
- [GetX](https://pub.dev/packages/get)
- [VLC Player](https://pub.dev/packages/flutter_vlc_player)

### Exemplos de Código
- Ver `tropicaladmin-backup` para referência
- Adaptar lógica para BLoC pattern
- Manter mesma estrutura de API

## 🎯 Prioridades

### Alta Prioridade
1. ✅ AuthBloc
2. ✅ SplashScreen
3. ✅ RegisterScreen
4. ✅ WelcomeScreen
5. ✅ LiveScreen básico
6. ✅ PlayerScreen básico

### Média Prioridade
7. MoviesScreen
8. SeriesScreen
9. FavouritesScreen
10. Widgets customizados

### Baixa Prioridade
11. Animações
12. Otimizações
13. Testes unitários
14. CI/CD

## 💡 Dicas

1. **Comece simples:** Implemente funcionalidades básicas primeiro
2. **Teste frequentemente:** Rode no simulador a cada mudança
3. **Use hot reload:** Acelera o desenvolvimento
4. **Siga o padrão:** Mantenha consistência com o código existente
5. **Documente:** Adicione comentários em código complexo

## 🚀 Começar Agora

```bash
# 1. Criar AuthBloc
mkdir -p lib/logic/blocs
touch lib/logic/blocs/auth_bloc.dart

# 2. Criar SplashScreen
mkdir -p lib/presentation/screens
touch lib/presentation/screens/splash_screen.dart

# 3. Testar
flutter run
```

---

**Próximo arquivo a criar:** `lib/logic/blocs/auth_bloc.dart`

**Tempo estimado para completar UI:** 2-3 dias de desenvolvimento
