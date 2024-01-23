import 'package:sokoban/components/movement_strategy.dart';

class FeatureManager {
  MovementStrategy movementStrategy;
  PunchStrategy punchStrategy;

  FeatureManager()
      : movementStrategy = RegularMovement(),
        punchStrategy = RegularPunch();

  void applyFeature(Feature feature) {
    switch (feature) {
      case Feature.sprint:
        movementStrategy = SprintMovement();
        break;
      case Feature.strongPunch:
        punchStrategy = StrongPunch();
        break;
    }
  }

  void resetFeatures() {
    movementStrategy = RegularMovement();
    punchStrategy = RegularPunch();
  }
}

enum Feature {
  sprint,
  strongPunch,
}
