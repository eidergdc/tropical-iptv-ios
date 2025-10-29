# 📱 Tropical IPTV iOS - Resumo do Projeto

## 🎯 Objetivo
Criar um aplicativo IPTV para iPhone do zero, baseado no projeto **tropicaladmin-backup**, mantendo a mesma lógica mas otimizado especificamente para iOS.

## ✅ O Que Foi Criado

### 1. Estrutura Base do Projeto
```
tropical_iptv_ios/
├── lib/
│   ├── helpers/                    # ✅ Completo
│   │   ├── colors.dart            # Paleta de cores
│   │   ├── constants.dart         # Constantes do app
│   │   ├── routes.dart            # Rotas de navegação
│   │   ├── themes.dart            # Tema Material 3
│   │   ├── functions.dart         # Funções utilitárias
│   │   ├── toast.dart             # Notificações
│   │   └── date_format.dart       # Formatação de datas
│   │
│   ├── repository/                 # ✅ Completo
│   │   ├── models/                # Modelos de dados
│   │   │   ├── user.dart
│   │   │   ├── category.dart
│   │   │   ├── channel_live.dart
│   │   │   ├── channel_movie.dart
│   │   │   ├── channel_serie.dart
│   │   │   ├── epg.dart
│   │   │   ├── movie_detail.dart
│   │   │   ├── serie_details.dart
│   │   │   └── watching.dart
│   │   │
│   │   ├── api/                   # Serviços de API
│   │   │   ├── api.dart
│   │   │   ├── auth.dart          # Autenticação IPTV
│   │   │   └── iptv.dart          # Endpoints IPTV
│   │   │
│   │   ├── firebase/              # Firebase
│   │   │   └── firebase_service.dart
│   │   │
│   │   └── locale/                # Armazenamento local
│   │       ├── locale.dart        # GetStorage
│   │       ├── favorites.dart     # Favoritos
│   │       └── admob.dart         # AdMob IDs
│   │
│   ├── logic/                      # ⏳ Próxima fase
│   │   ├── blocs/                 # BLoCs
│   │   └── cubits/                # Cubits
│   │
│   ├── presentation/               # ⏳ Próxima fase
│   │   ├── screens/               # Telas
│   │   └── widgets/               # Widgets
│   │
│   ├── firebase_options.dart       # ✅ Configurado
│   └── main.dart                   # ✅ Criado
│
├── ios/
│   └── Runner/
│       ├── Info.plist              # ✅ Configurado
│       └── GoogleService-Info.plist # ✅ Copiado
│
├── assets/
│   └── images/                     # ✅ Criado
│
├── pubspec.yaml                    # ✅ Configurado
├── TODO.md                         # ✅ Atualizado
└── README.md                       # ✅ Criado
```

### 2. Configurações iOS (Info.plist)
✅ **Permissões configuradas:**
- NSAppTransportSecurity (HTTP não seguro)
- NSBonjourServices (Chromecast)
- NSLocalNetworkUsageDescription
- GADApplicationIdentifier (AdMob)
- FLTEnableImpeller=false (compatibilidade)

### 3. Firebase
✅ **Configurado com:**
- Project ID: `iptv-black`
- Bundle ID: `com.tropical.play`
- GoogleService-Info.plist copiado
- firebase_options.dart gerado

### 4. Dependências Instaladas (114 pacotes)
```yaml
# Estado
flutter_bloc: ^8.1.6
get: ^4.6.6

# Network
dio: ^5.9.0

# Firebase
firebase_core: ^3.15.2
cloud_firestore: ^5.6.12

# Storage
get_storage: ^2.1.1

# Video Players
flutter_vlc_player: ^7.4.4
pod_player: ^0.2.2
video_player: ^2.9.2

# UI
responsive_sizer: ^3.3.1
google_fonts: ^6.2.1
font_awesome_flutter: ^10.9.1
awesome_snackbar_content: ^0.1.6

# Ads
google_mobile_ads: ^5.3.1

# Utilities
intl: ^0.19.0
sqflite: ^2.4.1
url_launcher: ^6.3.1
```

### 5. Modelos de Dados Criados

#### UserModel
- UserInfo (username, password, status)
- ServerInfo (URL, port, protocol)
- Métodos de serialização JSON

#### CategoryModel
- ID, nome, tipo (live/vod/series)

#### ChannelLive
- Stream ID, nome, ícone
- EPG ID, TV archive
- Número do canal

#### ChannelMovie
- Stream ID, nome, capa
- Rating, container extension
- Informações adicionais

#### ChannelSerie
- Series ID, nome, capa
- Plot, cast, rating
- Backdrop path

#### EpgModel
- Programação de canais
- Start/end timestamps
- Descrição, has_archive

#### MovieDetail
- Info completa do filme
- Trailer, diretor, atores
- Rating, duração

#### SerieDetails
- Episódios por temporada
- Info da série
- Seasons com detalhes

#### WatchingModel
- Histórico de visualização
- Progresso, duração
- Última visualização

### 6. Repositórios/APIs

#### AuthApi
- `registerUser()` - Login IPTV
- `logout()` - Sair

#### IpTvApi
- `getCategories()` - Categorias
- `getLiveChannels()` - Canais ao vivo
- `getMovieChannels()` - Filmes
- `getSeriesChannels()` - Séries
- `getMovieDetails()` - Detalhes filme
- `getSerieDetails()` - Detalhes série
- `getEPGbyStreamId()` - EPG

#### FirebaseService
- `fetchUserData()` - Buscar usuário
- `updatePaymentStatus()` - Atualizar pagamento
- `createUser()` - Criar usuário

#### LocaleApi
- `saveUser()` - Salvar usuário
- `getUser()` - Obter usuário
- `deleteUser()` - Deletar usuário
- `isUserLoggedIn()` - Verificar login

#### FavoriteLocale
- `addFavorite()` - Adicionar favorito
- `removeFavorite()` - Remover favorito
- `getFavorites()` - Listar favoritos
- `isFavorite()` - Verificar favorito

#### WatchingLocale
- `saveWatching()` - Salvar histórico
- `getWatchingList()` - Listar histórico
- `removeWatching()` - Remover item
- `clearWatching()` - Limpar tudo

### 7. Helpers

#### Colors
- kColorPrimary: `#00D9FF` (Azul ciano)
- kColorSecondary: `#FF6B9D` (Rosa)
- kColorBackground: `#0A0E27`
- kColorCard: `#1A1F3A`
- Gradientes personalizados

#### Constants
- kAppName: "AZUL IPTV"
- showAds: false
- TypeCategory enum

#### Routes
- screenSplash: "/"
- screenIntro: "/intro"
- screenRegister: "/register"
- screenWelcome: "/welcome"
- etc.

#### Themes
- Material 3 Dark Theme
- Google Fonts (Poppins)
- Cores personalizadas
- Componentes estilizados

#### Functions
- buildLiveUrl() - URL stream ao vivo
- buildMovieUrl() - URL filme
- buildSeriesUrl() - URL série
- Validações

#### Toast
- showSuccessToast()
- showErrorToast()
- showWarningToast()
- showInfoToast()

#### DateFormat
- formatDate()
- formatDateTime()
- formatDuration()
- timeAgo()

## 🎨 Design

### Paleta de Cores
- **Primária:** Azul ciano vibrante (#00D9FF)
- **Secundária:** Rosa (#FF6B9D)
- **Background:** Azul escuro (#0A0E27)
- **Cards:** Azul médio (#1A1F3A)
- **Texto:** Branco/Cinza claro

### Tema
- Material Design 3
- Dark mode
- Fonte: Poppins (Google Fonts)
- Bordas arredondadas (12px)
- Elevação e sombras

## 📊 Status Atual

### ✅ Completo (Fases 1-4, 6)
1. ✅ Configuração inicial
2. ✅ Firebase e Assets
3. ✅ Modelos de dados
4. ✅ Repositórios
5. ⏳ BLoCs/Cubits (PRÓXIMO)
6. ✅ Helpers
7. ⏳ Telas
8. ⏳ Widgets
9. ⏳ Testes
10. ⏳ Build final

### 📝 Próximos Passos

1. **Criar BLoCs/Cubits:**
   - AuthBloc (autenticação)
   - CategoryBlocs (live, movies, series)
   - ChannelsBloc (listagem)
   - VideoCubit (player)
   - SettingsCubit
   - FavoritesCubit
   - WatchingCubit

2. **Criar Telas:**
   - SplashScreen
   - IntroScreen
   - RegisterScreen
   - WelcomeScreen
   - LiveScreen
   - MoviesScreen
   - SeriesScreen
   - PlayerScreen
   - FavouritesScreen
   - SettingsScreen

3. **Criar Widgets:**
   - Cards personalizados
   - Listas (live, movie, series)
   - Dialogs
   - Botões customizados
   - Player controls

4. **Testes:**
   - Testar no simulador iOS
   - Verificar navegação
   - Testar autenticação
   - Testar player
   - Testar no Chrome (visual)

## 🔧 Como Testar

### No Chrome (Visual):
```bash
cd tropical_iptv_ios
flutter run -d chrome
```

### No Simulador iOS:
```bash
cd tropical_iptv_ios
flutter run
```

### No iPhone Físico:
```bash
cd tropical_iptv_ios
flutter run -d 00008130-000229C80A93803A
```

## 📱 Funcionalidades Planejadas

### Autenticação
- Login com código Firebase
- Login com credenciais IPTV
- Verificação de pagamento
- Logout

### Live TV
- Listagem de categorias
- Listagem de canais
- EPG (guia de programação)
- Catch-up TV (arquivo)
- Player ao vivo

### Movies (VOD)
- Categorias de filmes
- Listagem com capas
- Detalhes (sinopse, elenco, trailer)
- Player de filmes
- Favoritos

### Series
- Categorias de séries
- Listagem com capas
- Temporadas e episódios
- Detalhes completos
- Player de episódios
- Controle de progresso

### Player
- Controles completos
- Fullscreen
- Orientação automática
- Chromecast
- Controle de volume
- Brilho da tela
- Seek/scrub

### Extras
- Favoritos sincronizados
- Histórico de visualização
- Busca global
- Configurações
- Tema escuro
- Notificações

## 🎯 Diferenças do Original

### Otimizações para iOS:
1. ✅ Configurações específicas iOS
2. ✅ Permissões de rede local
3. ✅ Suporte a Chromecast
4. ✅ Orientação portrait/landscape
5. ✅ Material 3 design
6. ✅ Responsive design
7. ✅ Firebase iOS configurado

### Melhorias:
- Código mais organizado
- Separação clara de responsabilidades
- Modelos tipados
- Error handling
- Loading states
- Offline support (GetStorage)

## 📄 Arquivos Importantes

- `lib/main.dart` - Entry point
- `lib/firebase_options.dart` - Config Firebase
- `ios/Runner/Info.plist` - Permissões iOS
- `ios/Runner/GoogleService-Info.plist` - Firebase iOS
- `pubspec.yaml` - Dependências
- `TODO.md` - Roadmap
- `README.md` - Documentação

## 🚀 Pronto Para

- ✅ Compilar
- ✅ Rodar no Chrome (teste visual)
- ✅ Rodar no simulador iOS
- ✅ Conectar com API IPTV
- ✅ Autenticar usuários
- ⏳ Implementar UI (próximo passo)

---

**Status:** Projeto base completo e funcional. Pronto para implementação da camada de apresentação (UI).
