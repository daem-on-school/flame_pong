import 'package:bloc/bloc.dart';

class PongEvent {}
class PlayerScored extends PongEvent {}
class EnemyScored extends PongEvent {}
class PlayAgain extends PongEvent {}

abstract class PongState {
  final int player;
  final int enemy;

  PongState(this.player, this.enemy);
}

const int scoreLimit = 10;

class PlayingState extends PongState {
  PlayingState(int player, int enemy) : super(player, enemy);

  PlayingState incrementPlayer() => PlayingState(player + 1, enemy);
  PlayingState incrementEnemy() => PlayingState(player, enemy + 1);
  EndedState end() => EndedState(player, enemy);

  get shouldEnd => player >= scoreLimit || enemy >= scoreLimit;
}

class EndedState extends PongState {
  EndedState(int player, int enemy) : super(player, enemy);

  PlayingState restart() => PlayingState(0, 0);
}

class PongBloc extends Bloc<PongEvent, PongState> {
  PongBloc() : super(EndedState(0, 0)) {
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
    on<PlayAgain>((event, emit) {
      if (state is! EndedState) return;
      emit((state as EndedState).restart());
    });
  }
}