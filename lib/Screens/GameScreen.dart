import 'dart:html';

import 'package:flutter/material.dart';
import 'package:game/Screens/Constants/HeightAndColor.dart';
import 'package:game/Screens/HomeScreen.dart';

class GameScreen extends StatefulWidget {
  List<int> Cards;
  GameScreen({required this.Cards});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool showThirdCard = false;
  List<int> tempCards = [];

  int cardsCount = 0;
  int actualResult = 0;
  String userGuess = '';
  int userPoints = 0;
  bool userRoundWin = false;
  bool showNewGame = false;

  Future<void> CardsToTempCards() async {
    for (int i = 0; i < widget.Cards.length; i++) {}
  }

  Future<void> runningCardsCount() async {
    if (cardsCount + 3 == 39) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartNewGame(
              cardsCount: cardsCount.toString(),
              userPoints: userPoints.toString(),
            ),
          ));
    } else {
      cardsCount += 3;
    }
  }

  Future<void> singleRoundResult(var userGuess) async {
    try {
      actualResult =
          widget.Cards[cardsCount + 1] + widget.Cards[cardsCount + 2];
      print(
          "card1: ${widget.Cards[cardsCount + 1]} card2: ${widget.Cards[cardsCount + 2]} acutalResult : $actualResult");
      if (userGuess == 'small' && actualResult <= 10) {
        userPoints += 1;
        userRoundWin = true;
      } else if (userGuess == 'lucky' && actualResult == 11) {
        userPoints += 3;
        userRoundWin = true;
      } else if (userGuess == 'big' && actualResult >= 12) {
        userPoints += 1;
        userRoundWin = true;
      } else {
        userRoundWin = false;
      }
    } catch (e) {
      print("Error : $e");
    }

    print("cardsCount = $cardsCount  ");
    print("userpoint : $userPoints");
    print("userRoundWin : $userRoundWin");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              child: Row(children: [
                Text("cardsCount = $cardsCount  "),
                Text("userpoint : $userPoints "),
                Text("userRoundWin : $userRoundWin"),
              ]),
            ),
            DisplaySingleCard(Card: widget.Cards[cardsCount]),
            SpaceBox(),
            if (showThirdCard) ...[
              DisplaySingleCard(Card: widget.Cards[cardsCount + 1]),
              SpaceBox(),
              DisplaySingleCard(Card: widget.Cards[cardsCount + 2]),
            ],
            SpaceBox(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    setState(() {
                      showThirdCard = true;
                    });

                    await runningCardsCount();
                    await singleRoundResult("small");
                  },
                  child: const Text(
                    "Chinna Bazar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      showThirdCard = true;
                    });
                    await runningCardsCount();
                    await singleRoundResult("lucky");
                  },
                  child: const Text(
                    "Lucky",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                //chinna bazar end
                TextButton(
                  onPressed: () async {
                    setState(() {
                      showThirdCard = true;
                    });
                    await runningCardsCount();
                    await singleRoundResult("big");
                  },
                  child: const Text(
                    "Peddha Bazar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                //pedha bazar button end
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DisplaySingleCard extends StatelessWidget {
  final int Card;

  DisplaySingleCard({required this.Card});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black, // Set your border color
          width: 2.0,
        ),
        color: Colors.white, // Set your background color
      ),
      child: Stack(
        children: [
          // Display Card value on top left
          Positioned(
            top: 8,
            left: 8,
            child: Text(
              Card.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Display Card value on bottom right
          Positioned(
            bottom: 8,
            right: 8,
            child: Text(
              Card.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StartNewGame extends StatelessWidget {
  String cardsCount;
  String userPoints;

  StartNewGame({required this.cardsCount, required this.userPoints});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("cardsCount = $cardsCount  "),
        Text("userpoint : $userPoints"),
        SizedBox(
          height: 30,
        ),
        TextButton(
          onPressed: () {
            const HomeScreen();
          },
          child: const Text(
            "Start New Game",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ],
    );
  }
}

class SpaceBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 5,
    );
  }
}
