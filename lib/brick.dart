import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  final x;
  final y;
  final brickWidth;

  MyBrick({this.x, this.y, this.brickWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment((2*x + brickWidth)/(2-brickWidth), y),
        child: ClipRRect (
        borderRadius: BorderRadius.circular(0),
        child: Container(
          color: Colors.white,
        height: 20,
        width: MediaQuery.of(context).size.width * brickWidth / 2,
    ),
    ),
    );
  }
}