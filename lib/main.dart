import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ollama/controllers/chat_controller.dart';
import 'package:ollama/controllers/setting_controller.dart';
import 'package:ollama/repositories/chat_repository.dart';
import 'package:ollama/repositories/setting_repository.dart';
import 'package:ollama/services/isar_database.dart';
import 'package:ollama/services/neural_network_api.dart';
import 'package:ollama/services/setting_database.dart';
import 'package:ollama/theme/app_theme.dart';
import 'package:ollama/views/home_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeDependencies();
  runApp(const OllamaApp());
}

Future<void> _initializeDependencies() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  final settingDB = SettingDatabase(prefs: sharedPrefs);
  final apiService = NeuralNetworkApi();
  final isarDB = IsarDataBase();

  Get.put(settingDB);
  Get.put(apiService);
  Get.put(isarDB);

  final settingRepo = SettingRepository(
    neuralNetworkApi: apiService,
    settingDB: settingDB,
  );
  final chatRepo = ChatRepository(
    dataBaseService: isarDB,
    neuralApi: apiService,
  );

  Get.put(settingRepo);
  Get.put(chatRepo);

  Get.put(SettingController());
  Get.put(ChatController(), permanent: true);
}

class OllamaApp extends StatelessWidget {
  const OllamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = Get.find<SettingController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ollama Chat',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: settingController.currentTheme.value,
        home: HomePage(),
      ),
    );
  }
}
