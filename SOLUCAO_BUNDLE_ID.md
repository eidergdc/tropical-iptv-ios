# 🔧 Solução: Bundle ID não encontrado no Codemagic

## ❌ Erro
```
No matching profiles found for bundle identifier "com.tropicalplay.iptv" 
and distribution type "app_store"
```

## 🎯 Causa
O Bundle ID `com.tropicalplay.iptv` não está registrado no Apple Developer Portal.

## ✅ Solução Passo a Passo

### Opção 1: Registrar o Bundle ID (Recomendado)

#### 1. Acessar Apple Developer Portal
1. Acesse: https://developer.apple.com/account/
2. Faça login com seu Apple ID
3. Vá em **"Certificates, Identifiers & Profiles"**

#### 2. Criar App ID
1. No menu lateral, clique em **"Identifiers"**
2. Clique no botão **"+"** (adicionar)
3. Selecione **"App IDs"** e clique em **"Continue"**
4. Selecione **"App"** e clique em **"Continue"**
5. Preencha:
   - **Description**: Tropical IPTV
   - **Bundle ID**: Selecione **"Explicit"**
   - **Bundle ID**: Digite `com.tropicalplay.iptv`
6. Em **Capabilities**, marque:
   - ✅ Associated Domains (se usar links universais)
   - ✅ Push Notifications (se usar notificações)
   - ✅ Sign In with Apple (se usar)
7. Clique em **"Continue"** e depois **"Register"**

#### 3. Criar App na App Store Connect
1. Acesse: https://appstoreconnect.apple.com
2. Vá em **"My Apps"**
3. Clique em **"+"** > **"New App"**
4. Preencha:
   - **Platform**: iOS
   - **Name**: Tropical IPTV
   - **Primary Language**: Portuguese (Brazil)
   - **Bundle ID**: Selecione `com.tropicalplay.iptv` (que você acabou de criar)
   - **SKU**: tropical-iptv-001
   - **User Access**: Full Access
5. Clique em **"Create"**

#### 4. Reconfigurar Code Signing no Codemagic
1. Acesse: https://codemagic.io
2. Vá no seu app > **"Settings"** > **"Code signing"**
3. Clique em **"iOS code signing"**
4. Se estiver usando **Automatic**:
   - Clique em **"Fetch profiles"** ou **"Regenerate"**
   - O Codemagic criará automaticamente o Provisioning Profile
5. Se estiver usando **Manual**:
   - Você precisará criar manualmente o Provisioning Profile no Apple Developer Portal

#### 5. Tentar Build Novamente
1. No Codemagic, vá no seu app
2. Clique em **"Start new build"**
3. Selecione a branch **main**
4. Clique em **"Start new build"**

---

### Opção 2: Usar Bundle ID Diferente

Se você não conseguir registrar `com.tropicalplay.iptv`, pode usar outro Bundle ID:

#### 1. Escolher Novo Bundle ID
Formato: `com.seudominio.nomedoapp`

Exemplos:
- `com.eidergdc.tropicaliptv`
- `com.tropical.iptv`
- `com.yourname.tropicalplay`

#### 2. Atualizar no Projeto

**A. Atualizar ios/Runner.xcodeproj/project.pbxproj:**
```bash
cd ~/Desktop/tropical_iptv_ios/ios
# Abrir no Xcode
open Runner.xcworkspace
```

No Xcode:
1. Selecione **Runner** no Project Navigator
2. Em **Targets** > **Runner**
3. Aba **"Signing & Capabilities"**
4. Mude o **Bundle Identifier** para o novo

**B. Atualizar codemagic.yaml:**
```yaml
environment:
  ios_signing:
    distribution_type: app_store
    bundle_identifier: com.seu.novo.bundleid  # ← Atualizar aqui
```

#### 3. Registrar Novo Bundle ID
Siga os passos da **Opção 1** com o novo Bundle ID

#### 4. Fazer Commit e Push
```bash
cd ~/Desktop/tropical_iptv_ios
git add .
git commit -m "Update Bundle ID"
git push
```

---

## 🔍 Verificar Bundle ID Atual

Para ver qual Bundle ID está configurado:

```bash
cd ~/Desktop/tropical_iptv_ios
grep -r "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj
```

Ou abrir no Xcode:
```bash
cd ~/Desktop/tropical_iptv_ios/ios
open Runner.xcworkspace
```

---

## ⚠️ Importante

1. **Apple Developer Account**: Você precisa de uma conta ativa ($99/ano)
2. **Bundle ID Único**: Cada Bundle ID deve ser único globalmente
3. **Consistência**: O Bundle ID deve ser o mesmo em:
   - Apple Developer Portal
   - App Store Connect
   - Xcode Project
   - codemagic.yaml

---

## 📞 Precisa de Ajuda?

Se o erro persistir:

1. **Verifique se tem Apple Developer Account ativo**
2. **Confirme que o Bundle ID foi registrado**
3. **Tente regenerar os certificados no Codemagic**
4. **Verifique os logs completos do build**

---

**Próximo Passo**: Após resolver, execute novo build no Codemagic!
