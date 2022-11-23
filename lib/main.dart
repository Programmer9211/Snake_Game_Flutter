import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int foodPosition = 200;
  SnakeDirection snakeDirection = SnakeDirection.Down;
  int score = 0;
  bool isGameRunning = false;
  late Timer timer;
  bool _isGameOver = false;

  List<int> snakePosition = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiseSnake();
    // startGame();
  }

  void initialiseSnake() {
    for (var i = 0; i < 3; i++) {
      snakePosition.add(i);
    }
  }

  void startGame() {
    isGameRunning = true;
    timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      moveSnake();

      isGameOver();
    });
  }

  void moveSnake() {
    if (snakeDirection == SnakeDirection.Right) {
      if (snakePosition.last % 15 == 14) {
        snakePosition.add(snakePosition.last + 1 - 15);
      } else {
        snakePosition.add(snakePosition.last + 1);
      }
    } else if (snakeDirection == SnakeDirection.Left) {
      if (snakePosition.last % 15 == 0) {
        snakePosition.add(snakePosition.last - 1 + 15);
      } else {
        snakePosition.add(snakePosition.last - 1);
      }
    } else if (snakeDirection == SnakeDirection.Up) {
      if (snakePosition.last < 15) {
        snakePosition.add(snakePosition.last - 15 + 330);
      } else {
        snakePosition.add(snakePosition.last - 15);
      }
    } else if (snakeDirection == SnakeDirection.Down) {
      if (snakePosition.last > 314) {
        snakePosition.add(snakePosition.last + 15 - 330);
      } else {
        snakePosition.add(snakePosition.last + 15);
      }
    }

    if (snakePosition.last == foodPosition) {
      onEatFood();
    } else {
      snakePosition.removeAt(0);
    }

    setState(() {});
  }

  void onEatFood() {
    score++;
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(329);
    }
  }

  void isGameOver() {
    List<int> duplicateSnakePosition = [];

    duplicateSnakePosition.addAll(snakePosition);

    duplicateSnakePosition.remove(snakePosition.last);

    if (duplicateSnakePosition.contains(snakePosition.last)) {
      print("Game Over");
      timer.cancel();
      _isGameOver = true;
      setState(() {});
    }
  }

  void restartGame() {
    _isGameOver = false;

    score = 0;

    snakePosition = [];

    initialiseSnake();

    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (dragUpdateDetais) {
        if (dragUpdateDetais.delta.dy > 0) {
          print("Downward");
          snakeDirection = SnakeDirection.Down;
        } else {
          print("Upward");
          snakeDirection = SnakeDirection.Up;
        }

        setState(() {});
      },
      onHorizontalDragUpdate: (drageUpdateDetails) {
        if (drageUpdateDetails.delta.dx > 0) {
          print("Right");
          snakeDirection = SnakeDirection.Right;
        } else {
          print("Left");
          snakeDirection = SnakeDirection.Left;
        }

        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
                child: GridView.builder(
              itemCount: 330,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 15,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                if (index == foodPosition) {
                  return Food();
                } else if (snakePosition.contains(index)) {
                  return Snake();
                } else {
                  return Box(
                    index: index,
                  );
                }
              },
            )),
            Text(
              "Score: $score",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            isGameRunning
                ? SizedBox()
                : ElevatedButton(
                    onPressed: startGame,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: Text(
                      "Start Game",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
            _isGameOver
                ? ElevatedButton(
                    onPressed: restartGame,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: Text(
                      "Retry",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  final int index;
  const Box({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Text("$index"),
      // alignment: Alignment.center,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class Food extends StatelessWidget {
  const Food({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class Snake extends StatelessWidget {
  const Snake({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

enum SnakeDirection { Up, Down, Left, Right }
