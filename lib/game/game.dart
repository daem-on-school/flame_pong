library game;

import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_pong/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "walls.dart";
part "paddles.dart";
part "extras.dart";

class PongGame extends Forge2DGame with MultiTouchDragDetector {
  final ball = Ball();
  late final _player = PlayerPaddle(this);
  late final _enemy = EnemyPaddle(this);
  final _angledWalls = <AngledWall>[];

  PongGame() : super(gravity: Vector2.zero()) {
    camera.viewport =  FixedResolutionViewport(Vector2(100, 160));
    paused = true;
  }

  @override
  Future<void>? onLoad() {
    addAll(createBoundaries(this));
    add(ball);
    add(_player);
    add(_enemy);
    return super.onLoad();
  }

  void makeInteresting() {
    if (_angledWalls.isNotEmpty) { return; }
    _angledWalls.addAll([
      AngledWall(Vector2(0, 0), Vector2(0, 16), Vector2(2, 8)),
      AngledWall(Vector2(10, 0), Vector2(10, 16), Vector2(8, 8)),
    ]);
    addAll(_angledWalls);
  }

  void clearAngledWalls() {
    _angledWalls.forEach(remove);
    _angledWalls.clear();
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    _player.onDragUpdate(pointerId, info);
    super.onDragUpdate(pointerId, info);
  }
}

class Ball extends BodyComponent with ContactCallbacks {
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
  void endContact(Object other, Contact contact) {
    final velocity = body.linearVelocity;
    if (velocity.y.abs() < 3) {
      body.linearVelocity.y = 3;
    }
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
      bullet: true,
      fixedRotation: true
    );
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    if (body.linearVelocity.length > _maxSpeed) {
      body.linearVelocity.scaleTo(0.9);
    }
    if (body.position.x < 0 || body.position.x > gameRef.size.x) {
      reset = true;
    }
    if (reset) {
      _reset();
      reset = false;
    }
    super.update(dt);
  }
}
