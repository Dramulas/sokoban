// Hareket Stratejisi
import 'package:flame/components.dart';
import 'package:sokoban/components/player.dart';
import 'package:sokoban/utility/direction.dart';

abstract class MovementStrategy {
  void move(Player player, Direction direction);
}

class RegularMovement implements MovementStrategy {
  @override
  void move(Player player, Direction direction) {
    var punch = Sprite.load('wind.png');
  }
}

class SprintMovement implements MovementStrategy {
  @override
  void move(Player player, Direction direction) {
    var punch = Sprite.load('wind.png');
  }
}

// Yumruk Stratejisi
abstract class PunchStrategy {
  void punch(Player player, Direction direction);
}

class RegularPunch implements PunchStrategy {
  @override
  void punch(Player player, Direction direction) {
    var punch = Sprite.load('broke.png');
  }
}

class StrongPunch implements PunchStrategy {
  @override
  void punch(Player player, Direction direction) {
    var punch = Sprite.load('broke.png');
  }
}
