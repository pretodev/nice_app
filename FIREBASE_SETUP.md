# Guia de Configuração do Firebase - Autenticação OTP

## Pré-requisitos

- Conta Firebase ativa
- Projeto Firebase criado
- Firebase CLI instalado (para configurações avançadas)

## 1. Configuração do Firebase Authentication

### 1.1 Habilitar Email Link Authentication

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione seu projeto
3. Vá para **Authentication** > **Sign-in method**
4. Clique em **Email/Password**
5. Habilite **Email link (passwordless sign-in)**
6. Clique em **Save**

![Firebase Auth Setup](https://firebase.google.com/docs/auth/web/email-link-auth)

### 1.2 Configurar Template de E-mail

1. No Firebase Console, vá para **Authentication** > **Templates**
2. Selecione **Email link to sign-in**
3. Clique no ícone de edição (lápis)
4. Configure o template:

```
Subject: Seu código de acesso - Nice App

Body:
Olá,

Seu código de acesso é: %LINK%

Use este código para fazer login no Nice App. Este código expira em 10 minutos.

Se você não solicitou este código, ignore este e-mail.

Obrigado,
Equipe Nice App

---
Não responda este e-mail. Para suporte, visite: [SEU_SITE]
```

**Nota:** O Firebase substituirá `%LINK%` pelo link de verificação. Você pode personalizar o template para extrair apenas o código OTP.

### 1.3 Personalizar Template (Avançado)

Para exibir um código de 6 dígitos em vez de um link completo, você pode usar Cloud Functions:

```typescript
// functions/src/index.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const sendOtpEmail = functions.https.onCall(async (data, context) => {
  const email = data.email;
  
  // Gerar código de 6 dígitos
  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  
  // Armazenar no Firestore com TTL de 10 minutos
  await admin.firestore().collection('otpCodes').doc(email).set({
    code: otp,
    expiresAt: admin.firestore.Timestamp.fromMillis(Date.now() + 10 * 60 * 1000),
    attempts: 0
  });
  
  // Enviar e-mail via SendGrid, Mailgun, etc.
  // ...
  
  return { success: true };
});
```

## 2. Configurar Firebase Dynamic Links

### 2.1 Criar Dynamic Link Domain

1. No Firebase Console, vá para **Dynamic Links**
2. Clique em **Get Started**
3. Configure um domínio personalizado ou use o padrão do Firebase
4. Exemplo: `niceapp.page.link`

### 2.2 Configurar Deep Links no Android

#### AndroidManifest.xml

```xml
<activity android:name=".MainActivity">
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data
            android:scheme="https"
            android:host="niceapp.page.link"
            android:pathPrefix="/verify" />
    </intent-filter>
</activity>
```

#### build.gradle (app level)

```gradle
dependencies {
    // Outras dependências...
    implementation 'com.google.firebase:firebase-dynamic-links:21.1.0'
}
```

### 2.3 Configurar Deep Links no iOS

#### Info.plist

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.pretodev.nice</string>
        </array>
    </dict>
</array>

<key>FlutterDeepLinkingEnabled</key>
<true/>
```

## 3. Configurar Firestore Security Rules

### firestore.rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir leitura/escrita apenas para o próprio usuário
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Códigos OTP (se usando Cloud Functions)
    match /otpCodes/{email} {
      // Apenas Cloud Functions podem escrever
      allow write: if false;
      // Ninguém pode ler diretamente
      allow read: if false;
    }
  }
}
```

## 4. Configurar Firebase Storage (Opcional)

Se você planeja permitir upload de fotos de perfil:

### storage.rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 5. Variáveis de Ambiente

### env.json (não commitar no git)

```json
{
  "FIREBASE_API_KEY": "sua-api-key",
  "FIREBASE_PROJECT_ID": "seu-project-id",
  "FIREBASE_APP_ID": "seu-app-id",
  "FIREBASE_MESSAGING_SENDER_ID": "seu-sender-id",
  "DYNAMIC_LINK_DOMAIN": "niceapp.page.link"
}
```

### .gitignore

```
env.json
env.*.json
*.env
```

## 6. Testar a Configuração

### 6.1 Teste Manual

1. Execute o app
2. Informe um e-mail válido
3. Verifique se o e-mail foi recebido
4. Copie o código/link do e-mail
5. Cole no app
6. Verifique se o login foi bem-sucedido

### 6.2 Teste de Rate Limiting

1. Solicite 3 códigos em menos de 1 hora
2. Tente solicitar o 4º código
3. Verifique se o bloqueio de 1 hora foi aplicado

### 6.3 Teste de Tentativas

1. Solicite um código
2. Insira códigos incorretos 5 vezes
3. Verifique se o botão de verificação foi desabilitado
4. Verifique se apenas o botão de reenvio está disponível

## 7. Monitoramento

### 7.1 Firebase Authentication Logs

No Firebase Console, vá para **Authentication** > **Users** para ver:
- Usuários criados
- Últimos logins
- Métodos de autenticação usados

### 7.2 Cloud Functions Logs (se aplicável)

```bash
firebase functions:log
```

### 7.3 Analytics (Recomendado)

Configure Firebase Analytics para rastrear:
- Taxa de conversão do fluxo de OTP
- Tempo médio de conclusão
- Taxa de erro por etapa

## 8. Troubleshooting

### Problema: E-mails não estão sendo enviados

**Solução:**
1. Verifique se o Email Link está habilitado no Firebase Console
2. Verifique se o domínio de envio está verificado
3. Confira a caixa de spam do e-mail

### Problema: Dynamic Links não estão funcionando

**Solução:**
1. Verifique se o domínio está configurado corretamente
2. Confirme que os deep links estão configurados no AndroidManifest.xml e Info.plist
3. Use o [Firebase Dynamic Links Debugger](https://firebase.google.com/docs/dynamic-links/debug)

### Problema: Rate limiting não está funcionando

**Solução:**
1. Limpe o cache do SharedPreferences
2. Verifique os logs para confirmar que as timestamps estão sendo salvas
3. Reinstale o app para resetar o SharedPreferences

### Problema: Usuário não é redirecionado após login

**Solução:**
1. Verifique se as rotas estão configuradas corretamente no MaterialApp
2. Confirme que o SplashScreen está verificando o estado de autenticação
3. Verifique os logs do Firebase Auth

## 9. Próximos Passos

- [ ] Configurar Cloud Functions para OTP customizado
- [ ] Implementar envio de e-mail via SendGrid/Mailgun
- [ ] Adicionar analytics para rastreamento
- [ ] Configurar testes automatizados
- [ ] Implementar backup de autenticação via SMS

## 10. Recursos Úteis

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Email Link Authentication Guide](https://firebase.google.com/docs/auth/web/email-link-auth)
- [Dynamic Links Setup](https://firebase.google.com/docs/dynamic-links)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Cloud Functions for Firebase](https://firebase.google.com/docs/functions)

## Suporte

Para questões sobre esta configuração:
1. Consulte a documentação do Firebase
2. Verifique o README.md do projeto
3. Entre em contato com a equipe de desenvolvimento
