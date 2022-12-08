part of 'main.dart';

final db = FirebaseFirestore.instance;

class MainView extends StatelessWidget {
  final PongGame _game = PongGame();

  MainView({Key? key}) : super(key: key);

  static const gradientBackground = DecoratedBox(decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFF6918C2), Color(0xFFA158D2), Color(0xFF5C57EC)],
    ),
  ));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PongBloc>(
      create: (context) => PongBloc(),
      child: BlocConsumer<PongBloc, PongState>(
        listener: (context, state) async {
          if (state is EndedState) {
            _game.pauseEngine();
            final name = await _showNamePrompt(context);
            _recordScore(state, name);
          } else if (state is PlayingState) {
            _game.resumeEngine();
            if (state.interest is Standard) {
              _game.clearAngledWalls();
            } else if (state.interest is Interesting) {
              _game.makeInteresting();
            }
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              GameWidget(game: _game, backgroundBuilder: _backgroundBuilder),
              if (state is EndedState) Center(child: EndScreen(_game, state)),
              if (state is TitleState) const Center(child: TitleScreen()),
            ],
          );
        }
      ),
    );
  }

  Future<String> _showNamePrompt(BuildContext context) async {
    final name = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter a name for the scoreboard'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Name',
          ),
          maxLength: 4,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          onSubmitted: (name) => Navigator.of(context).pop(name),
        )
      ),
    );
    return name ?? 'Anon';
  }

  void _recordScore(EndedState state, String name) async {
    if (!firebaseEnabled) return;

    await db.collection('scores').add({
      'player': state.player,
      'enemy': state.enemy,
      'date': DateTime.now(),
      'user': name,
    });
  }

  Widget _backgroundBuilder(context) {
    return Stack(
      children: [
        const Positioned.fill(child: gradientBackground),
        Positioned.fill(child: _buildText()),
      ],
    );
  }

  Widget _buildText() {
    return FittedBox(
      fit: BoxFit.contain,
      child: BlocBuilder<PongBloc, PongState>(
        builder: (context, state) {
          if (state is! PlayingState) return const SizedBox();
          return Text(
              "${state.player}:${state.enemy}",
              style: baseStyle.copyWith(color: Colors.white30)
          );
        },
      ),
    );
  }
}

const primaryPurple = Color(0xFF6918C2);

const TextStyle baseStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: "Inter",
  decoration: TextDecoration.none,
);

final TextStyle titleStyle = baseStyle.copyWith(
  fontSize: 40,
);

final TextStyle scoreStyle = baseStyle.copyWith(
    fontSize: 60,
    color: primaryPurple,
    height: 1.0
);

class MenuContainer extends StatelessWidget {
  final Widget child;
  const MenuContainer(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(width: 260, child: child)
    );
  }
}


class EndScreen extends StatelessWidget {
  final PongGame game;
  final EndedState state;

  const EndScreen(
      this.game, this.state, {Key? key}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuContainer(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Game Over",
            style: titleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Score".toUpperCase(),
            style: baseStyle,
            textAlign: TextAlign.center,
          ),
          Text(
            "${state.player}:${state.enemy}",
            style: scoreStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (firebaseEnabled) CustomButton(
            text: "Scores",
            color: Colors.black,
            onPressed: () => Navigator.of(context).push(ScoreView.route),
          ),
          CustomButton(
            text: "Play Again",
            color: primaryPurple,
            onPressed: () => context.read<PongBloc>().add(StartGame()),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.color,
  }) : super(key: key);

  final void Function()? onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: color,
          onPrimary: Colors.white,
          visualDensity: VisualDensity.comfortable
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class TitleScreen extends StatelessWidget {
  const TitleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuContainer(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Pong",
            style: titleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: "Play",
            color: primaryPurple,
            onPressed: () => context.read<PongBloc>().add(StartGame()),
          ),
          if (firebaseEnabled) CustomButton(
            text: "Scores",
            color: Colors.black,
            onPressed: () => Navigator.of(context).push(ScoreView.route),
          ),
        ],
      ),
    );
  }
}
