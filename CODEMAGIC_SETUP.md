# 🚀 Guia Completo de Configuração Codemagic.io

## ✅ Status Atual
- ✅ Arquivo `codemagic.yaml` configurado e otimizado
- ✅ Repositório: https://github.com/eidergdc/tropical-iptv-ios.git
- ✅ Branch: main
- ✅ Bundle ID: com.tropicalplay.iptv
- ✅ Versão: 1.0.0+1

## 📋 Passo a Passo Completo

### 1. Criar Conta no Codemagic
1. Acesse: **https://codemagic.io/**
2. Clique em **"Sign up for free"**
3. Conecte com sua conta **GitHub**
4. Autorize o acesso aos repositórios

### 2. Adicionar o Repositório
1. No dashboard do Codemagic, clique em **"Add application"**
2. Selecione **"GitHub"** como fonte
3. Escolha o repositório: **`eidergdc/tropical-iptv-ios`**
4. Selecione **"Flutter App"** como tipo de projeto
5. Clique em **"Finish: Add application"**

### 3. Configurar Code Signing (CRÍTICO!)

#### Opção A: Automatic Code Signing (✅ RECOMENDADO)
1. No Codemagic, vá em **"Teams"** > **"Integrations"**
2. Clique em **"iOS code signing"**
3. Selecione **"Automatic code signing"**
4. Conecte sua conta Apple Developer:
   - **Apple ID**: seu_email@icloud.com
   - **App-specific password**: 
     - Acesse https://appleid.apple.com
     - Vá em "Security" > "App-Specific Passwords"
     - Gere uma nova senha
     - Copie e cole no Codemagic
5. O Codemagic gerará automaticamente:
   - Certificado de distribuição
   - Provisioning Profile

### 4. Registrar o App na App Store Connect

1. **Criar novo App:**
   - Acesse: https://appstoreconnect.apple.com
   - Vá em **"My Apps"** > **"+"** > **"New App"**
   - Preencha:
     - **Platform**: iOS
     - **Name**: Tropical IPTV
     - **Primary Language**: Portuguese (Brazil)
     - **Bundle ID**: Selecione **com.tropicalplay.iptv**
     - **SKU**: tropical-iptv-ios-001
   - Clique em **"Create"**

2. **Anote o App ID:**
   - Na página do app, veja a URL
   - Exemplo: `https://appstoreconnect.apple.com/apps/1234567890/`
   - O número **1234567890** é seu APP_STORE_APPLE_ID

3. **Atualizar codemagic.yaml:**
   - Edite o arquivo e substitua APP_STORE_APPLE_ID pelo seu ID

### 5. Configurar App Store Connect API

1. **Criar API Key:**
   - Acesse: https://appstoreconnect.apple.com
   - Vá em **"Users and Access"** > **"Keys"**
   - Clique em **"+"** para criar nova chave
   - Nome: "Codemagic CI/CD"
   - Acesso: **"App Manager"**
   - Clique em **"Generate"**
   - **IMPORTANTE**: Baixe o arquivo .p8 (só pode baixar uma vez!)
   - Anote o **Key ID** e **Issuer ID**

2. **Configurar no Codemagic:**
   - Vá em **"Teams"** > **"Integrations"**
   - Clique em **"App Store Connect"**
   - Preencha os dados e salve

### 6. Iniciar Build

1. **Fazer commit:**
   ```bash
   cd ~/Desktop/tropical_iptv_ios
   git add .
   git commit -m "Update Codemagic configuration"
   git push
   ```

2. **Iniciar build no Codemagic:**
   - Clique em **"Start new build"**
   - Selecione **branch**: main
   - Selecione **workflow**: ios-workflow
   - Clique em **"Start new build"**

## 📱 Informações do Projeto

- **Bundle ID**: com.tropicalplay.iptv
- **Display Name**: Tropical IPTV
- **Version**: 1.0.0
- **Build Number**: Incrementado automaticamente

## 🔐 Checklist

### Antes do Build:
- [ ] Apple Developer Account ativo ($99/ano)
- [ ] Bundle ID registrado
- [ ] App criado na App Store Connect
- [ ] API Key configurada
- [ ] Code Signing configurado

### Após o Build:
- [ ] IPA gerado
- [ ] Upload para TestFlight
- [ ] App disponível para teste

## 🚀 Fluxo de Distribuição

1. ✅ Commit no GitHub → Trigger automático
2. ✅ Build no Codemagic → 15-20 minutos
3. ✅ Upload para TestFlight → Automático
4. ✅ Notificação por Email → eidergdc@icloud.com
5. ❌ App Store → Manual

## 📚 Recursos Úteis

- [Codemagic Docs](https://docs.codemagic.io/)
- [App Store Connect](https://appstoreconnect.apple.com/)
- [Apple Developer](https://developer.apple.com/)

---

**Versão**: 2.0  
**Repositório**: https://github.com/eidergdc/tropical-iptv-ios
