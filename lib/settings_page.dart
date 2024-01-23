import 'package:flutter/material.dart';
import 'package:sokoban/components/user_settings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isWASDSelected = UserSettings().controlScheme == ControlScheme.wasd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Direction Keys', style: TextStyle(fontSize: 20)),
            Switch(
              value: _isWASDSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _isWASDSelected = newValue;
                  UserSettings().setControlScheme(
                      newValue ? ControlScheme.wasd : ControlScheme.arrowKeys);
                });
              },
            ),
            const Text('WASD', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
