import 'package:flutter/material.dart';
import 'package:ollama/theme/app_theme.dart';

class ChatTile extends StatefulWidget {
  final Function onTap;
  final String textTitle;

  const ChatTile({super.key, required this.onTap, required this.textTitle});

  @override
  State<ChatTile> createState() => ChatTileState();
}

class ChatTileState extends State<ChatTile> {
  late Color color;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    color = context.customUnselectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Material(
          color: color,
          child: GestureDetector(
            onTap: () => widget.onTap(),
            onLongPress: () { 
              setState(() {
                color = context.customLongPressColor;
              });   
            },
            onLongPressUp: () {
              setState(() {
                color = context.customUnselectedColor;
              });
            },
            child: ListTile(
              tileColor: color,
              title: Text(widget.textTitle),
            ),
          ),
        ),
      ),
    );
  }
}
