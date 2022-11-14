part of "game.dart";

List<Wall> createBoundaries(Forge2DGame game) {
  final topLeft = Vector2.zero();
  final bottomRight = game.size;
  final topRight = Vector2(bottomRight.x, topLeft.y);
  final bottomLeft = Vector2(topLeft.x, bottomRight.y);

  return [
    GoalLine(topLeft, topRight, PlayerScored()),
    Wall(topRight, bottomRight),
    GoalLine(bottomRight, bottomLeft, EnemyScored()),
    Wall(bottomLeft, topLeft),
  ];
}

class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;

  Wall(this.start, this.end) {
    paint.color = Colors.white;
  }

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class GoalLine extends Wall with ContactCallbacks {
  final PongEvent event;
  GoalLine(Vector2 start, Vector2 end, this.event) : super(start, end);

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball) {
      other.reset = true;
      gameRef.buildContext!.read<PongBloc>().add(event);
    }
    super.beginContact(other, contact);
  }
}