import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ollama/app_exception.dart';

class NeuralNetworkApi {
  List<String> availableModels = [];
  String generatePath = "/api/generate";
  String modelsPath = "/api/tags";

  NeuralNetworkApi();


  Future<String> querySingle({
    required String baseUrl,
    required String query,
    required String model,
  }) async {
    final requestUrl = _formatUrl(baseUrl, generatePath);
    final Map<String, dynamic> requestBody = {
      "model": model,
      "prompt": query,
      "stream": false
    };
    try {
      final response = await http.post(
        Uri.parse(requestUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ResponseException("Connection Refused");
      }
    } catch (e) {
      throw ResponseException("Connection Refused");
    }
  }

  Stream<String> queryStream({
    required String baseUrl,
    required String query,
    required String model,
  }) async* {
    final requestUrl = _formatUrl(baseUrl, generatePath);
    final Map<String, dynamic> requestBody = {
      "model": model,
      "prompt": query,
      "stream": true,
    };
    try {
      final request =
          http.Request("POST", Uri.parse(requestUrl))
            ..headers["Content-Type"] = "application/json"
            ..body = jsonEncode(requestBody);
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        await for (var chunk in streamedResponse.stream.transform(
          utf8.decoder,
        )) {
          for (var line in chunk.split("\n")) {
            if (line.trim().isNotEmpty) {
              try {
                var jsonData = jsonDecode(line);
                String character = jsonData["response"];
                yield character;
              } catch (e) {
              }
            }
          }
        }
      } else {
        throw ResponseException("Connection Refused");
      }
    } catch (e) {
      throw ResponseException("Connection Refused");
    }
  }


  Future<List<String>> fetchAvailableModels(String baseUrl) async {
    final requestUrl = _formatUrl(baseUrl, modelsPath);
    try{
      final response = await http.get(Uri.parse(requestUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        for (var value in responseJson.values) {
          for (var item in value) {
            availableModels.add(item['model']);
          }
        }
      } else{
        throw NonModelSelected("Not found");
      }
    } catch(e){
      throw NonModelSelected("Not found");
    }
    Future.delayed(Duration(seconds: 1), (){
      availableModels.clear();
    });
    return availableModels;
  }


  String _formatUrl(String baseUrl, String path) {
    if(baseUrl.endsWith('/')){
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    return baseUrl+path;
  }

}