# Documentação — DevTracker

**Disciplina:** Desenvolvimento para Dispositivos Móveis
**Aluno:** Pietro de Alexandria Picoli
**RA:** 271418

---

## Estrutura de Arquivos

```
lib/
├── main.dart                        → Ponto de entrada + navegação principal
└── screens/
    ├── profile_screen.dart          → Aba 1: Tela de Perfil (estática)
    ├── study_screen.dart            → Aba 2: Registro de Estudos (reativa)
    └── session_detail_screen.dart   → Tela de Detalhes da Sessão

assets/
└── images/
    ├── profile_picture.jpg
    └── profile_picture1.jpg
```

---

## 1. `main.dart` — Ponto de Entrada e Navegação

### `void main()`
O ponto de entrada de todo app Flutter. A expressão `=> runApp(...)` é uma sintaxe curta do Dart para funções de uma linha, equivalente a escrever `{ return runApp(...); }`. O `runApp` infla o widget raiz na tela.

### `DevTrackerApp` (StatelessWidget)
Widget raiz da aplicação. É um `StatelessWidget` porque não precisa guardar nenhum estado — ele só configura o app.

- `MaterialApp`: configura o app inteiro com título, tema e tela inicial (`home`).
- `ThemeData` + `ColorScheme.fromSeed`: gera automaticamente uma paleta de cores completa a partir de uma cor semente (`seedColor`). Aqui usamos `Color(0xFF1744A0)`, que é o azul personalizado. O prefixo `0xFF` é o canal alpha (opacidade total) seguido do hex da cor.
- `home: const HomeScreen()`: define qual tela abre primeiro.

### `HomeScreen` (StatefulWidget)
Precisa ser `StatefulWidget` porque guarda `_currentIndex`, que muda quando o usuário troca de aba — e essa mudança precisa redesenhar a tela.

- `_currentIndex`: inteiro que controla qual aba está ativa. Começa em `0` (Perfil).
- `setState(() => _currentIndex = i)`: quando o usuário toca em uma aba, atualiza o índice e avisa o Flutter para redesenhar o widget.

### `IndexedStack`
Mantém **todas as telas na memória ao mesmo tempo**, mas exibe apenas a do índice atual. A vantagem sobre um simples `if/else` é que o estado de cada tela é preservado ao trocar de aba — se você digitou algo na aba de Estudos e foi para o Perfil, ao voltar o texto ainda está lá.

### `BottomNavigationBar`
Barra de navegação inferior com dois itens. O `currentIndex` sincroniza o item destacado com a tela visível. O `onTap` recebe o índice do item clicado e chama `setState`.

---

## 2. `profile_screen.dart` — Tela de Perfil

### `ProfileScreen` (StatelessWidget)
É `StatelessWidget` porque a tela é completamente estática — nenhum dado muda após ser construída.

### `SingleChildScrollView`
Envolve o conteúdo da tela para permitir rolagem caso o conteúdo ultrapasse a altura disponível (ex: teclado aberto, tela pequena). Evita o erro de overflow amarelo/preto.

### Cabeçalho com `Stack` e `Positioned`

```
SizedBox (altura 160)
└── Stack (clipBehavior: Clip.none)
    ├── Container azul (banner, altura 120)
    └── Positioned (bottom: -10)
        └── CircleAvatar (foto)
```

- `Stack`: empilha widgets no eixo Z (profundidade). Os filhos ficam uns sobre os outros.
- `clipBehavior: Clip.none`: por padrão, o Stack corta tudo que sair dos seus limites. Com `Clip.none`, permitimos que a foto ultrapasse a borda inferior do Stack (o efeito de "sobrepor" o banner).
- `SizedBox(height: 160)`: define a altura total da área do cabeçalho. O banner tem 120px, e os 40px restantes são o espaço para a foto "vazar" para baixo.
- `Positioned(bottom: -10)`: posiciona o filho a -10px da borda inferior do Stack, fazendo a foto cruzar a linha do banner.
- `CircleAvatar`: widget nativo do Flutter para exibir imagens circulares. `backgroundImage: AssetImage(...)` carrega a imagem dos assets locais. `radius: 48` define o raio (tamanho) do círculo.

### Dados do Perfil
Dois widgets `Text` simples com `TextStyle` para controlar tamanho e peso da fonte.

### Seção de Conquistas com `Row` e `Expanded`

```
Row
├── Expanded → _AchievementCard('Foco')
├── SizedBox (espaçamento)
├── Expanded → _AchievementCard('Disciplina')
├── SizedBox (espaçamento)
└── Expanded → _AchievementCard('Código Limpo')
```

- `Row`: organiza os filhos horizontalmente.
- `Expanded`: faz cada card ocupar **a mesma fração** do espaço horizontal disponível. Sem ele, os cards teriam tamanhos diferentes ou causariam overflow.

### `_AchievementCard` (widget privado)
Classe auxiliar com underscore (`_`) no nome, o que em Dart significa que é **privada ao arquivo**. Recebe `label` e `icon` pelo construtor, evitando repetição de código para os 3 cards.

---

## 3. `study_screen.dart` — Registro de Estudos

### `StudySession` (modelo de dados)
Classe simples que representa uma sessão de estudo com dois campos: `technology` (String) e `hours` (double). Serve como "molde" para os objetos da lista.

### `StudyScreen` (StatefulWidget) e `_StudyScreenState`
É `StatefulWidget` porque esta tela tem dados que mudam: o total de horas e a lista de sessões. Toda vez que `setState` é chamado, o Flutter reconstrói o `build` com os valores atualizados.

**Variáveis de estado:**
- `_techController` e `_hoursController`: `TextEditingController` são objetos que ficam "ligados" a um `TextField` e permitem ler ou limpar o texto programaticamente.
- `_sessions`: lista de objetos `StudySession` que cresce a cada registro.
- `_totalHours`: acumulador numérico do total de horas.

### `_registerSession()` — Lógica de Validação e Registro

```dart
void _registerSession() {
  final tech = _techController.text.trim();       // lê e remove espaços
  final hoursText = _hoursController.text.trim();

  if (tech.isEmpty || hoursText.isEmpty) return;  // validação: campos vazios

  final hours = double.tryParse(hoursText);        // tenta converter para número
  if (hours == null || hours <= 0) return;         // validação: número inválido ou zero

  setState(() {
    _sessions.insert(0, StudySession(...));        // insere no início da lista
    _totalHours += hours;                          // acumula o total
    _techController.clear();                       // limpa os campos
    _hoursController.clear();
  });
}
```

- `.trim()`: remove espaços em branco no início e fim do texto.
- `double.tryParse()`: tenta converter uma String para double. Retorna `null` se não conseguir (ex: texto "abc"), evitando exceções.
- `_sessions.insert(0, ...)`: insere no índice 0 (início da lista) para que o registro mais recente apareça no topo da lista.
- `setState()`: notifica o Flutter que o estado mudou e que o `build` deve ser executado novamente.

### `dispose()`
Método do ciclo de vida do Flutter chamado quando o widget é removido da árvore. É **obrigatório** chamar `.dispose()` nos controllers para liberar memória e evitar vazamentos (memory leaks).

### Card Totalizador
Exibe o total de horas. A expressão:
```dart
_totalHours % 1 == 0
    ? _totalHours.toInt().toString()
    : _totalHours.toString()
```
Verifica se o número é inteiro (ex: `4.0`) para exibir sem decimal (`4`), ou mantém o decimal quando necessário (ex: `4.5`).

### `TextField`
- `controller`: liga o campo ao `TextEditingController`.
- `keyboardType: TextInputType.numberWithOptions(decimal: true)`: abre o teclado numérico com suporte a vírgula/ponto decimal no campo de horas.
- `InputDecoration`: configura o visual do campo (label, borda, ícone).

### `ElevatedButton.icon`
Botão com ícone e texto. O `onPressed` aponta para `_registerSession`. O `style` com `ElevatedButton.styleFrom` personaliza cor de fundo e cor do texto/ícone.

### `Expanded` + `ListView.builder`
- `Expanded`: faz a lista ocupar todo o espaço vertical restante da tela. Sem ele, o `ListView` tentaria ter altura infinita dentro de uma `Column`, causando erro de overflow.
- `ListView.builder`: constrói os itens **sob demanda** (lazy loading) — só renderiza os cards visíveis na tela, o que é mais eficiente que um `ListView` comum com todos os itens de uma vez.
- `itemCount`: quantos itens a lista tem.
- `itemBuilder`: função chamada para cada item, recebendo o `index` atual.

### Navegação para Detalhes
```dart
onTap: () => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => SessionDetailScreen(
      technology: session.technology,
      hours: session.hours,
    ),
  ),
),
```
- `Navigator.push`: empurra uma nova tela para a pilha de navegação, com animação de transição.
- `MaterialPageRoute`: define a rota com animação padrão do Material Design.
- Os dados (`technology` e `hours`) são passados diretamente pelo construtor da tela de destino — sem variáveis globais.

---

## 4. `session_detail_screen.dart` — Detalhes da Sessão

### `SessionDetailScreen` (StatelessWidget)
Tela simples e estática que só exibe dados recebidos. Não precisa de estado próprio.

### Construtor com parâmetros obrigatórios
```dart
const SessionDetailScreen({
  super.key,
  required this.technology,
  required this.hours,
});
```
- `required`: palavra-chave do Dart que torna o parâmetro obrigatório. O compilador impede que a tela seja criada sem passar esses dados.
- `super.key`: repassa a chave para o widget pai, boa prática em Flutter para otimização da árvore de widgets.

### `mainAxisSize: MainAxisSize.min`
Faz a `Column` ocupar apenas o espaço necessário para seus filhos, em vez de expandir para a altura total da tela. Combinado com o `Center`, centraliza o bloco de conteúdo verticalmente.

### `Navigator.pop(context)`
Remove a tela atual da pilha de navegação, voltando para a tela anterior (lista de sessões). É o equivalente ao botão "voltar" do sistema, mas acionado manualmente pelo botão na tela.

---

## Conceitos-Chave Resumidos

| Conceito | Para que serve |
|---|---|
| `StatelessWidget` | Tela/componente sem dados que mudam |
| `StatefulWidget` | Tela/componente com dados reativos |
| `setState()` | Avisa o Flutter para redesenhar o widget |
| `IndexedStack` | Mantém múltiplas telas na memória, exibe uma por vez |
| `Stack` + `Positioned` | Sobreposição de widgets no eixo Z |
| `Expanded` | Distribui espaço igualmente entre filhos de Row/Column |
| `ListView.builder` | Lista eficiente que renderiza só o que está visível |
| `TextEditingController` | Lê e controla o conteúdo de um TextField |
| `Navigator.push/pop` | Navega entre telas (empurra/remove da pilha) |
| `required` no construtor | Garante passagem obrigatória de dados entre telas |
| `dispose()` | Libera recursos quando o widget é destruído |
| `double.tryParse()` | Converte String para número sem lançar exceção |
