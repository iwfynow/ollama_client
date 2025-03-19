import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:ollama/app_exception.dart';
import 'package:ollama/controllers/setting_controller.dart';
import 'package:ollama/entities/chat_entity.dart';
import 'package:ollama/entities/message_entity.dart';
import 'package:ollama/repositories/chat_repository.dart';

class ChatController extends GetxController {
  final RxList<ChatEntity> chatList = <ChatEntity>[].obs;
  Rxn<ChatEntity> currentChat = Rxn<ChatEntity>();
  Rx<bool> isBotTyping = false.obs;

  final settingController = Get.find<SettingController>();
  final chatRepository = Get.find<ChatRepository>();

  @override
  void onInit() {
    super.onInit();
    loading();
  }

  Future<void> loading() async {
    chatList.value = await chatRepository.getAllChat();
  }

  Future<void> sendMessage(String content) async {
    if (settingController.selectedModel.value.isEmpty) {
      throw NonModelSelected("Non selected model");
    }

    if (currentChat.value == null) {
      currentChat.value = ChatEntity(
        id: Isar.autoIncrement,
        name: content,
        messages:
            [
              MessageEntity(
                content: content,
                sender: "I",
                timeStamp: DateTime.now(),
              ),
            ].obs,
      );
      int savedId = await saveChat(currentChat.value!);
      currentChat.value!.id = savedId;
      chatList.insert(0, currentChat.value!);
    } else {
      currentChat.value!.messages.add(
        MessageEntity(content: content, sender: "I", timeStamp: DateTime.now()),
      );
    }

    if (settingController.isPromptEnabled.value) {
      content = settingController.prompt.value + content;
    }

    isBotTyping.value = true;
    try {
      if (settingController.isStreamMode.value) {
        var response = chatRepository.sendMessage(
          message: content,
          baseUrl: settingController.apiUrl.value,
          isStream: true,
          model: settingController.selectedModel.value,
        );

        currentChat.value!.messages.add(
          MessageEntity(content: "", sender: "AI", timeStamp: DateTime.now()),
        );

        await for (var chunk in response) {
          int lastIndex = currentChat.value!.messages.length - 1;
          currentChat.value!.messages[lastIndex] = chunk;
          currentChat.refresh();
        }
      } else {
        var response = chatRepository.sendMessage(
          message: content,
          baseUrl: settingController.apiUrl.value,
          isStream: false,
          model: settingController.selectedModel.value,
        );

        var message = await response.first;
        currentChat.value!.messages.add(message);
        currentChat.refresh();
      }
      await saveChat(currentChat.value!);
    } catch (e) {
      if (e is ResponseException) {
        rethrow;
      }
    }

    isBotTyping.value = false;
  }

  void loadChat(int? id) {
    if (id == null) {
      currentChat.value = null;
    } else {
      currentChat.value = chatList.firstWhere((chat) => chat.id == id);
    }
  }

  void deleteChat(ChatEntity chat) async {
    if (currentChat.value?.id == chat.id) {
      currentChat.value = null;
    }
    chatList.removeWhere((element) => element.id == chat.id);
    chatList.refresh();
    await chatRepository.deleteChat(chat);
  }

  Future<int> saveChat(ChatEntity chat) async {
    int savedId = await chatRepository.saveChat(chat);
    return savedId;
  }

  Future<void> renameChat(ChatEntity chat) async {
    for (int i = 0; i < chatList.length; i++) {
      if (chatList[i].id == chat.id) {
        chatList[i].name = chat.name;
        await saveChat(chat);
        break;
      }
    }
    update();
  }
}