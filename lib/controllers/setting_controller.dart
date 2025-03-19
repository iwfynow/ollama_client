import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollama/repositories/setting_repository.dart';

class SettingController extends GetxController {
  final SettingRepository settingRepo = Get.find<SettingRepository>();

  final List<ThemeMode> themeModes = [ThemeMode.light, ThemeMode.system, ThemeMode.dark];

  Rx<String> apiUrl = ''.obs;
  Rx<String> prompt = ''.obs;
  Rx<ThemeMode> currentTheme = ThemeMode.system.obs;

  RxList<bool> responseModeToggle = [false, true].obs;
  Rx<bool> isStreamMode = true.obs;

  Rx<bool> isHostValid = false.obs;
  Rx<bool> isPromptEnabled = true.obs;

  Rx<String> selectedModel = Rx<String>("");
  List<String> availableModels = [];

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final settings = await settingRepo.loadSettings();

    apiUrl.value = settings['apiUrl'];
    prompt.value = settings['prompt'];
    isPromptEnabled.value = settings['usePrompt'];

    currentTheme.value = ThemeMode.values[settings['themeIndex']];
    isStreamMode.value = settings['useStream'];
    responseModeToggle.value =
        isStreamMode.value ? [true, false] : [false, true];
    echoRequest();
  }

  Future<void> updateApiUrl(String url) async {
    await settingRepo.updateApiUrl(url);
    apiUrl.value = url;
  }

  Future<void> updatePrompt(String newPrompt) async {
    await settingRepo.updatePrompt(newPrompt);
    prompt.value = newPrompt;
  }

  Future<void> switchResponseMethod(bool useStream) async {
    isStreamMode.value = useStream;
    responseModeToggle.value = useStream ? [true, false] : [false, true];
    await settingRepo.switchResponseMethod(useStream);
  }

  Future<void> toggleUsePrompt(bool isEnabled) async {
    isPromptEnabled.value = isEnabled;
    await settingRepo.toggleUsePrompt(isEnabled);
  }

  Future<void> updateTheme(int index) async {
    await settingRepo.updateTheme(index);
    currentTheme.value = themeModes[index];
  }

  Future<void> echoRequest() async {
    final modelList = await settingRepo.echoRequest(apiUrl.value);
    if (modelList.isEmpty) {
      isHostValid.value = false;
    } else {
      availableModels = modelList;
      isHostValid.value = true;
    }
  }
}