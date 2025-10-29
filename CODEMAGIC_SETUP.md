# 🚀 Guia de Configuração Codemagic.io

## ✅ Status Atual
- ✅ Arquivo `codemagic.yaml` criado e enviado ao GitHub
- ✅ Repositório: https://github.com/eidergdc/tropical-iptv-ios.git
- ✅ Branch: main
- ✅ Commit: 07853ed

## 📋 Próximos Passos

### 1. Criar Conta no Codemagic
1. Acesse: https://codemagic.io/
2. Clique em "Sign up for free"
3. Conecte com sua conta GitHub

### 2. Adicionar o Repositório
1. No dashboard do Codemagic, clique em "Add application"
2. Selecione "GitHub"
3. Escolha o repositório: `tropical-iptv-ios`
4. Clique em "Finish: Add application"

### 3. Configurar Code Signing (Assinatura de Código)

#### Opção A: Automatic Code Signing (Recomendado)
1. No Codemagic, vá em "Settings" > "Code signing"
2. Clique em "iOS code signing"
3. Conecte sua conta Apple Developer:
   - Apple ID
   - App-specific password (gere em appleid.apple.com)
4. O Codemagic gerará automaticamente os certificados

#### Opção B: Manual Code Signing
1. Exporte certificados do Xcode:
   - Abra Keychain Access
   - Exporte o certificado de distribuição (.p12)
2. No Codemagic:
   - Upload do arquivo .p12
   - Upload do Provisioning Profile

### 4. Configurar App Store Connect
1. No Codemagic, vá em "Teams" > "Integrations"
2. Clique em "App Store Connect"
3. Configure:
   - **Issuer ID**: Encontre em App Store Connect > Users and Access > Keys
   - **Key ID**: Crie uma nova chave API
   - **API Key**: Baixe o arquivo .p8

### 5. Configurar Variáveis de Ambiente
No arquivo `codemagic.yaml`, atualize:

```yaml
environment:
  vars:
    APP_STORE_ID: "seu_app_id_aqui"  # ID do app na App Store Connect
```

### 6. Iniciar Build
1. No Codemagic, clique em "Start new build"
2. Selecione o workflow: `ios-workflow`
3. Clique em "Start new build"

## 📱 Configuração do Bundle Identifier

Certifique-se de que o Bundle ID está correto:
- **Atual**: `com.tropicalplay.iptv`
- **Arquivo**: `ios/Runner/Info.plist`

Se precisar alterar:
```xml
<key>CFBundleIdentifier</key>
<string>com.tropicalplay.iptv</string>
```

## 🔐 Certificados Necessários

### Para App Store:
- ✅ Apple Distribution Certificate
- ✅ App Store Provisioning Profile

### Para TestFlight:
- ✅ Configurado automaticamente pelo Codemagic

## 📦 Artefatos Gerados

Após o build bem-sucedido, você terá:
- `build/ios/ipa/*.ipa` - Arquivo IPA para distribuição
- Logs de build
- Screenshots (se configurado)

## 🚀 Distribuição Automática

O workflow está configurado para:
- ✅ Enviar automaticamente para TestFlight
- ✅ Notificar por email sobre sucesso/falha
- ❌ NÃO enviar automaticamente para App Store (requer aprovação manual)

## 📧 Notificações

Atualize o email no `codemagic.yaml`:
```yaml
publishing:
  email:
    recipients:
      - seu_email@exemplo.com
```

## 🔧 Troubleshooting

### Erro: "No code signing identities found"
- Verifique se conectou sua conta Apple Developer
- Certifique-se de que o Bundle ID está registrado na App Store Connect

### Erro: "Build failed"
- Verifique os logs no Codemagic
- Certifique-se de que todas as dependências estão no `pubspec.yaml`

### Erro: "Provisioning profile doesn't match"
- Verifique se o Bundle ID no código corresponde ao registrado
- Regenere o Provisioning Profile no Codemagic

## 📚 Recursos Úteis

- [Documentação Codemagic](https://docs.codemagic.io/)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [App Store Connect](https://appstoreconnect.apple.com/)

## ✨ Dicas

1. **Primeiro Build**: Pode levar 15-20 minutos
2. **Builds Subsequentes**: ~10 minutos (com cache)
3. **Limite Free Tier**: 500 minutos/mês
4. **TestFlight**: Disponível em ~30 minutos após build

---

**Criado em**: $(date)
**Versão**: 1.0.0
