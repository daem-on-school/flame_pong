import 'package:bloc/bloc.dart';

class PongEvent {}
class PlayerScored extends PongEvent {}
class EnemyScored extends PongEvent {}
class StartGame extends PongEvent {}
class Bounced extends PongEvent {}

abstract class PongState {
  final int player;
  final int enemy;

  PongState(this.player, this.enemy);
}

const int scoreLimit = 10;
const int boringBounceLimit = 6;

class TitleState extends PongState {
  TitleState() : super(0, 0);
}

abstract class InterestState {}
class Standard extends InterestState {
  final int bounces;
  Standard(this.bounces);
  get isBoring => bounces >= boringBounceLimit;
}
class Interesting extends InterestState {}

class PlayingState extends PongState {
  final InterestState interest;
  PlayingState._c(int player, int enemy, this.interest)
      : super(player, enemy);

  PlayingState() : this._c(0, 0, Standard(0));

  PlayingState incrementPlayer() => PlayingState._c(player + 1, enemy, Standard(0));
  PlayingState incrementEnemy() => PlayingState._c(player, enemy + 1, Standard(0));
  EndedState end() => EndedState(player, enemy);
  PlayingState bounce() {
    final i = interest;
    if (i is Standard) {
      final bounces = i.bounces + 1;
      return i.isBoring
          ? PlayingState._c(player, enemy, Interesting())
          : PlayingState._c(player, enemy, Standard(bounces));
    }
    return this;
  }

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
      emit(PlayingState());
    });
    on<Bounced>((event, emit) {
      if (state is! PlayingState) return;
      emit((state as PlayingState).bounce());
    });
  }
}