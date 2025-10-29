# Tropical IPTV iOS

Aplicativo IPTV para iPhone baseado no projeto tropicaladmin-backup, desenvolvido com Flutter.

## 🎯 Características

- ✅ Autenticação via Firebase
- ✅ Streaming de canais ao vivo (Live TV)
- ✅ Filmes sob demanda (VOD)
- ✅ Séries com temporadas e episódios
- ✅ EPG (Guia de Programação Eletrônica)
- ✅ Favoritos
- ✅ Histórico de visualização
- ✅ Player de vídeo com controles completos
- ✅ Suporte a Chromecast
- ✅ Interface otimizada para iPhone

## 📱 Tecnologias

- **Flutter** - Framework multiplataforma
- **Firebase** - Autenticação e banco de dados
- **BLoC/Cubit** - Gerenciamento de estado
- **GetX** - Navegação e gerenciamento
- **Dio** - Requisições HTTP
- **GetStorage** - Armazenamento local
- **VLC Player** - Reprodução de vídeo
- **Google Mobile Ads** - Monetização

## 🏗️ Estrutura do Projeto

```
lib/
├── helpers/              # Utilitários (cores, temas, constantes)
├── logic/
│   ├── blocs/           # BLoCs para gerenciamento de estado
│   └── cubits/          # Cubits para estados simples
├── presentation/
│   ├── screens/         # Telas do aplicativo
│   └── widgets/         # Widgets reutilizáveis
└── repository/
    ├── api/             # Serviços de API (Auth, IPTV)
    ├── firebase/        # Integração Firebase
    ├── locale/          # Armazenamento local
    └── models/          # Modelos de dados
```

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (>=3.0.0)
- Xcode (para iOS)
- CocoaPods

### Instalação

1. Clone o repositório
2. Instale as dependências:
```bash
cd tropical_iptv_ios
flutter pub get
```

3. Configure o Firebase:
   - O arquivo `GoogleService-Info.plist` já está configurado em `ios/Runner/`
   - As opções do Firebase estão em `lib/firebase_options.dart`

4. Execute no simulador iOS:
```bash
flutter run
```

5. Para testar no Chrome (apenas visual):
```bash
flutter run -d chrome
```

## 📋 Progresso

### ✅ Concluído
- [x] Configuração inicial do projeto
- [x] Estrutura de pastas
- [x] Modelos de dados (User, Category, Channels, EPG, etc.)
- [x] Repositórios (API, Firebase, Local Storage)
- [x] Helpers (cores, temas, funções utilitárias)
- [x] Configuração Firebase
- [x] Configuração iOS (Info.plist, permissões)

### ⏳ Em Andamento
- [ ] BLoCs e Cubits
- [ ] Telas (Splash, Login, Home, Player, etc.)
- [ ] Widgets personalizados
- [ ] Testes

## 🔑 Configuração da API IPTV

O app se conecta a servidores IPTV usando o formato:
```
http://servidor.com/player_api.php?username=USER&password=PASS
```

### Endpoints Suportados:
- `get_live_categories` - Categorias de canais ao vivo
- `get_vod_categories` - Categorias de filmes
- `get_series_categories` - Categorias de séries
- `get_live_streams` - Lista de canais ao vivo
- `get_vod_streams` - Lista de filmes
- `get_series` - Lista de séries
- `get_vod_info` - Detalhes do filme
- `get_series_info` - Detalhes da série
- `get_short_epg` - EPG do canal

## 🎨 Tema

O app usa um tema escuro personalizado com:
- Cor primária: `#00D9FF` (Azul ciano)
- Cor secundária: `#FF6B9D` (Rosa)
- Background: `#0A0E27` (Azul escuro)
- Cards: `#1A1F3A` (Azul médio)

## 📝 Notas

- O projeto está configurado para rodar apenas em iOS
- Firebase já configurado com o projeto `iptv-black`
- AdMob configurado com IDs de teste
- Suporte a orientação portrait e landscape

## 🔧 Próximos Passos

1. Implementar BLoCs para gerenciamento de estado
2. Criar telas principais (Splash, Login, Home)
3. Implementar player de vídeo
4. Adicionar navegação entre telas
5. Testes no simulador iOS
6. Build final para App Store

## 📄 Licença

Este projeto é baseado no tropicaladmin-backup e adaptado para iOS.
