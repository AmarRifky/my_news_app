import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/state/app_state.dart';
import 'package:my_news_app/screens/notification_settings_screen.dart';
import 'package:my_news_app/screens/language_settings_screen.dart';
import 'package:my_news_app/screens/history_screen.dart'; // Import the HistoryScreen
import 'package:my_news_app/screens/my_articles_screen.dart'; // Import the MyArticlesScreen

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    bool _darkMode = appState.darkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: _darkMode,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
                appState.setDarkMode(_darkMode);
              });
            },
          ),
          ListTile(
            title: Text('Notification Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationSettingsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Language Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageSettingsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
          ListTile(
            title: Text('My Articles'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyArticlesScreen()),
              );
            },
          ),
          ListTile(
            title: Text('About'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'My News App',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 My News App',
              );
            },
          ),
        ],
      ),
    );
  }
}
