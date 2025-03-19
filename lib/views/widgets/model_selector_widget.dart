import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollama/controllers/setting_controller.dart';
import 'package:ollama/theme/app_theme.dart';

class ModelSelector extends StatelessWidget {
  const ModelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = Get.find<SettingController>();
    final models = settingController.availableModels;
    final selectedModel = settingController.selectedModel.value;

    final bool hasModels = models.isNotEmpty;
    final Color borderColor = hasModels
        ? context.showBottomColorChoosen
        : context.showBottomColorUnchoosen;
    final Color backgroundColor = hasModels
        ? context.showBottomColorUnchoosen
        : context.showBottomColorChoosen;

    return Container(
      color: context.showBottomColorChoosen,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: models.map((modelName) {
                final bool isSelected = modelName == selectedModel;

                return IntrinsicWidth(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      side: BorderSide(
                        color: isSelected ? borderColor : backgroundColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor:
                          isSelected ? borderColor : backgroundColor,
                    ),
                    onPressed: () {
                      settingController.selectedModel.value = modelName;
                      Navigator.pop(context);
                    },
                    child: Text(
                      modelName,
                      style: TextStyle(
                        color: isSelected ? backgroundColor : borderColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}