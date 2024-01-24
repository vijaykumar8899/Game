import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game/GameScreens/GameScreen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> Cards = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static String userPhoneNumber = '';
  static String userName = '';

  Future<void> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhoneNumber = prefs.getString('userPhoneNumber') ?? '';
      userName = prefs.getString('userName') ?? '';
    });
  }

  void addingOneToTenNumbersToCards() {
    for (int j = 1; j <= 4; j++) {
      for (int i = 1; i <= 10; i++) {
        Cards.add(i);
      }
    }
  }

  void shuffleCards() {
    Cards.shuffle();
    print("After shuffle method : $Cards");
    print("After shuffle method: ${Cards.length}");
  }

  @override
  void initState() {
    super.initState();
    addingOneToTenNumbersToCards();
    shuffleCards();
    shuffleCards();
    getUserDetails();
  }

  Future<void> saveCardsToFirestore(List<int> cards) async {
    try {
      // Convert List<int> to List<dynamic>
      List<dynamic> cardsData = cards.map((card) => card).toList();

      // Reference to the Firestore collection
      CollectionReference cardCollection =
          FirebaseFirestore.instance.collection('cards');

      // Add the list to Firestore
      await cardCollection.doc().set({
        'cardsData': cardsData,
      });

      print('Cards saved successfully.');
    } catch (e) {
      print('Error saving cards: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chinna Bazar Pedha Bazar",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Shuffle Cards',
            onPressed: () {
              setState(() {
                shuffleCards();
              });
            },
            icon: const Icon(
              FontAwesomeIcons.shuffle,
              color: Colors.red,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Wellcome Back!, $userName"),
          Center(
            child: Text(
              "Cards Are Ready, Are You Ready?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Row(
            children: [
              Text("Feel like shuffle the cards more?"),
              TextButton(
                onPressed: () {
                  setState(() {
                    shuffleCards();
                  });
                },
                child: Text("Shuffle Cards"),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Or Want to view the cards?"),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Shuffled Cards"),
                        content: Container(
                          width: double.maxFinite,
                          child: viewCards(Cards: Cards),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("View Shuffled Cards"),
              ),
            ],
          ),
          TextButton(
            onPressed: () async {
              await saveCardsToFirestore(Cards);
              Get.to(GameScreen());
            },
            child: const Text(
              "Start Game",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class viewCards extends StatelessWidget {
  final List<int> Cards;

  viewCards({required this.Cards});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: Cards.length,
      itemBuilder: ((context, index) {
        return Card(
          child: Center(
            child: Text(
              Cards[index].toString(),
              style: TextStyle(fontSize: 10),
            ),
          ),
        );
      }),
    );
  }
}
