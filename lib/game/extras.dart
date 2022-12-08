part of 'game.dart';

class AngledWall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;
  final Vector2 apex;

  AngledWall(this.start, this.end, this.apex) {
    paint.color = Colors.black38;
  }

  @override
  Body createBody() {
    final shape = PolygonShape();
    shape.set([start, end, apex]);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}