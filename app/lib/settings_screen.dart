// Darshan Nair and Raahul Nair
import 'package:flutter/material.dart';
import 'db_helper.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  bool _hydrationReminders = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // Load saved preferences when screen is opened
  }

  Future<void> _loadPreferences() async {
    final prefs = await DBHelper.instance.getPreferences();
    if (prefs != null) {
      setState(() {
        _notificationsEnabled = prefs['notification'] == 1;
        _hydrationReminders = prefs['hydration_reminder'] == 1;
      });
    }
  }

  void _savePreferences() {
    DBHelper.instance
        .updatePreferences(_notificationsEnabled, _hydrationReminders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _savePreferences(); // Save preferences when toggled
              },
            ),
            SwitchListTile(
              title: Text('Hydration Reminders'),
              value: _hydrationReminders,
              onChanged: (bool value) {
                setState(() {
                  _hydrationReminders = value;
                });
                _savePreferences();
              },
            ),
          ],
        ),
      ),
    );
  }
}
