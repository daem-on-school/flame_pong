import 'package:flame/game.dart';
import 'package:flame_pong/bloc/score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game/game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PongGame _game = PongGame();

  MyApp({Key? key}) : super(key: key);

  static const gradientBackground = DecoratedBox(decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFF6918C2), Color(0xFFA158D2), Color(0xFF5C57EC)],
    ),
  ));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
        fontFamily: 'Inter'
      ),
      home: BlocProvider<PongBloc>(
        create: (context) => PongBloc(),
        child: BlocConsumer<PongBloc, PongState>(
          listener: (context, state) {
            if (state is EndedState) { _game.pauseEngine(); }
          },
          builder: (context, state) {
            return Stack(
              children: [
                GameWidget(game: _game, backgroundBuilder: _backgroundBuilder),
                if (state is EndedState) Center(child: EndScreen(_game, state)),
              ],
            );
          }
        ),
      ),
    );
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

class EndScreen extends StatelessWidget {
  final PongGame game;
  final EndedState state;


  const EndScreen(
    this.game, this.state, {Key? key}
  ) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 260,
        child: Column(
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryPurple,
                onPrimary: Colors.white,
                visualDensity: VisualDensity.comfortable
              ),
              onPressed: () {
                context.read<PongBloc>().add(PlayAgain());
                game.resumeEngine();
              },
              child: const Text("Play Again"),
            ),
          ],
        ),
      ),
    );
  }
}
