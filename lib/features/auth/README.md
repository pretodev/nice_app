# Autenticação via E-mail OTP

## Visão Geral

Esta feature implementa um sistema de autenticação seguro via e-mail usando códigos OTP (One-Time Password) de 6 dígitos, baseado no Firebase Authentication.

## Arquitetura

### Estrutura de Diretórios

```
lib/features/auth/
├── data/
│   ├── auth_service.dart          # Serviço principal de autenticação
│   ├── auth_state.dart            # Estados da autenticação
│   ├── rate_limit_service.dart    # Controle de rate limiting
│   └── user_model.dart            # Modelo de dados do usuário
├── providers/
│   └── auth_providers.dart        # Providers Riverpod
└── ui/
    ├── email_input_screen.dart         # Tela de entrada de e-mail
    ├── otp_verification_screen.dart    # Tela de verificação do código OTP
    ├── profile_completion_screen.dart  # Tela de conclusão do perfil
    └── splash_screen.dart              # Tela inicial com verificação de sessão
```

### Componentes Principais

#### 1. AuthService
Serviço principal que gerencia:
- Envio de códigos OTP via Firebase
- Verificação de códigos OTP
- Gerenciamento de sessão do usuário
- Criação automática de contas
- Atualização de perfil

#### 2. RateLimitService
Implementa as regras de rate limiting:
- Máximo de 5 tentativas por código OTP
- Máximo de 3 solicitações de código por hora
- Bloqueio temporário de 1 hora após exceder limites

#### 3. AuthController (Riverpod)
Gerencia o estado da autenticação na aplicação:
- Estados: Initial, Loading, Authenticated, Error, OtpSent, etc.
- Ações: sendOtp, verifyOtp, updateProfile, signOut

## Fluxo de Autenticação

### 1. Entrada de E-mail
- Usuário informa o e-mail
- Validação RFC 5322 via `email_validator`
- Botão habilitado apenas com e-mail válido

### 2. Envio do Código OTP
- Firebase envia e-mail com código de 6 dígitos
- Código válido por 10 minutos
- Rate limiting: máximo 3 solicitações/hora

### 3. Verificação do Código
- 6 campos de entrada para os dígitos
- Máximo de 5 tentativas por código
- Feedback imediato de tentativas restantes
- Timer de 60 segundos para reenvio

### 4. Conclusão
- **Usuário novo**: direcionado para completar perfil (nome)
- **Usuário existente**: direcionado para tela principal
- Sessão válida por 30 dias

## Configuração do Firebase

### 1. Firebase Authentication
```bash
# Habilitar no Firebase Console:
# Authentication > Sign-in methods > Email/Password
# - Enable Email link (passwordless sign-in)
```

### 2. Email Templates
Personalizar template no Firebase Console:
```
Authentication > Templates > Email link to sign-in
```

Template sugerido:
```
Seu código de acesso: [OTP_CODE]

Este código expira em 10 minutos.

Se você não solicitou este código, ignore este e-mail.
```

### 3. Dynamic Links (opcional)
Configurar domínio para deep links:
```
https://niceapp.page.link/verify
```

### 4. Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Regras de Negócio Implementadas

### ✅ Fluxo Unificado
- Mesmo fluxo para usuários novos e existentes
- Sem tela de cadastro separada

### ✅ Código OTP
- 6 dígitos numéricos
- Validade de 10 minutos
- Apenas código mais recente é válido

### ✅ Rate Limiting
- Máximo 5 tentativas de código incorreto
- Máximo 3 solicitações por hora
- Bloqueio de 1 hora após exceder limites

### ✅ Criação Automática de Conta
- Nova conta criada automaticamente após validação OTP
- Perfil solicitado após primeiro acesso
- Dados armazenados no Firestore

### ✅ Sessão do Usuário
- Token gerenciado pelo Firebase
- Sessão válida por 30 dias
- Refresh token automático

## Dependências

```yaml
dependencies:
  firebase_core: ^4.3.0
  firebase_auth: ^5.4.0
  shared_preferences: ^2.3.5
  email_validator: ^3.0.0
  flutter_riverpod: ^3.1.0
  cloud_firestore: ^6.1.1
```

## Estados da Aplicação

```dart
sealed class AuthState
├── AuthInitial           # Estado inicial
├── AuthLoading          # Carregando
├── AuthAuthenticated    # Autenticado (com flag isNewUser)
├── AuthUnauthenticated  # Não autenticado
├── AuthError           # Erro genérico
├── OtpSent             # Código enviado
├── OtpVerifying        # Verificando código
├── OtpError            # Erro ao verificar código
└── OtpLocked           # Bloqueado por rate limit
```

## Mensagens de Erro

| Código | Mensagem |
|--------|----------|
| E-mail inválido | "Informe um e-mail válido" |
| Código inválido | "Código inválido. Tente novamente." |
| Código expirado | "Código expirado. Solicite um novo código." |
| Tentativas excedidas | "Limite de tentativas excedido. Solicite um novo código." |
| Rate limit | "Muitas tentativas. Aguarde 1 hora para tentar novamente." |

## Teste da Feature

### Cenário 1: Novo Usuário
1. Abrir app
2. Informar e-mail novo
3. Receber código OTP no e-mail
4. Inserir código correto
5. Completar perfil com nome
6. Acessar tela principal

### Cenário 2: Usuário Existente
1. Abrir app
2. Informar e-mail existente
3. Receber código OTP
4. Inserir código correto
5. Acessar tela principal diretamente

### Cenário 3: Sessão Ativa
1. Abrir app (dentro de 30 dias)
2. Acessar tela principal automaticamente

## Próximos Passos

- [ ] Implementar analytics para tracking
- [ ] Adicionar fallback por SMS
- [ ] Implementar biometria para re-autenticação
- [ ] Adicionar testes unitários e de integração
- [ ] Configurar Cloud Functions para OTP customizado
- [ ] Implementar offline-first na tela inicial

## Notas Importantes

### Firebase Email Link vs Custom OTP

Esta implementação usa Firebase Email Link (signInWithEmailLink), que:
- Envia link de autenticação por e-mail
- Template customizável no Firebase Console
- Pode ser configurado para mostrar código de 6 dígitos no e-mail

Para OTP 100% customizado (via Cloud Functions):
- Gerar código aleatório de 6 dígitos
- Enviar via SendGrid/Mailgun
- Armazenar hash do código no Firestore
- Verificar código manualmente
- Criar custom token do Firebase

### Segurança

- Códigos OTP são temporários (10 min)
- Rate limiting previne ataques de força bruta
- Tokens do Firebase são seguros e auto-renováveis
- Firestore rules protegem dados do usuário
- Validação de e-mail RFC 5322

## Suporte

Para questões técnicas sobre esta implementação, consulte:
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Email Link Authentication](https://firebase.google.com/docs/auth/web/email-link-auth)
