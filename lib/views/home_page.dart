import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ollama/app_exception.dart';
import 'package:ollama/controllers/chat_controller.dart';
import 'package:ollama/controllers/setting_controller.dart';
import 'package:ollama/entities/message_entity.dart';
import 'package:ollama/theme/app_theme.dart';
import 'package:ollama/views/message_input_fields.dart';
import 'package:ollama/views/widgets/model_selector_widget.dart';
import 'package:ollama/views/widgets/dismissible_chat.dart';
import 'package:ollama/views/settings_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ScrollController _scrollController = ScrollController();

  final ChatController _chatController = Get.find<ChatController>();
  final SettingController _settingController = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: _buildModelSelector(context),
      ),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () =>
                  _chatController.isBotTyping.value
                      ? const LinearProgressIndicator(
                        backgroundColor: Colors.black,
                        color: Colors.white,
                      )
                      : const SizedBox.shrink(),
            ),
            Expanded(
              child: Obx(() {
                final chat = _chatController.currentChat.value;
                final List<MessageEntity> messages = chat?.messages ?? [];
                return MessageList(
                  messages: messages,
                  scrollController: _scrollController,
                );
              }),
            ),
            MessageInputFields(
              onSend: (message) async {
                try {
                  await _chatController.sendMessage(message);
                  _scrollToBottom();
                  return true;
                } catch (e) {
                  if (e is NonModelSelected) {
                    e.showSnackBar(context);
                  }
                  if (e is ResponseException) {
                    rethrow;
                  }
                }
                return false;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelSelector(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await _settingController.echoRequest();
          showModalBottomSheet(
            context: context,
            builder: (_) => ModelSelector(),
          );
        } catch (e) {
          if (e is NonModelSelected) {
            e.showSnackBar(context);
          }
          rethrow;
        }
      },
      child: Obx(() {
        final modelName = _settingController.selectedModel.value;
        final displayText = modelName.isEmpty ? "<select model>" : modelName;
        return Text(displayText, style: context.customMessageTextStyle);
      }),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: Get.width * 0.75,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          const ListTile(leading: Icon(Icons.auto_mode), title: Text("Ollama")),
          _buildDrawerItem("New Chat", _handleNewChat),
          _buildDrawerItem("Settings", () {
            Get.to(() => const SettingsPage());
          }),
          const Divider(),
          Expanded(
            child: GetBuilder<ChatController>(
              builder: (controller) {
                if (controller.chatList.isEmpty) return const SizedBox();
                return ListView.builder(
                  itemCount: controller.chatList.length,
                  itemBuilder: (context, index) {
                    final chat = controller.chatList[index];
                    return DismissibleChat(
                      chat: chat,
                      onTap: () {
                        _chatController.loadChat(chat.id);
                        Get.back();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, VoidCallback onTap) {
    return ListTile(title: Text(title), onTap: onTap);
  }

  void _handleNewChat() {
    _chatController.loadChat(null);
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.back();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class MessageList extends StatelessWidget {
  final List<MessageEntity> messages;
  final ScrollController scrollController;

  const MessageList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isSender = message.sender == "I";

        return Row(
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: context.customMessage,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      style: context.customMessageTextStyle,
                      softWrap: true,
                    ),
                    Text(
                      DateFormat.jm().format(message.timeStamp),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}