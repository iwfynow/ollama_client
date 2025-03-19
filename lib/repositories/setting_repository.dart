import 'package:ollama/services/neural_network_api.dart';
import 'package:ollama/services/setting_database.dart';

class SettingRepository {
  final NeuralNetworkApi neuralNetworkApi;
  final SettingDatabase settingDB;

  SettingRepository({required this.neuralNetworkApi, required this.settingDB});

  Future<List<String>> echoRequest(String url) async {
    return await neuralNetworkApi.fetchAvailableModels(url);
  }

  Future<Map<String, dynamic>> loadSettings() async {
    return settingDB.loadSettings();
  }

  Future<void> updateApiUrl(String url) async {
    await settingDB.updateApiUrl(url);
  }  
  
  Future<void> updatePrompt(String prompt) async {
    await settingDB.updatePrompt(prompt);
  }

  Future<void> switchResponseMethod(bool value) async {
    await settingDB.switchResponseMethod(value);
  }

  Future<void>  toggleUsePrompt(bool value) async {
    await settingDB.toggleUsePrompt(value);
  }

  Future<void> updateTheme(int index) async {
    await settingDB.updateTheme(index);
  }
}