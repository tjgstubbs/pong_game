import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {

  final bool gameStarted;

  MainMenu({required this.gameStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0,-0.1), //raises it above the ball for clarity
      child: Text(gameStarted ? '' : "TOUCH TO START",
        style: TextStyle(color: Colors.white, fontSize: 30),),
    );
  }
}