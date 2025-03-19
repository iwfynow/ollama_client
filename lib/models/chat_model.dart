import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:isar/isar.dart';
import 'package:ollama/models/message_model.dart';
import 'package:ollama/entities/chat_entity.dart';

part 'chat_model.g.dart';

@collection
class ChatModel {
  Id id = Isar.autoIncrement;
  late String name;
  IsarLinks<MessageModel> chats = IsarLinks<MessageModel>();

  ChatModel({required this.id, required this.name});
}


extension ChatModelMapper on ChatModel{
  ChatEntity toEntity() {
  return ChatEntity(
    id: id,
    name: name,
    messages: chats.map((el) => el.toEntity()).toList().obs
  );
  }
}