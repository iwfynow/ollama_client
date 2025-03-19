import 'package:ollama/models/message_model.dart';

class MessageEntity {
  String content;
  String sender;
  DateTime timeStamp;
  MessageEntity({required this.content, required this.sender, required this.timeStamp});

  MessageEntity copyWith({
    String? content,
    String? sender,
    DateTime? timeStamp,
  }) {
    return MessageEntity(
      content: content ?? this.content,
      sender: sender ?? this.content,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }
}

extension MessageEntityMapper on MessageEntity{
  MessageModel toMessageModel(){
    return MessageModel(
      content: content,
      sender: sender,
      timeStamp: timeStamp
    );
  }
}