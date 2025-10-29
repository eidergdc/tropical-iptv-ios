# 📋 Plano de Implementação - Menu Principal (Welcome Screen)

## 🎯 Objetivo
Criar tela de menu principal (Welcome Screen) com navegação para Live TV, Movies e Series, baseada no tropicaladmin-backup.

---

## 📊 Análise do Projeto Original

### Estrutura do tropicaladmin-backup:

**WelcomeScreen** (Menu Principal):
- 3 cards principais: Live TV, Movies, Series
- Cada card mostra quantidade de canais/categorias
- Cards laterais: Catch Up, Favourites, Settings
- Usa BLoCs para carregar categorias: LiveCatyBloc, MovieCatyBloc, SeriesCatyBloc

**Navegação:**
```
WelcomeScreen
├── Live TV → LiveCategoriesScreen → LiveChannelsScreen → Player
├── Movies → MovieCategoriesScreen → MovieChannelsScreen → MovieDetails → Player
└── Series → SeriesCategoriesScreen → SeriesChannelsScreen → SerieDetails → Player
```

---

## 🏗️ Arquitetura Atual do tropical_iptv_ios

### ✅ Já Implementado:
1. **Models**: CategoryModel, ChannelLive, ChannelMovie, ChannelSerie
2. **API**: IpTvApi com métodos para buscar categorias e canais
3. **BLoCs**: AuthBloc (funcionando)
4. **Telas**: LoginScreen, ServerSelectionScreen, HomeScreen (temporária)

### ❌ Faltando:
1. **BLoCs de Categorias**: LiveCatyBloc, MovieCatyBloc, SeriesCatyBloc
2. **BLoCs de Canais**: ChannelsBloc
3. **Cubits**: VideoCubit, SettingsCubit, WatchingCubit, FavoritesCubit
4. **Telas**:
   - WelcomeScreen (menu principal)
   - LiveCategoriesScreen
   - LiveChannelsScreen
   - MovieCategoriesScreen
   - MovieChannelsScreen
   - SeriesCategoriesScreen
   - SeriesChannelsScreen
   - Player screens
5. **Widgets**: Cards customizados, AppBars específicos

---

## 📝 Plano de Implementação

### **FASE 1: BLoCs de Categorias** ✅ PRIORIDADE MÁXIMA

#### 1.1 LiveCatyBloc
**Arquivo**: `lib/logic/blocs/categories/live_caty/live_caty_bloc.dart`
- **Events**: LoadLiveCaty
- **States**: LiveCatyInitial, LiveCatyLoading, LiveCatySuccess, LiveCatyFailed
- **Função**: Buscar categorias Live TV via IpTvApi

#### 1.2 MovieCatyBloc
**Arquivo**: `lib/logic/blocs/categories/movie_caty/movie_caty_bloc.dart`
- **Events**: LoadMovieCaty
- **States**: MovieCatyInitial, MovieCatyLoading, MovieCatySuccess, MovieCatyFailed
- **Função**: Buscar categorias de Movies via IpTvApi

#### 1.3 SeriesCatyBloc
**Arquivo**: `lib/logic/blocs/categories/series_caty/series_caty_bloc.dart`
- **Events**: LoadSeriesCaty
- **States**: SeriesCatyInitial, SeriesCatyLoading, SeriesCatySuccess, SeriesCatyFailed
- **Função**: Buscar categorias de Series via IpTvApi

---

### **FASE 2: ChannelsBloc**

#### 2.1 ChannelsBloc
**Arquivo**: `lib/logic/blocs/categories/channels/channels_bloc.dart`
- **Events**: LoadLiveChannels, LoadMovieChannels, LoadSeriesChannels
- **States**: ChannelsInitial, ChannelsLoading, ChannelsSuccess, ChannelsFailed
- **Função**: Buscar canais de uma categoria específica

---

### **FASE 3: Cubits Auxiliares**

#### 3.1 SettingsCubit
**Arquivo**: `lib/logic/cubits/settings/settings_cubit.dart`
- **State**: SettingsState (isDemo, theme, etc)
- **Função**: Gerenciar configurações do app

#### 3.2 FavoritesCubit
**Arquivo**: `lib/logic/cubits/favorites/favorites_cubit.dart`
- **Função**: Gerenciar favoritos (já existe FavoriteLocale)

#### 3.3 WatchingCubit
**Arquivo**: `lib/logic/cubits/watch/watching_cubit.dart`
- **Função**: Gerenciar histórico (já existe WatchingLocale)

---

### **FASE 4: Welcome Screen (Menu Principal)**

#### 4.1 WelcomeScreen
**Arquivo**: `lib/presentation/screens/welcome_screen.dart`

**Layout**:
```
┌─────────────────────────────────────────────────┐
│  [Logo] Tropical Play TV        [User Info]    │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │ LIVE TV  │  │  MOVIES  │  │  SERIES  │     │
│  │ 📺       │  │  🎬      │  │  📺      │     │
│  │ X Canais │  │ X Canais │  │ X Canais │     │
│  └──────────┘  └──────────┘  └──────────┘     │
│                                                 │
│                              ┌──────────┐      │
│                              │ Catch Up │      │
│                              ├──────────┤      │
│                              │Favourites│      │
│                              ├──────────┤      │
│                              │ Settings │      │
│                              └──────────┘      │
└─────────────────────────────────────────────────┘
```

**Componentes**:
- AppBarWelcome (widget customizado)
- CardWelcomeTv (cards grandes para Live/Movies/Series)
- CardWelcomeSetting (cards pequenos laterais)

---

### **FASE 5: Telas de Categorias**

#### 5.1 LiveCategoriesScreen
**Arquivo**: `lib/presentation/screens/live/live_categories_screen.dart`
- Grid de categorias Live TV
- Busca de categorias
- Navegação para LiveChannelsScreen

#### 5.2 MovieCategoriesScreen
**Arquivo**: `lib/presentation/screens/movie/movie_categories_screen.dart`
- Grid de categorias de Movies
- Similar ao Live

#### 5.3 SeriesCategoriesScreen
**Arquivo**: `lib/presentation/screens/series/series_categories_screen.dart`
- Grid de categorias de Series
- Similar ao Live

---

### **FASE 6: Telas de Canais**

#### 6.1 LiveChannelsScreen
**Arquivo**: `lib/presentation/screens/live/live_channels_screen.dart`
- Lista de canais de uma categoria
- Navegação para Player

#### 6.2 MovieChannelsScreen
**Arquivo**: `lib/presentation/screens/movie/movie_channels_screen.dart`
- Lista de filmes de uma categoria
- Navegação para MovieDetails

#### 6.3 SeriesChannelsScreen
**Arquivo**: `lib/presentation/screens/series/series_channels_screen.dart`
- Lista de séries de uma categoria
- Navegação para SerieDetails

---

### **FASE 7: Widgets Customizados**

#### 7.1 Cards
- CardWelcomeTv
- CardWelcomeSetting
- CardLiveItem
- CardMovieItem
- CardSerieItem

#### 7.2 AppBars
- AppBarWelcome
- AppBarLive
- AppBarMovie
- AppBarSerie

---

## 🔄 Fluxo de Implementação Recomendado

### **Etapa 1: BLoCs** (Começar aqui!)
1. Criar LiveCatyBloc
2. Criar MovieCatyBloc
3. Criar SeriesCatyBloc
4. Criar ChannelsBloc
5. Testar BLoCs isoladamente

### **Etapa 2: Cubits**
1. Criar SettingsCubit
2. Criar FavoritesCubit
3. Criar WatchingCubit

### **Etapa 3: Widgets Base**
1. Criar CardWelcomeTv
2. Criar CardWelcomeSetting
3. Criar AppBarWelcome

### **Etapa 4: Welcome Screen**
1. Criar WelcomeScreen
2. Integrar BLoCs
3. Testar navegação básica

### **Etapa 5: Telas de Categorias**
1. LiveCategoriesScreen
2. MovieCategoriesScreen
3. SeriesCategoriesScreen

### **Etapa 6: Telas de Canais**
1. LiveChannelsScreen
2. MovieChannelsScreen
3. SeriesChannelsScreen

---

## 🎨 Adaptações para iOS

### Design:
- Manter tema escuro moderno atual
- Usar cores do Tropical Play (amarelo #FFD700)
- Cards com bordas arredondadas
- Animações suaves
- Suporte a gestos iOS

### Performance:
- Lazy loading de imagens
- Cache de categorias
- Paginação de canais

---

## 📦 Dependências Necessárias

Já instaladas no pubspec.yaml:
- ✅ flutter_bloc
- ✅ get
- ✅ cached_network_image
- ✅ font_awesome_flutter

---

## 🧪 Testes

### Testes Unitários:
- [ ] LiveCatyBloc
- [ ] MovieCatyBloc
- [ ] SeriesCatyBloc
- [ ] ChannelsBloc

### Testes de Integração:
- [ ] Fluxo completo: Login → Welcome → Categories → Channels
- [ ] Navegação entre telas
- [ ] Carregamento de dados

### Testes Manuais:
- [ ] Visual no Chrome
- [ ] Performance
- [ ] Responsividade

---

## 📝 Próximos Passos Imediatos

1. ✅ **Criar estrutura de pastas para BLoCs**
2. ✅ **Implementar LiveCatyBloc completo**
3. ✅ **Implementar MovieCatyBloc completo**
4. ✅ **Implementar SeriesCatyBloc completo**
5. ✅ **Registrar BLoCs no main.dart**
6. ✅ **Criar WelcomeScreen básica**
7. ✅ **Testar navegação Login → Welcome**

---

## 🎯 Meta Final

Ter um app funcional com:
- ✅ Login com Firebase
- ✅ Seleção de servidor
- ✅ Menu principal (Welcome)
- ✅ Navegação para Live TV, Movies, Series
- ✅ Listagem de categorias
- ✅ Listagem de canais
- ⏳ Player de vídeo (fase futura)

---

## 📊 Progresso Estimado

- **FASE 1 (BLoCs)**: 2-3 horas
- **FASE 2 (ChannelsBloc)**: 1 hora
- **FASE 3 (Cubits)**: 1 hora
- **FASE 4 (Welcome)**: 2 horas
- **FASE 5 (Categories)**: 3 horas
- **FASE 6 (Channels)**: 3 horas
- **FASE 7 (Widgets)**: 2 horas

**Total estimado**: 14-15 horas de desenvolvimento

---

## ✅ Checklist de Conclusão

- [ ] Todos os BLoCs implementados e testados
- [ ] Welcome Screen funcionando
- [ ] Navegação completa entre telas
- [ ] Dados carregando corretamente da API
- [ ] UI responsiva e bonita
- [ ] Sem erros de compilação
- [ ] Testes manuais aprovados
- [ ] Documentação atualizada
