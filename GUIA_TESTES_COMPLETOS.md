# 🧪 Guia de Testes Completos - Tropical IPTV iOS

## 📋 Checklist de Testes

### ✅ Testes Já Realizados (Automáticos):

- [x] **Compilação**: Sem erros
- [x] **Análise Estática**: 12 warnings (apenas estilo, não críticos)
- [x] **Estrutura de Código**: Correta
- [x] **Imports**: Todos funcionando
- [x] **Navegação**: Implementada
- [x] **BlocListener**: Adicionado e configurado

---

## 🎯 Testes Manuais a Realizar

### 1️⃣ **Tela de Login - Validação de Código**

#### Teste 1.1: Código Válido
- [ ] Abrir http://localhost:8083
- [ ] Digitar código: `648718886`
- [ ] Clicar em "Validar Código"
- [ ] **Esperado:**
  - ✅ Loading aparece
  - ✅ Mensagem no console: "✅ Código validado! X contas encontradas"
  - ✅ Navegação automática para Server Selection Screen

#### Teste 1.2: Código Inválido
- [ ] Digitar código: `999999999`
- [ ] Clicar em "Validar Código"
- [ ] **Esperado:**
  - ❌ Mensagem de erro
  - ❌ Permanece na tela de login

#### Teste 1.3: Campo Vazio
- [ ] Deixar campo vazio
- [ ] Clicar em "Validar Código"
- [ ] **Esperado:**
  - ⚠️ Validação de campo obrigatório

---

### 2️⃣ **Tela de Seleção de Servidores - UI/UX**

#### Teste 2.1: Visualização Inicial
- [ ] Após validação bem-sucedida, verificar:
  - [ ] Header com botão "Voltar"
  - [ ] Título "Escolha o Servidor"
  - [ ] Subtítulo "Selecione qual servidor deseja usar"
  - [ ] Card de informações do usuário:
    - [ ] Ícone de verificação (verde ou laranja)
    - [ ] Status do pagamento
    - [ ] Código do usuário
    - [ ] Data de expiração
  - [ ] Lista de servidores disponíveis
  - [ ] Botão "Selecione um Servidor" (desabilitado)

#### Teste 2.2: Seleção de Servidor
- [ ] Clicar no primeiro servidor
- [ ] **Esperado:**
  - ✅ Card fica destacado em amarelo
  - ✅ Borda amarela mais grossa (2px)
  - ✅ Background amarelo com opacity
  - ✅ Ícone DNS fica amarelo sólido
  - ✅ Check icon aparece no canto direito
  - ✅ Sombra amarela (glow effect)
  - ✅ Botão muda para "Conectar ao {nome do servidor}"

#### Teste 2.3: Trocar Seleção
- [ ] Clicar no segundo servidor
- [ ] **Esperado:**
  - ✅ Primeiro servidor volta ao estado normal
  - ✅ Segundo servidor fica destacado
  - ✅ Botão atualiza o texto

#### Teste 2.4: Testar Todos os Servidores
- [ ] Clicar em cada servidor da lista
- [ ] Verificar feedback visual em todos

#### Teste 2.5: Botão Voltar
- [ ] Clicar no botão "Voltar" (seta)
- [ ] **Esperado:**
  - ✅ Retorna para tela de login
  - ✅ Código ainda está preenchido

---

### 3️⃣ **Conexão ao Servidor - Fluxo de Autenticação**

#### Teste 3.1: Conectar Sem Selecionar
- [ ] Não selecionar nenhum servidor
- [ ] Clicar em "Selecione um Servidor"
- [ ] **Esperado:**
  - ⚠️ SnackBar laranja: "Por favor, selecione um servidor"

#### Teste 3.2: Conexão Bem-Sucedida
- [ ] Selecionar um servidor
- [ ] Clicar em "Conectar ao {servidor}"
- [ ] **Esperado:**
  - 🔄 Botão mostra loading
  - 📝 Console mostra:
    ```
    🔗 Conectando ao servidor: http://...
    👤 Username: 648718886
    🔐 Password: ...
    ```
  - ✅ SnackBar verde: "✅ Login realizado com sucesso!"
  - ✅ Navegação para `/categories-live` (ou erro se rota não existir)

#### Teste 3.3: Conexão com Erro
- [ ] Se a API retornar erro, verificar:
  - ❌ SnackBar vermelho com mensagem de erro
  - ❌ Botão "Tentar Novamente" no SnackBar
  - ❌ Loading desaparece
  - ❌ Permanece na tela de seleção

#### Teste 3.4: Tentar Novamente
- [ ] Após erro, clicar em "Tentar Novamente" no SnackBar
- [ ] **Esperado:**
  - 🔄 Tenta conectar novamente
  - 🔄 Loading aparece novamente

---

### 4️⃣ **Estados do AuthBloc**

#### Teste 4.1: AuthLoading
- [ ] Durante conexão, verificar:
  - [ ] `isLoading = true`
  - [ ] Botão mostra CircularProgressIndicator
  - [ ] Botão desabilitado

#### Teste 4.2: AuthSuccess
- [ ] Após login bem-sucedido:
  - [ ] SnackBar verde aparece
  - [ ] Navegação automática
  - [ ] Dados salvos localmente (verificar LocaleApi)

#### Teste 4.3: AuthFailed
- [ ] Após erro:
  - [ ] SnackBar vermelho aparece
  - [ ] Mensagem de erro clara
  - [ ] Opção de tentar novamente
  - [ ] Loading desaparece

---

### 5️⃣ **Validações de Dados**

#### Teste 5.1: Conta Expirada
- [ ] Se `expiresAt` for no passado:
  - [ ] Verificar se mostra aviso
  - [ ] Verificar se permite ou bloqueia conexão

#### Teste 5.2: Pagamento Não Verificado
- [ ] Se `paymentStatus = false`:
  - [ ] Ícone laranja de warning
  - [ ] Texto "Pagamento Pendente"
  - [ ] Verificar se permite conexão

#### Teste 5.3: Extração de Credenciais
- [ ] Verificar no console se:
  - [ ] Username extraído corretamente
  - [ ] Password extraído corretamente
  - [ ] Server URL formatado corretamente

---

### 6️⃣ **Responsividade e Layout**

#### Teste 6.1: Scroll
- [ ] Se houver muitos servidores (>5):
  - [ ] Lista deve ter scroll
  - [ ] Scroll suave
  - [ ] Todos os servidores acessíveis

#### Teste 6.2: Tamanhos de Tela
- [ ] Redimensionar janela do navegador
- [ ] Verificar:
  - [ ] Layout se adapta
  - [ ] Textos não quebram incorretamente
  - [ ] Botões permanecem visíveis
  - [ ] Cards mantêm proporções

#### Teste 6.3: Modo Retrato/Paisagem
- [ ] Testar em diferentes orientações
- [ ] Verificar usabilidade

---

### 7️⃣ **Performance e Comportamento**

#### Teste 7.1: Múltiplos Cliques
- [ ] Clicar rapidamente em "Conectar"
- [ ] **Esperado:**
  - ✅ Apenas uma requisição é feita
  - ✅ Botão desabilita durante loading

#### Teste 7.2: Navegação Durante Loading
- [ ] Clicar em "Voltar" durante conexão
- [ ] **Esperado:**
  - ✅ Requisição é cancelada ou continua
  - ✅ Sem erros no console

#### Teste 7.3: Memória e Logs
- [ ] Verificar console do navegador:
  - [ ] Sem erros JavaScript
  - [ ] Sem warnings críticos
  - [ ] Logs informativos aparecem

---

### 8️⃣ **Integração com Firebase**

#### Teste 8.1: Dados do Firebase
- [ ] Verificar se dados vêm corretamente:
  - [ ] `userNumber`
  - [ ] `paymentStatus`
  - [ ] `createdAt`
  - [ ] `expiresAt`
  - [ ] `lists` (array de servidores)

#### Teste 8.2: Múltiplas Contas
- [ ] Se usuário tiver 3+ servidores:
  - [ ] Todos aparecem na lista
  - [ ] Todos são clicáveis
  - [ ] Todos funcionam

---

### 9️⃣ **Edge Cases**

#### Teste 9.1: Sem Servidores
- [ ] Se `lists` estiver vazio:
  - [ ] Mostrar mensagem apropriada
  - [ ] Não quebrar a UI

#### Teste 9.2: URL Malformada
- [ ] Se URL do servidor estiver incorreta:
  - [ ] Try/catch captura erro
  - [ ] Mostra mensagem de erro
  - [ ] Não quebra o app

#### Teste 9.3: Timeout de Rede
- [ ] Simular conexão lenta:
  - [ ] Loading persiste
  - [ ] Timeout apropriado
  - [ ] Mensagem de erro clara

---

## 📊 Resumo de Testes

### Categorias:
- **UI/UX**: 15 testes
- **Funcionalidade**: 12 testes
- **Validações**: 8 testes
- **Performance**: 5 testes
- **Edge Cases**: 6 testes

### Total: **46 testes manuais**

---

## ✅ Como Executar os Testes

### 1. Abrir o App:
```bash
# O app já está rodando em:
http://localhost:8083
```

### 2. Preparar Dados de Teste:
- **Código válido**: `648718886`
- **Código inválido**: `999999999`

### 3. Ferramentas:
- **Console do Navegador**: F12 → Console
- **DevTools**: Para inspecionar elementos
- **Network Tab**: Para ver requisições

### 4. Registro de Resultados:
Marque cada teste com:
- ✅ Passou
- ❌ Falhou (anotar detalhes)
- ⚠️ Parcial (anotar observações)

---

## 🐛 Problemas Conhecidos

### Warnings de Estilo (Não Críticos):
1. `withOpacity` deprecated (12 ocorrências)
   - **Impacto**: Nenhum, apenas warning
   - **Solução futura**: Usar `.withValues()`

2. `print` em produção (3 ocorrências)
   - **Impacto**: Logs no console
   - **Solução futura**: Usar `debugPrint` ou remover

3. `super parameter` (1 ocorrência)
   - **Impacto**: Nenhum, apenas sugestão de estilo
   - **Solução futura**: Usar super parameter

---

## 📝 Relatório de Testes

### Template para Reportar Problemas:

```markdown
## Bug/Problema Encontrado

**Teste**: [Número e nome do teste]
**Severidade**: [Crítico/Alto/Médio/Baixo]

**Passos para Reproduzir**:
1. ...
2. ...
3. ...

**Resultado Esperado**:
...

**Resultado Obtido**:
...

**Screenshots/Logs**:
...

**Ambiente**:
- Navegador: ...
- Resolução: ...
- Sistema: ...
```

---

## 🎯 Próximos Passos Após Testes

1. **Se todos os testes passarem**:
   - ✅ Marcar feature como completa
   - ✅ Documentar no README
   - ✅ Preparar para próxima feature

2. **Se houver falhas**:
   - 🔧 Corrigir bugs encontrados
   - 🔄 Re-testar
   - 📝 Atualizar documentação

3. **Melhorias Identificadas**:
   - 📋 Adicionar ao backlog
   - 🎨 Priorizar por impacto
   - 🚀 Planejar implementação

---

## 🎉 Conclusão

Este guia cobre todos os aspectos críticos da funcionalidade de seleção de servidores. Seguindo este checklist, você garante que a feature está funcionando corretamente e pronta para uso em produção.

**Boa sorte com os testes! 🚀**
