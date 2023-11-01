import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class NoFoodScreen extends StatefulWidget {
  @override
  _NoFoodScreenState createState() => _NoFoodScreenState();
}

class _NoFoodScreenState extends State<NoFoodScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool hasResponded = false;
  double starRating = 0.0;
  TextEditingController suggestionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkUserResponse();
  }

  void checkUserResponse() {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      String todayDate = DateTime.now().toLocal().toString().split(' ')[0];

      _firestore
          .collection('no_food')
          .where('uid', isEqualTo: uid)
          .where('date', isEqualTo: todayDate)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            hasResponded = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mess Management'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              if (!hasResponded)
                ResponseCard(
                  onPressed: (response) {
                    submitResponse(response);
                  },
                )
              else
                AlreadyRespondedCard(),
              const SizedBox(height: 20),
              SurveyCard(
                onRatingChanged: (rating) {
                  setState(() {
                    starRating = rating;
                  });
                },
                suggestionsController: suggestionsController,
                onSubmit: () {
                  submitReview(starRating, suggestionsController.text);
                },
                rating: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitResponse(String response) {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      String todayDate = DateTime.now().toLocal().toString().split(' ')[0];

      _firestore.collection('users').doc(uid).get().then((userDoc) {
        if (userDoc.exists) {
          String name = userDoc['name'];
          String registrationNumber = userDoc['registrationNumber'];

          _firestore.collection('no_food').add({
            'uid': uid,
            'name': name,
            'registrationNumber': registrationNumber,
            'response': response,
            'date': todayDate,
          });

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Response Submitted'),
                content: const Text('Your response has been submitted.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          setState(() {
            hasResponded = true;
          });
        }
      });
    }
  }

  void submitReview(double rating, String suggestions) {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      String todayDate = DateTime.now().toLocal().toString().split(' ')[0];

      _firestore.collection('users').doc(uid).get().then((userDoc) {
        if (userDoc.exists) {
          String name = userDoc['name'];
          String registrationNumber = userDoc['registrationNumber'];

          _firestore.collection('reviews').add({
            'uid': uid,
            'name': name,
            'registrationNumber': registrationNumber,
            'rating': rating,
            'suggestions': suggestions,
            'date': todayDate,
          });

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Review Submitted'),
                content: const Text('Your review has been submitted.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          setState(() {
            hasResponded = true;
          });
        }
      });
    }
  }
}

class ResponseCard extends StatelessWidget {
  final Function(String) onPressed;

  ResponseCard({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4, // Adds a shadow to the card for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.blue, // Background color
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12), // Rounded top corners
              ),
            ),
            child: const Text(
              'Do you want your next meal?',
              style: TextStyle(
                fontSize: 24, // Larger text size
                color: Colors.white, // Text color
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  onPressed('Yes');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Button background color
                  elevation: 2, // Button elevation
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.white, // Button text color
                    fontSize: 16, // Button text size
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  onPressed('No');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Button background color
                  elevation: 2, // Button elevation
                ),
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.white, // Button text color
                    fontSize: 16, // Button text size
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AlreadyRespondedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'You have already responded for today.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyCard extends StatelessWidget {
  final double rating;
  final Function(double) onRatingChanged;
  final TextEditingController suggestionsController;
  final VoidCallback onSubmit;

  SurveyCard({
    required this.rating,
    required this.onRatingChanged,
    required this.suggestionsController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: const Text(
              'Mess Food Review Survey',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Text(
                  '1. Were you satisfied with the food?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 40.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    onRatingChanged(rating);
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  '2. Anything you would like to add?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      // border: Border.all(color: Colors.grey),
                      // borderRadius: BorderRadius.circular(8),
                      ),
                  child: TextField(
                    controller: suggestionsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Your suggestions...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyan,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
