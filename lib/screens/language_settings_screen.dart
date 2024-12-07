import 'package:flutter/material.dart';

class LanguageSettingsScreen extends StatefulWidget {
  @override
  _LanguageSettingsScreenState createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Tamil', 'Sinhala', 'Hindi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Select Language'),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                  // Implement language change logic here
                });
              },
              items: _languages.map<DropdownMenuItem<String>>((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
