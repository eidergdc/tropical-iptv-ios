# Solução para Problemas de Build no Codemagic

## Problemas Identificados

### 1. ✅ Conflito de Dependências Flutter (RESOLVIDO)
- **Problema:** `awesome_snackbar_content ^0.1.5` vs `intl ^0.19.0`
- **Solução:** Downgrade para `awesome_snackbar_content ^0.1.1`

### 2. ✅ Erro Swift 6 (RESOLVIDO)
- **Problema:** FirebaseSharedSwift usando sintaxe Swift 6
- **Solução:** Downgrade Firebase: `firebase_core: ^2.24.2`, `cloud_firestore: ^4.13.6`

### 3. ✅ Conflito CocoaPods (RESOLVIDO)
- **Problema:** Podfile.lock com versão incompatível
- **Solução:** Removido Podfile.lock, adicionado ao .gitignore

### 4. ⚠️ Erro de Compilação Dart (EM ANÁLISE)
- **Problema:** `dialogTheme: DialogTheme(` - erro na compilação
- **Causa Provável:** Versão do Flutter no Codemagic diferente da local
- **Status:** Código está correto localmente (Flutter 3.7.2)

### 5. ⚠️ Warnings de Deployment Target
- **Problema:** Pods com iOS deployment target 9.0-11.0 (mínimo é 12.0)
- **Impacto:** Warnings, não impedem build

## Soluções Recomendadas

### Opção 1: Atualizar codemagic.yaml (RECOMENDADO)
Especificar a versão exata do Flutter no `codemagic.yaml`:

```yaml
workflows:
  ios-workflow:
    environment:
      flutter: 3.7.2  # ou a versão que funciona localmente
      xcode: 15.0
```

### Opção 2: Simplificar DialogTheme
Se o problema persistir, simplificar o DialogTheme para compatibilidade:

```dart
dialogTheme: const DialogTheme(
  backgroundColor: kColorCard,
  elevation: 24,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(28)),
  ),
),
```

### Opção 3: Atualizar Podfile para iOS 13+
Adicionar ao início do `ios/Podfile`:

```ruby
platform :ios, '13.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
```

## Próximos Passos

1. Verificar versão do Flutter no Codemagic
2. Atualizar `codemagic.yaml` com versão específica
3. Se necessário, aplicar Opção 2 ou 3
4. Testar build novamente

## Commits Realizados

1. **0980550:** Downgrade awesome_snackbar_content
2. **3b8bbe8:** Downgrade Firebase para compatibilidade Swift
3. **20650f6:** Remover Podfile.lock

## Status Atual

- ✅ Dependências Flutter resolvidas
- ✅ Firebase compatível
- ✅ CocoaPods configurado
- ⚠️ Aguardando ajuste de versão Flutter no Codemagic
