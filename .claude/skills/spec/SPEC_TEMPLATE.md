# Spec Template

Use this template for feature specification documents.

```markdown
# Especificação: [Nome da Feature]

**Data**: YYYY-MM-DD
**Status**: Draft | Em Revisão | Aprovado

## Resumo

[Breve descrição da feature em 2-3 frases]

---

## 1. Modelagem de Domínio

### 1.1 Entidades

| Entidade | Descrição | Campos Principais |
|----------|-----------|-------------------|
| EntityName | Descrição | id, campo1, campo2 |

### 1.2 Value Objects

| Value Object | Descrição | Propriedades |
|--------------|-----------|--------------|
| VOName | Descrição | prop1, prop2 |

### 1.3 Enums

```dart
enum EnumName {
  value1,
  value2,
}
```

### 1.4 Sealed Classes (se aplicável)

```dart
sealed class TypeName {
  // Variantes
}

class Variant1 extends TypeName { }
class Variant2 extends TypeName { }
```

### 1.5 Falhas (Failures)

| Failure | Descrição | Quando Ocorre |
|---------|-----------|---------------|
| FailureName | Descrição | Condição |

### 1.6 Eventos (se aplicável)

| Evento | Descrição | Payload |
|--------|-----------|---------|
| EventName | Descrição | data |

---

## 2. Repository

**Nome**: `FeatureRepository`
**Localização**: `lib/features/[feature]/data/[feature]_repository.dart`

### Responsabilidades
- Único ponto de verdade para dados da feature
- Sem lógica de negócio
- Usa streams para dados reativos

### Fontes de Dados
- [ ] Firestore
- [ ] API Externa
- [ ] Cache Local

### Métodos

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `store(Entity)` | `FutureResult<Unit>` | Persiste entidade |
| `delete(Entity)` | `FutureResult<Unit>` | Remove entidade |
| `fromId(String)` | `Stream<Entity>` | Stream por ID |

---

## 3. Commands (UseCases)

### 3.1 [CommandName]

**Arquivo**: `lib/features/[feature]/providers/commands/[command_name]_command.dart`

**Objetivo**: [Descrição clara do que o comando faz]

**Dependências**:
- Repository: sim/não
- Services: [listar]
- Outros Commands: [listar]

**Parâmetros**:
| Param | Tipo | Descrição |
|-------|------|-----------|
| param1 | Type | Descrição |

**Regras de Negócio**:
1. Regra 1
2. Regra 2

**Retorno**: `Result<ReturnType>`

---

## 4. Queries

### 4.1 [QueryName]

**Arquivo**: `lib/features/[feature]/providers/provider_queries.dart`

**Objetivo**: [O que agrupa/retorna]

**Providers Observados**:
- provider1
- provider2

**Retorno**: `Stream<Type>` ou `AsyncValue<Type>`

---

## 5. Views

### 5.1 [ViewName]

**Arquivo**: `lib/features/[feature]/ui/[view_name]_view.dart`

**Tipo**: Página | Modal | Dialog

**Navegação**:
```dart
// Para páginas
static PageRoute<ReturnType> route({required params}) {
  return MaterialPageRoute<ReturnType>(
    builder: (context) => ViewName(params),
  );
}

// Para modais
static Future<ReturnType?> show({
  required BuildContext context,
  required params,
}) async {
  return showModalBottomSheet<ReturnType>(
    context: context,
    builder: (context) => ViewName(params),
  );
}
```

**Commands Utilizados**:
- Command1
- Command2

**Queries Observadas**:
- Query1
- Query2

---

## 6. Widgets

### 6.1 [WidgetName]

**Arquivo**: `lib/features/[feature]/ui/widgets/[widget_name].dart`

**Tipo**: StatelessWidget

**Props**:
| Prop | Tipo | Descrição |
|------|------|-----------|
| prop1 | Type | Descrição |

**Callbacks**:
| Callback | Tipo | Descrição |
|----------|------|-----------|
| onAction | Function | Descrição |

---

## 7. Fluxos de Usuário

### 7.1 [FlowName]

```
1. Usuário [ação inicial]
2. Sistema [resposta/tela]
3. Usuário [próxima ação]
4. Sistema [processamento]
5. Resultado [sucesso/erro]
```

---

## 8. Dependências

### Features Dependentes
- [ ] Feature1 - motivo
- [ ] Feature2 - motivo

### Recursos Shared
- [ ] CommandMixin
- [ ] FirestoreCustomDocumentReference
- [ ] [outros]

### Pacotes Externos
- [ ] Pacote1 - uso

---

## 9. Considerações de Segurança

- [ ] Autenticação necessária
- [ ] Validação de dados de entrada
- [ ] Sanitização de dados
- [ ] Controle de acesso (authorization)

---

## 10. Estrutura de Arquivos

```
lib/features/[feature]/
├── data/
│   ├── [entity].dart
│   ├── [entity].freezed.dart
│   ├── [feature]_repository.dart
│   └── firestore/
│       └── firestore_[feature]_document.dart
├── providers/
│   ├── provider_services.dart
│   ├── provider_queries.dart
│   └── commands/
│       └── [command]_command.dart
└── ui/
    ├── [view]_view.dart
    └── widgets/
        └── [widget].dart
```

---

## 11. Checklist de Implementação

- [ ] Criar entidades e value objects
- [ ] Implementar repository
- [ ] Criar commands necessários
- [ ] Implementar queries
- [ ] Desenvolver views
- [ ] Criar widgets reutilizáveis
- [ ] Adicionar testes unitários
- [ ] Adicionar testes de integração
- [ ] Documentar API (se aplicável)
```
