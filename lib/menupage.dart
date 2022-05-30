import 'dart:async';
import 'dart:math';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong_game/brick.dart';
import 'package:pong_game/ball.dart';
import 'package:pong_game/mainmenu.dart';
import 'package:pong_game/score.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

enum direction {UP, DOWN, LEFT, RIGHT}

class _MenuPageState extends State<MenuPage> {

  double playerBrickx = -0.2;
  double playerBrickWidth = 0.4;
  int playerScore = 0;

  double enemyBrickX = -0.2;
  int enemyScore = 0;

  bool gameStarted = false;

  double ballX = 0.0;
  double ballY = 0.0;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  //starts the ball movement
  void startGame() {
    gameStarted = true;
    Timer.periodic(Duration(milliseconds: 1), (timer) {
    updateDirection();

    moveBall();

    moveEnemy();

    if(playerDead()) {
      enemyScore++;
      timer.cancel();
      dialog(false);
    }
    if (enemyDead()) {
      playerScore++;
      timer.cancel();
      dialog(true);
    }

    });
  }

  bool enemyDead() {
    if (ballY <= -1) {
      return true;
    }
    return false;
  }

  void moveEnemy() {
    setState(() {
      enemyBrickX = ballX - 0.1;
    });
  }

  void dialog(bool enemyDied) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              enemyDied ? "Player Wins" : "Enemy Wins",
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: reset,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(7),
                color: Colors.white,
                child: Text(
                  "Play Again",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  //changes ball direction when it hits the bottom
  void updateDirection() {
    //vertical
    setState(() {
      if(ballY >= 0.9 && playerBrickx + playerBrickWidth >= ballX && playerBrickx <= ballX) {
        ballYDirection = direction.UP;
      } else if (ballY <= -0.9) {
        ballYDirection = direction.DOWN;
      }

      //horizontal
      if (ballX >= 1) {
        ballXDirection = direction.LEFT;
      } else if (ballX <= -1) {
        ballXDirection = direction.RIGHT;
      }
    });
  }

  void moveBall() {
    setState(() {
      //vertical
      if(ballYDirection == direction.DOWN) {
        ballY += 0.01;
      }else if (ballYDirection == direction.UP) {
        ballY -= 0.01;
      }

      //horizontal
      if(ballXDirection == direction.LEFT) {
        ballX -= 0.01;
      }else if (ballXDirection == direction.RIGHT) {
        ballX += 0.01;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!(playerBrickx - 0.1 <= -1)) {
        playerBrickx -= 0.2;
      }
    });
  }

  void moveRight() {
    setState(() {
      if(!(playerBrickx + playerBrickWidth >= 1)) {
        playerBrickx += 0.2;
      }
    });
  }

  bool playerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  void reset() {
    Navigator.pop(context);
    setState(() {
      gameStarted = false;
      ballX = 0;
      ballY = 0;
      playerBrickx = -0.2;
      enemyBrickX = -0.2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Stack(
              children: [
                //start button
                MainMenu(
                  gameStarted: gameStarted,
                ),

                Container(
                  alignment: Alignment(0, 0),
                  child: DottedLine( //custom dotted line using dotted line package
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 1.0,
                    dashLength: 7.0,
                    dashColor: Colors.white,
                    dashRadius: 0,
                    dashGapLength: 15.0,
                  ),
                ),
                Score(
                  enemyScore: enemyScore,
                  playerScore: playerScore,
                ),

                //enemy brick (top)
                MyBrick(x: enemyBrickX, y: -0.9, brickWidth: playerBrickWidth), //-1 is the top and 1 is the bottom of the screen

                //Your Brick (Bottom)
                MyBrick(x: playerBrickx, y: 0.9, brickWidth: playerBrickWidth),

                //the ball
                MyBall(x: ballX, y: ballY),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
