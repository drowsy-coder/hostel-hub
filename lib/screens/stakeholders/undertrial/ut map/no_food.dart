import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoFoodScreen extends StatefulWidget {
  @override
  _NoFoodScreenState createState() => _NoFoodScreenState();
}

class _NoFoodScreenState extends State<NoFoodScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController responseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Wastage Report'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Food Available',
              style: TextStyle(fontSize: 24),
            ),
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Do you want your next meal?',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: responseController,
                      decoration: InputDecoration(
                        hintText: 'Yes or No',
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: submitResponse,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitResponse() {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      String response = responseController.text;

      // Fetch user data from the 'users' collection
      _firestore.collection('users').doc(uid).get().then((userDoc) {
        if (userDoc.exists) {
          String name = userDoc['name'];
          String registrationNumber = userDoc['registrationNumber'];

          // Store the response in the 'no_food' collection
          _firestore.collection('no_food').add({
            'uid': uid,
            'name': name,
            'registrationNumber': registrationNumber,
            'response': response,
          });

          // Clear the response text field
          responseController.clear();

          // Optionally, you can show a confirmation dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Response Submitted'),
                content: Text('Your response has been submitted.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }
}
