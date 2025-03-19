import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:ollama/controllers/chat_controller.dart';
import 'package:ollama/entities/chat_entity.dart';
import 'package:ollama/theme/app_theme.dart';

class DismissibleChat extends StatefulWidget {
  final Function onTap;
  final ChatEntity chat;

  const DismissibleChat({super.key, required this.onTap, required this.chat});

  @override
  DismissibleChatState createState() => DismissibleChatState();
}

class DismissibleChatState extends State<DismissibleChat> {
  late Color color;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    color = context.customUnselectedColor;
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    return Dismissible(
      key: ValueKey(widget.chat.name),
      onUpdate: (details) {
        setState(() {
          double progress =
              details.progress;
          if (progress == 0.0) {
            color = context.customUnselectedColor;
          } else {
            color =
                Color.lerp(
                  context.customLongPressColor,
                  context.customUnselectedColor,
                  progress,
                )!;
          }
        });
      },
      onDismissed: (direction){
        if (direction == DismissDirection.startToEnd ||
            direction == DismissDirection.endToStart) {
          Get.find<ChatController>().deleteChat(widget.chat);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 50),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => widget.onTap(),
            onLongPress: () async {
              setState(() {
                color = context.customLongPressColor;
              });
              await showModalBottomSheet(
                context: context,
                isScrollControlled: false,
                builder:
                    (context) => EditChatBottomSheet(
                      chat: widget.chat,
                      onUpdate: (renameChat) async {
                        await chatController.renameChat(renameChat);
                      }
                    ),
              );

              setState(() {
                color = context.customUnselectedColor;
              });
            },
            onLongPressUp: () {
              setState(() {
                color = context.customUnselectedColor;
              });
            },
            child: ListTile(
              tileColor: Colors.transparent,
              title: Text(widget.chat.name),
            ),
          ),
        ),
      ),
    );
  }
}

class EditChatBottomSheet extends StatefulWidget {
  final ChatEntity chat;
  final Function(ChatEntity) onUpdate;

  const EditChatBottomSheet({
    super.key,
    required this.chat,
    required this.onUpdate,
  });

  @override
  _EditChatBottomSheetState createState() => _EditChatBottomSheetState();
}

class _EditChatBottomSheetState extends State<EditChatBottomSheet> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.chat.name);
    _focusNode = FocusNode();

    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 20),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              suffix: IconButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    final updatedChat = ChatEntity(
                      id: widget.chat.id,
                      name: _controller.text,
                      messages: widget.chat.messages,
                    );
                    widget.onUpdate(updatedChat);
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.message),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
