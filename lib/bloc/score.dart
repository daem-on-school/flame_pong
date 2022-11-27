import 'package:bloc/bloc.dart';

class PongEvent {}
class PlayerScored extends PongEvent {}
class EnemyScored extends PongEvent {}
class StartGame extends PongEvent {}

abstract class PongState {
  final int player;
  final int enemy;

  PongState(this.player, this.enemy);
}

const int scoreLimit = 10;

class TitleState extends PongState {
  TitleState() : super(0, 0);
}

class PlayingState extends PongState {
  PlayingState(int player, int enemy) : super(player, enemy);

  PlayingState incrementPlayer() => PlayingState(player + 1, enemy);
  PlayingState incrementEnemy() => PlayingState(player, enemy + 1);
  EndedState end() => EndedState(player, enemy);

  get shouldEnd => player >= scoreLimit || enemy >= scoreLimit;
}

class EndedState extends PongState {
  EndedState(int player, int enemy) : super(player, enemy);
}

class PongBloc extends Bloc<PongEvent, PongState> {
  PongBloc() : super(TitleState()) {
    on<PlayerScored>((event, emit) {
      if (state is! PlayingState) return;
      final s = (state as PlayingState).incrementPlayer();
      emit(s.shouldEnd ? s.end() : s);
    });
    on<EnemyScored>((event, emit) {
      if (state is! PlayingState) return;
      final s = (state as PlayingState).incrementEnemy();
      emit(s.shouldEnd ? s.end() : s);
    });
    on<StartGame>((event, emit) {
      if (state is PlayingState) return;
      emit(PlayingState(0, 0));
    });
  }
}