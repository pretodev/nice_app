Crie um setup de ferramentas agenticas para criação de widgets Flutter com base no Figma.

O fluxo de desenvolvimento vai funcionar com base em arquivo yaml chamado figma.yaml.

Este arquivo é bem simples. O usuário vai editar este arquivo manualmente.

```yaml
assets:
  svg: assets/svg
  png: assets/illustraions
  jpeg: assets/images
  icons:
    prefix: icon-
    type: svg
    destination: assets/svg

components:
  - NiceButton:
      description: "Botão de customizado para aplicativo"
      file_path: lib/features/app/ui/widgets/nice_button/nice_button.dart
      link: https://www.figma.com/design/kzovEnT8UvksVXv99B1lXM/Fitness-App?node-id=64-420&t=bnWsoLDpT2QOaz93-4
```

Ele mapeia cada widget que será construído com e vincula ao um componente ou layer do figma.

No exemplo a cima, `NiceButton` é nome da classe widget do componente Flutter; `description` (opcional) é uma breve informações sobre o componente que pode ser passada para os agentes; `file_path` é arquivo que a classe está localizado; e `link` é o onde o componente pode ser encontrado no figma, sendo o node-id obrigratório.

O acesso do agente ao figma deve ser realizado utilizando o MCP do figma.

---

Uma vez definindo corretamente o arquivo, o usuário pode abrir harness e pedir para implementar um componente com um prompt simples:

```
Implement Figma component NiceButton
```

Com isso uma sequência de passos deve ser realizados:

1. Validação do arquivo figma.yaml:

Verificar se existes, se o componente foi especificado no arquivo, se link é válido, se usuário tem acesso ao link.Tudo isso pode ser feito de forma determinínisca.

2. Identificar se o componente faz uso de outro componente do yaml.

Caso seja identificado um componente, deve ser perguntado qual componente o agente deve seguir com a implementação. Por exemplo, NiceButton faz uso de um NiceIcon, será exibido para usuário qual componente ele quer siga com implementação. Escolhendo o NiceButton, o agente vai seguir com a implementação do NiceIcon, sem alterar nada. Se escolher o NiceIcon, o agente muda o contexto para o componente e começa implementação do widget, ignorando complemente o componente inicial.

3. Identificar componentes figma não mapeados.

Pode ter casos que layer do link tenha um componente figma na sua composição que está mapeado no `figma.yaml`, nestes casos, o agente vai alertar ao usuário sugerindo que ele crie este componente primeiro. O usuário concordando, vai ser realizado a alteração `figma.yaml`, mapeando o novo componente, com um nome e caminho sugerido pelo a gente, o que pode ser alterado pelo usuário. Seguindo por este caminho, o agente muda o contexto para implementação do componente. Se não, vai ser implementado sem levar em consideração que é um componente mapeado no figma.

---

Com as decisões tomadas e contexto de implementação definidas, o agente pode trabalhar, seguindo os seguintes passos.

1. Pegar o código React usando a ferramenta get_design_context do MCP do figma.

2. Escolher a forma gerenciamento de estado

A maioria dos casos deve utilizar o `Stateless`. Caso tenha mudanças de estado internas como animação ou UI toggle, usar o `Stateful`.
Também pode ser utilziado o `didUpdate` para caso onde estado é gerenciado por widget pai.
Usar `ChangeNotifier`/`ValueNotifier` quando o estado pode ser gerenciado externalmente ou injetado.
Não usar bibliotecas externas, apenas o que já vem na API padrão.

3. Implementar o código Flutter alterando/criando o arquivo dart.

A implementação deve seguir boas práticas, evitando renderizações desnecessárias e código enxado. A assinatura do widget deve conter o necessário para customização e apresentação da proposta do figma. Deve ser evitado código depreciado como:

| Deprecated                     | Modern replacement                          |
| ------------------------------ | ------------------------------------------- |
| `Color.withOpacity(x)`         | `Color.withValues(alpha: x)`                |
| `WillPopScope`                 | `PopScope`                                  |
| `MaterialStateProperty`        | `WidgetStateProperty`                       |
| `MaterialState` (and variants) | `WidgetState` (and variants)                |
| `OverlayEntry` (imperative)    | `OverlayPortal` + `OverlayPortalController` |

Usar técnicas modernas de implementação, uso de spacing em `Row`, `Column`, `Wrap`, `Flex` (Flutter 3.27+) ou `padding`/`margin` no lugar de `SizedBox`. Usar o `SizedBox` só para ajuste explicito de espaçamentos. Quando for compor slivers, preferir `SliverMainAxisGroup` e `SliverCrossAxisGroup`. Usar o `OverlayPortal` com `OverlayPortalController` para gerenciar overlays. Usar o [dot shorthand](https://dart.dev/language/dot-shorthands) para Padding, Margins, Bordas, Alinhamentos e outros componentes de ui.

4. Criação do arquivo de preview.

Para componente deve ser criado um arquivo `_preview.dart`, este arquivo vai implementar o [flutter previewer](https://docs.flutter.dev/tools/widget-previewer) do componente. O agente deve mapear todos visualizações e Edcases para o funcionamento do componente. Este arquivo de preview deve ser feito com base exclusivamente no widget que está sendo implementado. O preview é baseado no flutter, mas não se preocupe se componente tem algo nativo, só crie o preview. Para componentes que não tenha uma largura ou alterada fixa, vai ser necessário criar um wrapper para auxiliar na visualização.

O arquivo de preview é basedo no `file_path`, assim `lib/features/app/ui/widgets/nice_button/nice_button.dart` vai ser gerado `lib/features/app/ui/widgets/nice_button/nice_button_preview.dart`.

---

Caso o figma contenha um assets, icones, ilustação, imagem de apoio, este arquivos devem ser baixados para a pasta correspondente encontrados no `figma.yaml`, dentro de `assets`.

Se `assets` definir o `icons`, use isso para identificar-los no figma. No exemplo a cima, se for identificado um componente ou layer que tenho o nome que começa `icon-`, ele o componente inteiro vai ser exportado no formato de `type` (svg) para `destination`. Neste caso, é comum encontrar no figma um vector dentro de um frame, exemplo icon-player-play->Vector, deve ser exportado apartir de icon-player-play, sendo o vetor parte do frame.

Em `icons`, a única propriedade obrigatória é `prefix`, o resto opcional. Sendo assets o caminho padrão para exportação de qualquer artefato do figma.
