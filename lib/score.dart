import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  final enemyScore;
  final playerScore;

  Score({this.enemyScore, this.playerScore});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            alignment: Alignment(-0.9, -0.5),
            child: Text(enemyScore.toString(), style: TextStyle(fontSize: 25, color: Colors.white),)
        ),
        Container(
            alignment: Alignment(-0.9, 0.5),
            child: Text(playerScore.toString(), style: TextStyle(fontSize: 25, color: Colors.white),)
        ),
      ],
    );
  }
}
