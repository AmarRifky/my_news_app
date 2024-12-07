import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _breakingNews = true;
  bool _dailySummary = false;
  bool _categorySpecific = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Breaking News Alerts'),
            value: _breakingNews,
            onChanged: (bool value) {
              setState(() {
                _breakingNews = value;
                // Implement breaking news alerts logic here
              });
            },
          ),
          SwitchListTile(
            title: Text('Daily Summary'),
            value: _dailySummary,
            onChanged: (bool value) {
              setState(() {
                _dailySummary = value;
                // Implement daily summary logic here
              });
            },
          ),
          SwitchListTile(
            title: Text('Category-Specific Notifications'),
            value: _categorySpecific,
            onChanged: (bool value) {
              setState(() {
                _categorySpecific = value;
                // Implement category-specific notifications logic here
              });
            },
          ),
        ],
      ),
    );
  }
}
