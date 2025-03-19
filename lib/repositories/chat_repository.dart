import 'dart:convert';
import 'package:ollama/services/isar_database.dart';
import 'package:ollama/services/neural_network_api.dart';
import 'package:ollama/models/chat_model.dart';
import 'package:ollama/entities/chat_entity.dart';
import 'package:ollama/entities/message_entity.dart';

class ChatRepository {
  final IsarDataBase dataBaseService;
  final NeuralNetworkApi neuralApi;

  ChatRepository({
    required this.dataBaseService, required this.neuralApi,
  });

  Future<void> initDB() async {
    await dataBaseService.initDB();
  }

  Future<List<ChatEntity>> getAllChat() async {
    await initDB();
    final data = await dataBaseService.getAllChat();
    return data.map((el) => el.toEntity()).toList();
  }

  Stream<MessageEntity> sendMessage({
    required String baseUrl,
    required String message,
    required bool isStream,
    required String model,
  }) async* {
    if (isStream) {
      Stream<String> responseStream = neuralApi.queryStream(
        baseUrl: baseUrl,
        query: message,
        model: model,
      );

      final buffer = StringBuffer();
      await for (var chunk in responseStream) {
        buffer.write(chunk);
        yield MessageEntity(
          content: buffer.toString(),
          sender: "AI",
          timeStamp: DateTime.now(),
        );
      }
    } else {
      var response = await neuralApi.querySingle(
        baseUrl: baseUrl,
        query: message,
        model: model,
      );
      Map<String, dynamic> mapResponse = jsonDecode(response);

      yield MessageEntity(
        content: mapResponse['response'],
        sender: "AI",
        timeStamp: DateTime.now(),
      );
    }
  }

  Future<int> saveChat(ChatEntity chat) async {
    return await dataBaseService.saveChat(chat);
  }

  Future<void> deleteChat(ChatEntity chat) async {
    dataBaseService.deleteChat(chat.toChatModel());
  }
}