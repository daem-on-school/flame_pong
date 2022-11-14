library game;

import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_pong/bloc/score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "walls.dart";
part "paddles.dart";

class PongGame extends Forge2DGame with MultiTouchDragDetector {
  final ball = Ball();
  late final _player = PlayerPaddle(this);
  late final _enemy = EnemyPaddle(this);

  PongGame() : super(gravity: Vector2.zero()) {
    camera.viewport =  FixedResolutionViewport(Vector2(100, 160));
  }

  @override
  Future<void>? onLoad() {
    addAll(createBoundaries(this));
    add(ball);
    add(_player);
    add(_enemy);
    return super.onLoad();
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    _player.onDragUpdate(pointerId, info);
    super.onDragUpdate(pointerId, info);
  }
}

class Ball extends BodyComponent {
  static const _startingVelocity = 8.0;
  static const _maxSpeed = 20;
  final _random = Random();

  bool reset = true;

  _reset() {
    body.setTransform(gameRef.size / 2, 0);
    final vector = Vector2(_startingVelocity, 0)
      ..rotate(_random.nextDouble() * 2 * pi);
    body.linearVelocity = vector;
  }

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 0.15;
    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..restitution = 1.0;
    final bodyDef = BodyDef(
        userData: this,
        type: BodyType.dynamic,
        position: gameRef.size / 2,
        bullet: true);
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    if (body.linearVelocity.length > _maxSpeed) {
      body.linearVelocity.scaleTo(0.9);
    }if (reset) {
      _reset();
      reset = false;
    }
    super.update(dt);
  }
}
