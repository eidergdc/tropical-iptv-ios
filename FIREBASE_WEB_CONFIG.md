# Firebase Web Configuration

## Configuração Fornecida

```javascript
// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCRoGZQZD7k-18-BmLq7X4QMGJ5ODJwemc",
  authDomain: "iptv-black.firebaseapp.com",
  databaseURL: "https://iptv-black-default-rtdb.firebaseio.com",
  projectId: "iptv-black",
  storageBucket: "iptv-black.firebasestorage.app",
  messagingSenderId: "427954135204",
  appId: "1:427954135204:web:9af896d2534d1817950631"
};
```

## Conversão para Flutter

Esta configuração será automaticamente adicionada ao `firebase_options.dart` pelo FlutterFire CLI.

## Plataformas Configuradas
- ✅ Android
- ✅ iOS  
- ✅ macOS
- ✅ Web
- ✅ Windows

## Próximos Passos
1. Aguardar conclusão do `flutterfire configure`
2. Verificar `lib/firebase_options.dart` atualizado
3. Testar no Chrome com Firebase funcionando
4. Validar login com código Firebase

## Estrutura Firebase Esperada

### Firestore Collection: `users`
```json
{
  "users": {
    "{code}": {
      "name": "Nome do Usuário",
      "email": "email@example.com",
      "paymentStatus": true,
      "iptvAccounts": [
        {
          "name": "Conta Principal",
          "url": "http://server.com/player_api.php?username=user&password=pass",
          "description": "Descrição da conta"
        }
      ],
      "createdAt": "2024-01-01T00:00:00Z",
      "expiryDate": "2025-01-01T00:00:00Z"
    }
  }
}
```

### Exemplo de Código de Teste
- Código: `123456`
- Criar documento em Firestore: `users/123456`
- Com estrutura acima

## Testes
Após configuração:
```bash
cd tropical_iptv_ios
flutter run -d chrome --web-port=8082
```

Testar:
1. Splash screen (3s)
2. Tela de login
3. Inserir código: `123456`
4. Validar no Firebase
5. Selecionar conta IPTV
6. Login bem-sucedido
