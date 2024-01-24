import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/Constants/HeightAndColor.dart';
import 'package:game/GameScreens/HomeScreen.dart';
import 'package:game/HelperFunctions/Toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class GameScreen extends StatefulWidget {
  List<int> Cards = [];
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

  final CollectionReference cardCollection =
      FirebaseFirestore.instance.collection('playingCards');

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final String storagePath = 'playingCards';

  int numberOfRoundsLeft = 0;

  Future<void> getCardsDataFromFirestore() async {
    try {
      // Reference to the Firestore collection
      CollectionReference cardCollection =
          FirebaseFirestore.instance.collection('cards');

      // Get the document containing the cardsData field
      QuerySnapshot<Object?> querySnapshot = await cardCollection.get();
      print('documnetData : $querySnapshot');

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        // Access the first document
        dynamic cardsData = querySnapshot.docs.first['cardsData'];
        print('dynamic : $cardsData');

        // Check if cardsData is a List
        if (cardsData is List) {
          widget.Cards = cardsData.cast<int>();
          print('widget.Cards : ${widget.Cards}');
        } else {
          print('cardsData is not a List');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error getting cards: $e');
    }
  }

  void numberOfRoundsLeft_() {
    double cardsByThree = cardsCount / 3;
    print("cardsByThree : $cardsByThree");
    numberOfRoundsLeft = 13 - cardsByThree.toInt();
    print("numberOfRoundsLeft : $numberOfRoundsLeft");
  }

  Future<String> getImageUrlFromFirestore(String cardNumber) async {
    try {
      DocumentSnapshot documentSnapshot =
          await cardCollection.doc(cardNumber).get();

      if (documentSnapshot.exists) {
        return documentSnapshot['imageUrl'];
      } else {
        return ''; // Return an empty string if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching image URL: $e");
      return ''; // Return an empty string in case of an error
    }
  }

  // Future<void> uploadCardImages() async {
  //   for (int i = 0; i <= 10; i++) {
  //     try {
  //       String cardNumber = '$i';
  //       String assetPath = 'assets/cards/$cardNumber.png';

  //       // Load the image from the asset
  //       ByteData data = await rootBundle.load(assetPath);
  //       List<int> bytes = data.buffer.asUint8List();

  //       // Upload image to Firebase Storage
  //       String imageUrl = await uploadImageToStorage('$cardNumber.png', bytes);

  //       // Add image URL to Firestore
  //       await addImageUrlToFirestore(cardNumber, imageUrl);
  //     } catch (e) {
  //       ToastMessage.toast_(e.toString());
  //     }
  //   }
  // }

  // Future<String> uploadImageToStorage(
  //     String imageName, List<int> imageData) async {
  //   String imageUrl = '';
  //   try {
  //     Reference storageRef = storage.ref().child('$storagePath/$imageName');
  //     UploadTask uploadTask = storageRef.putData(Uint8List.fromList(imageData));

  //     // Wait for the upload to complete and return the download URL
  //     TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
  //     imageUrl = await snapshot.ref.getDownloadURL();
  //   } catch (e) {
  //     ToastMessage.toast_(e.toString());
  //   }
  //   return imageUrl;
  // }

  Future<void> addImageUrlToFirestore(
      String cardNumber, String imageUrl) async {
    await cardCollection.doc(cardNumber).set({
      'cardNumber': cardNumber,
      'imageUrl': imageUrl,
    });
  }

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
    getCardsDataFromFirestore();
    // uploadCardImages();
    numberOfRoundsLeft_();
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
              height: 100,
              width: double.infinity,
              child: Center(
                child: Column(
                  children: [
                    Row(children: [
                      Text("numberOfRoundsLeft = $numberOfRoundsLeft  "),
                      Text("userpoint : $userPoints "),
                    ]),
                    Text("userRoundWin : $userRoundWin"),
                  ],
                ),
              ),
            ),
            FutureBuilder<String>(
              // Use FutureBuilder to fetch image URL and update the widget
              future: getImageUrlFromFirestore(0.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error loading image");
                } else {
                  String imageUrl = snapshot.data ?? ''; // Get the image URL
                  return DisplaySingleCard(Card: 0, imageUrl: imageUrl);
                }
              },
            ),
            SpaceBox(),
            if (showThirdCard) ...[
              FutureBuilder<String>(
                future: getImageUrlFromFirestore(
                    widget.Cards[cardsCount + 1].toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error loading image");
                  } else {
                    String imageUrl = snapshot.data ?? '';
                    return DisplaySingleCard(
                        Card: widget.Cards[cardsCount + 1], imageUrl: imageUrl);
                  }
                },
              ),
              SpaceBox(),
              FutureBuilder<String>(
                future: getImageUrlFromFirestore(
                    widget.Cards[cardsCount + 2].toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error loading image");
                  } else {
                    String imageUrl = snapshot.data ?? '';
                    return DisplaySingleCard(
                        Card: widget.Cards[cardsCount + 2], imageUrl: imageUrl);
                  }
                },
              ),
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
                    numberOfRoundsLeft_();

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
                    numberOfRoundsLeft_();

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
                    numberOfRoundsLeft_();

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
  final String imageUrl;

  DisplaySingleCard({required this.Card, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 115,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black, // Set your border color
          width: 2.0,
        ),
        color: Colors.black, // Set your background color
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
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
        const SizedBox(
          height: 30,
        ),
        TextButton(
          onPressed: () {
            Get.to(HomeScreen());
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
