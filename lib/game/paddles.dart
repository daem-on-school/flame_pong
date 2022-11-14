part of "game.dart";

const paddleWidth = .6;
const paddleHeight = .15;

abstract class Paddle extends BodyComponent {
  final BodyType _bodyType;
  final double _yPos;

  Paddle(this._bodyType, this._yPos) : super();

  @override
  void renderPolygon(Canvas canvas, List<Offset> points) {
    final paint = Paint()..color = Colors.black;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(
      points[0].dx,
      points[0].dy,
      points[2].dx,
      points[2].dy,
    ), const Radius.circular(0.1)), paint);
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(paddleWidth, paddleHeight);
    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..restitution = 1.0;
    final bodyDef = BodyDef(userData: this, type: _bodyType)
      ..position = Vector2(5.0, _yPos);
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef);
  }
}

class PlayerPaddle extends Paddle {
  PlayerPaddle(PongGame game) : super(BodyType.static, game.size.y - 1);

  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    final position = info.eventPosition.game.x;
    body.setTransform(Vector2(position, _yPos), 0.0);
  }

}

class EnemyPaddle extends Paddle {
  static const _speed = 8.0;
  PongGame game;

  EnemyPaddle(this.game) : super(BodyType.kinematic, 1.0);

  @override
  void update(double dt) {
    final ballPos = game.ball.body.position.x;
    final enemyPos = body.position.x;
    final direction = ballPos - enemyPos;
    var velocity = direction.sign * _speed;
    if (direction.abs() < 0.5) {
      velocity = 0;
    } else if (direction.abs() < 1.5) {
      velocity *= 0.6;
    }

    if (enemyPos <= paddleWidth && velocity < 0) {
      velocity = 0;
    } else if (enemyPos >= game.size.x - paddleWidth && velocity > 0) {
      velocity = 0;
    }

    body.linearVelocity = Vector2(velocity, 0);
    super.update(dt);
  }
}