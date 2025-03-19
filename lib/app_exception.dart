import 'package:flutter/material.dart';

class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}


class NonModelSelected extends AppException{
  NonModelSelected(String message) : super(message);

  void showSnackBar(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, selectionColor: Colors.red,),
    duration: Duration(seconds: 3),));
  }
}

class ResponseException extends NonModelSelected {
  ResponseException(String message) : super(message);
}