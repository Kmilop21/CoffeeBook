import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _receiveNotifications = false; // State for receiving notifications
  bool _collectData = false; // State for collecting data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('Recibir notificaciones'),
              value: _receiveNotifications,
              onChanged: (bool? value) {
                setState(() {
                  _receiveNotifications = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Recopilar datos'),
              value: _collectData,
              onChanged: (bool? value) {
                setState(() {
                  _collectData = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
