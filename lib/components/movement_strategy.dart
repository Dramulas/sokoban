// Hareket Stratejisi
import 'package:sokoban/components/player.dart';
import 'package:sokoban/utility/direction.dart';

abstract class MovementStrategy {
  void move(Player player, Direction direction);
}

class RegularMovement implements MovementStrategy {
  @override
  void move(Player player, Direction direction) {}
}

class SprintMovement implements MovementStrategy {
  @override
  void move(Player player, Direction direction) {}
}

// Yumruk Stratejisi
abstract class PunchStrategy {
  void punch(Player player, Direction direction);
}

class RegularPunch implements PunchStrategy {
  @override
  void punch(Player player, Direction direction) {}
}

class StrongPunch implements PunchStrategy {
  @override
  void punch(Player player, Direction direction) {}
}
