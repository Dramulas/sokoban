class UserSettings {
  static final UserSettings _instance = UserSettings._internal();

  ControlScheme controlScheme = ControlScheme.wasd;

  factory UserSettings() {
    return _instance;
  }

  UserSettings._internal();

  void setControlScheme(ControlScheme scheme) {
    controlScheme = scheme;
  }
}

enum ControlScheme { wasd, arrowKeys }
