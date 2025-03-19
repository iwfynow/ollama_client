import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollama/controllers/setting_controller.dart';
import 'package:ollama/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingController settingController = Get.put(SettingController());

  late final TextEditingController apiUrlController;
  late final TextEditingController promptController;

  @override
  void initState() {
    super.initState();
    apiUrlController = TextEditingController(
      text: settingController.apiUrl.value,
    );
    promptController = TextEditingController(
      text: settingController.prompt.value,
    );

    settingController.echoRequest();
  }

  @override
  void dispose() {
    apiUrlController.dispose();
    promptController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onSave,
    int? maxLength,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: context.customUnselectedColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.save),
            onPressed: onSave,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleLabel(String text) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (apiUrlController.text != settingController.apiUrl.value) {
                apiUrlController.text = settingController.apiUrl.value;
                apiUrlController.selection = TextSelection.fromPosition(
                  TextPosition(offset: apiUrlController.text.length),
                );
              }
              return _buildTextField(
                label: "API Address",
                controller: apiUrlController,
                onSave: () async {
                  await settingController.updateApiUrl(apiUrlController.text);
                  await settingController.echoRequest();
                },
              );
            }),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(
                      settingController.isHostValid.value
                          ? Icons.check_circle
                          : Icons.error,
                      color:
                          settingController.isHostValid.value
                            ? Colors.green
                            : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      settingController.isHostValid.value
                          ? "Valid Host"
                          : "Invalid Host",
                      style: TextStyle(
                        color:
                            settingController.isHostValid.value
                              ? Colors.green
                              : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                )),
            const Divider(thickness: 1.2),
            Obx(() {
              if (promptController.text != settingController.prompt.value) {
                promptController.text = settingController.prompt.value;
                promptController.selection = TextSelection.fromPosition(
                  TextPosition(offset: promptController.text.length),
                );
              }
              return _buildTextField(
                label: "Prompt",
                controller: promptController,
                maxLength: 200,
                maxLines: 2,
                onSave: () async {
                  await settingController.updatePrompt(promptController.text);
                },
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Use Prompt", style: TextStyle(fontSize: 16)),
                  Obx(
                    () => Switch(
                      value: settingController.isPromptEnabled.value,
                      onChanged: settingController.toggleUsePrompt,
                    ),
                  ),
                ],
              ),
            ),
            _buildToggleLabel("Response Mode"),
            Obx(() {
              int selectedIndex = settingController.responseModeToggle
                  .indexWhere((e) => e == true);
              return Center(
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(12),
                  constraints: BoxConstraints(
                    minWidth: screenWidth * 0.4,
                    minHeight: screenHeight * 0.07,
                  ),
                  isSelected: List.generate(2, (i) => i == selectedIndex),
                  onPressed:
                      (index) =>
                          settingController.switchResponseMethod(index == 0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.stream),
                        SizedBox(width: 6),
                        Text("Stream"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.http),
                        SizedBox(width: 6),
                        Text("Request"),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
            _buildToggleLabel("Theme"),
            Obx(() {
              int selectedIndex = settingController.themeModes.indexOf(
                settingController.currentTheme.value,
              );
              return Center(
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(12),
                  constraints: BoxConstraints(
                    minWidth: screenWidth * 0.27,
                    minHeight: screenHeight * 0.07,
                  ),
                  isSelected: List.generate(3, (i) => i == selectedIndex),
                  onPressed: settingController.updateTheme,
                  children: const [Text("Light"), Text("System"), Text("Dark")],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}