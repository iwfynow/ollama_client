import 'package:isar/isar.dart';
import 'package:ollama/models/chat_model.dart';
import 'package:ollama/entities/message_entity.dart';
part 'message_model.g.dart';

@collection
class MessageModel {
  Id id = Isar.autoIncrement;
  String content;
  String sender;
  DateTime timeStamp;
  MessageModel({required this.content, required this.sender, required this.timeStamp});

  final chat = IsarLink<ChatModel>();
}

extension MessageModelMapper on MessageModel{
  MessageEntity toEntity(){
    return MessageEntity(
      content: content,
      sender: sender,
      timeStamp: timeStamp
    );
  }
}