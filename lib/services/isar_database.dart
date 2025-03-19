import 'dart:io';
import 'package:isar/isar.dart';
import 'package:ollama/entities/chat_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ollama/models/chat_model.dart';
import 'package:ollama/models/message_model.dart';

class IsarDataBase {
  static late Isar isar;

  Future<void> initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      ChatModelSchema,
      MessageModelSchema,
    ], directory: dir.path);
  }

  Future<List<ChatModel>> getAllChat() async {
    return await isar.chatModels.where().findAll();
  }

  Future<int> saveChat(ChatEntity chat) async {
    int savedChatId = 0;

    await isar.writeTxn(() async {
      var chatModel = await isar.chatModels.get(chat.id);

      if (chatModel == null) {
        chatModel = ChatModel(id: chat.id, name: chat.name);
        savedChatId = await isar.chatModels.put(chatModel);
      } else {
        chatModel.name = chat.name;
        await isar.chatModels.put(chatModel);
        savedChatId = chatModel.id;
      }

      final List<MessageModel> messageModels = [];

      for (var message in chat.messages) {
        final existingMessage =
            await isar.messageModels
                .filter()
                .contentEqualTo(message.content)
                .senderEqualTo(message.sender)
                .timeStampEqualTo(message.timeStamp)
                .findFirst();

        if (existingMessage != null) {
          messageModels.add(existingMessage);
        } else {
          final newMessage = MessageModel(
            content: message.content,
            sender: message.sender,
            timeStamp: message.timeStamp,
          );
          newMessage.id = await isar.messageModels.put(newMessage);
          messageModels.add(newMessage);
        }
      }

      chatModel.chats.clear();
      chatModel.chats.addAll(messageModels);
      await chatModel.chats.save();
    });

    return savedChatId;
  }

  Future<void> deleteChat(ChatModel chat) async {
    await isar.writeTxn(() async {
      await isar.chatModels.delete(chat.id);
    });
  }
}