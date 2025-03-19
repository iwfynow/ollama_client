

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ollama/models/chat_model.dart';
import 'package:ollama/models/message_model.dart';
import 'package:ollama/entities/message_entity.dart';

class ChatEntity {
  int id;
  String name;
  RxList<MessageEntity> messages;

  ChatEntity({
    required this.id,
    required this.name,
    required this.messages
  });

  ChatEntity copyWith({String? name}) {
    return ChatEntity(id: id, name: name ?? this.name, messages: messages);
  }
}

extension ChatEntityModel on ChatEntity{
  ChatModel toChatModel(){
    final chatModel = ChatModel(
      id: id,
      name: name,
    );
    chatModel.chats.addAll(messages.map((el) => MessageModel(
      content: el.content,
      sender: el.sender,
      timeStamp: el.timeStamp
    )));

    return chatModel;
  }
}