# 1. Objetivo

Corrigir o comportamento visual da seleção de exercícios compostos (Bi-Set e Tri-Set) na tela de edição de treino. Atualmente, a seleção de um exercício dentro de um Bi-Set ou Tri-Set não é refletida na interface do usuário, ao contrário do que acontece com exercícios normais (StraightSet).

# 2. Escopo (Módulos Afetados)

- `lib/features/trainning/ui/widgets/training_editor_body.dart`
- `lib/features/trainning/ui/widgets/exercise_set_widget.dart`

# 3. Referências (Pontos de Partida)

- **`training_editor_body.dart`** - Widget principal que renderiza a lista de exercícios do treino. É aqui que a lógica de seleção precisa ser passada para os widgets filhos.
- **`exercise_set_widget.dart`** - Contém os widgets `BiSetWidget` e `TriSetWidget` que precisam ser refatorados para receber e exibir o estado de seleção individual de cada exercício.
- **`training.dart`** - Contém a classe `Training`, que possui a propriedade `selector` (`TrainingSelector`), responsável por gerenciar quais exercícios estão selecionados.
- **`exercise_set.dart`** - Define as classes `BiSet` e `TriSet`, e mais importante, as propriedades `first`, `second`, `third` que retornam um `PositionedExercise`, usado pelo `TrainingSelector`.

# 4. Requisitos Técnicos e Restrições

- A lógica de seleção existente, centralizada no `TrainingSelector`, deve ser mantida.
- A mudança deve ser primariamente na passagem de estado (props) da `TrainingEditorBody` para os widgets de `ExerciseSet`.
- Refatorar `BiSetWidget` e `TriSetWidget` para remover os enums `BiSetSelectStates` e `TriSetSelectStates`, substituindo-os por parâmetros booleanos individuais para a seleção de cada exercício.

# 5. Fluxo de Execução (Alto Ní­vel)

1. O `TrainingEditorBody` recebe o estado do treino, incluindo a lista de `ExerciseSet` e o `TrainingSelector`.
2. Ao construir a lista, o `ListView.builder` encontra um `BiSet` ou `TriSet`.
3. O `TrainingEditorBody` verifica, para cada exercício dentro do `BiSet`/`TriSet`, se ele está selecionado, chamando `training.selector.has(set.first)`, `training.selector.has(set.second)`, etc.
4. Os resultados booleanos dessa verificação são passados como parâmetros (`firstSelected`, `secondSelected`, etc.) para o `BiSetWidget` ou `TriSetWidget`.
5. O `BiSetWidget`/`TriSetWidget` passa o respectivo booleano para o parâmetro `selected` de cada `ExerciseSetItem` filho.
6. O `ExerciseSetItem` renderiza um fundo diferente para indicar que está selecionado, corrigindo o bug visual.

# 6. Tarefas Principais (Critérios de Aceite)

- [ ] Refatorar o `BiSetWidget` em `exercise_set_widget.dart` para remover o parâmetro `state` do tipo `BiSetSelectStates`.
- [ ] Adicionar os parâmetros `final bool firstSelected` e `final bool secondSelected` ao `BiSetWidget`, com valor padrão `false`.
- [ ] No `build` do `BiSetWidget`, substituir a lógica de `state == ...` pelo uso direto dos novos parâmetros booleanos no `ExerciseSetItem` correspondente.
- [ ] Refatorar o `TriSetWidget` em `exercise_set_widget.dart` para remover o parâmetro `seleted` (com erro de digitação) do tipo `TriSetSelectStates`.
- [ ] Adicionar os parâmetros `final bool firstSelected`, `final bool secondSelected`, e `final bool thirdSelected` ao `TriSetWidget`, com valor padrão `false`.
- [ ] No `build` do `TriSetWidget`, substituir a lógica de `seleted == ...` pelo uso direto dos novos parâmetros booleanos no `ExerciseSetItem` correspondente.
- [ ] Em `training_editor_body.dart`, ao renderizar um `BiSetWidget`, passar os parâmetros `firstSelected: training.selector.has(set.first)` e `secondSelected: training.selector.has(set.second)`.
- [ ] Em `training_editor_body.dart`, ao renderizar um `TriSetWidget`, passar os parâmetros `firstSelected: training.selector.has(set.first)`, `secondSelected: training.selector.has(set.second)`, e `thirdSelected: training.selector.has(set.third)`.
