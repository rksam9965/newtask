import 'package:flutter/material.dart';

class HomeMenuButton extends StatefulWidget {
  final Function menuButtonClicked;
  const HomeMenuButton({Key? key, required this.menuButtonClicked})
      : super(key: key);

  @override
  HomeMenuButtonState createState() => HomeMenuButtonState();
}

class HomeMenuButtonState extends State<HomeMenuButton> {
  @override
  Widget build(BuildContext context) {
    return
    TextButton(
      onPressed: () => widget.menuButtonClicked(),
      child: const Icon(
        Icons.menu,
        color: Colors.black,
        size: 45.0,
      ),
    );
  }
}
