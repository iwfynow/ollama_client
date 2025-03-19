import 'package:shared_preferences/shared_preferences.dart';

class SettingDatabase {
  final SharedPreferences prefs;
  SettingDatabase({required this.prefs});

  Future<void> updateApiUrl(String url) async => await prefs.setString('apiUrl', url);
  
  Future<void> updatePrompt(String prompt) async => await prefs.setString('prompt', prompt);

  Future<void> switchResponseMethod(bool value) async => await prefs.setBool('useStream', value);
  
  Future<void> toggleUsePrompt(bool value) async =>
      await prefs.setBool('usePrompt', value);

  Future<void> updateTheme(int index) async => await prefs.setInt('themeIndex', index);

  Future<Map<String, dynamic>> loadSettings() async {
    return {
      'apiUrl': prefs.getString('apiUrl') ?? 'http://localhost:11434/',
      'prompt': prefs.getString('prompt') ?? '',
      'useStream': prefs.getBool('useStream') ?? false,
      'themeIndex': prefs.getInt('themeIndex') ?? 1,
      'usePrompt': prefs.getBool('usePrompt') ?? true
    };
  }
}