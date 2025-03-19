import 'package:flutter/material.dart';
import 'package:ollama/app_exception.dart';

class MessageInputFields extends StatefulWidget {
  final Future<bool> Function(String message) onSend;

  const MessageInputFields({super.key, required this.onSend});

  @override
  State<MessageInputFields> createState() => _MessageInputFieldsState();
}

class _MessageInputFieldsState extends State<MessageInputFields> {
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _handleSend() async {
    final message = textController.text.trim();
    textController.clear();
    if (message.isNotEmpty) {
      try {
        bool isSuccess = await widget.onSend(message);
        if (isSuccess == false) {
          textController.text = message;
        }
      } catch (e) {
        if (e is NonModelSelected) {
          e.showSnackBar(context);
        }
        if (e is ResponseException) {
          e.showSnackBar(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: screenWidth * 0.14,
              child: SearchBar(
                hintText: "Message",
                controller: textController,
                elevation: const WidgetStatePropertyAll(0),
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _handleSend,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}