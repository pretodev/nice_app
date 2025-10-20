# 1. Objetivo

Limitar a funcionalidade de mesclagem de exercícios (merge) na interface do usuário, desabilitando o botão de merge quando os exercícios selecionados não formam uma combinação válida. Isso previne que o método `mergeExercises` lance exceções, melhorando a experiência do usuário.

# 2. Escopo (Módulos Afetados)

- `lib/features/trainning/data/training_selector.dart`
- `lib/features/trainning/ui/widgets/training_editor_bottom_bar.dart`

# 3. Referências (Pontos de Partida)

- **`training_selector.dart`**: Contém a lógica de seleção e o getter `canMerge`, que está incorreto e precisa ser corrigido. A classe armazena a lista de `_selecteds` (`PositionedExercise`).
- **`exercise_set.dart`**: Contém a implementação do método `mergeExercises` e `_mergeSets`, que define as regras de negócio para uma mesclagem válida (Straight+Straight, BiSet+Straight, etc.).
- **`training_editor_bottom_bar.dart`**: Widget que contém o `IconButton` para a ação de merge. Atualmente, o botão não é desabilitado, apenas fica visível se houver itens selecionados.
- **`training.dart`**: A classe `Training` instancia o `TrainingSelector`, passando a lista de `ExerciseSet` para ele. Isso pode precisar de um ajuste para garantir que o seletor tenha a referência correta.

# 4. Requisitos Técnicos e Restrições

- A validação deve ocorrer na camada de dados/estado (`TrainingSelector`) para manter a UI limpa.
- O botão de merge na `TrainingEditorBottomBar` deve ser visualmente desabilitado (`onPressed: null`) quando `TrainingSelector.canMerge` for `false`.
- A lógica de `canMerge` deve refletir precisamente as regras de `_mergeSets` em `exercise_set.dart`:
  - Não é possível mesclar mais de 3 exercícios.
  - A combinação de tipos de `ExerciseSet` deve ser válida (ex: não se pode mesclar dois `BiSet`s).

# 5. Fluxo de Execução (Alto Ní­vel)

1. O `TrainingSelector` é modificado para ter acesso à lista completa de `ExerciseSet` do treino, não apenas a lista de `PositionedExercise`.
2. A lógica do getter `canMerge` em `TrainingSelector` é reescrita para:
   a. Verificar se o número de exercícios selecionados está entre 2 e 3.
   b. Obter os `ExerciseSet`s únicos correspondentes aos `PositionedExercise`s selecionados.
   c. Validar se a combinação desses `ExerciseSet`s é permitida pela lógica de `_mergeSets` (ex: a soma dos exercícios nos sets não pode ultrapassar 3).
3. O widget `TrainingEditorBottomBar` lê o valor de `training.requireValue.selector.canMerge`.
4. O `onPressed` do `IconButton` de merge é definido como `canMerge ? widget.mergeClicked : null`.
5. Como resultado, o botão de merge é automaticamente habilitado ou desabilitado na UI conforme o usuário seleciona ou deseleciona exercícios.

# 6. Tarefas Principais (Critérios de Aceite)

- [ ] Modificar o construtor de `TrainingSelector` para receber e armazenar a `List<ExerciseSet>` completa como um campo privado (ex: `_sets`).
- [ ] Reescrever o getter `canMerge` em `TrainingSelector` para implementar a lógica de validação correta, baseada nos tipos dos `ExerciseSet`s referenciados pelos exercícios selecionados.
- [ ] A nova lógica de `canMerge` deve garantir que a soma de exercícios nos sets a serem mesclados não seja maior que 3.
- [ ] Em `training_editor_bottom_bar.dart`, modificar o `IconButton` de merge para que seu `onPressed` seja `widget.training.requireValue.selector.canMerge ? widget.mergeClicked : null`.
- [ ] Garantir que o `Training` passe a lista de `_sets` corretamente para o `TrainingSelector` após cada modificação (add, remove, merge).
