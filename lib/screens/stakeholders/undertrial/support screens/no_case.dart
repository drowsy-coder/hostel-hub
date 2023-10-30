import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String name = "";
  String regNumber = "";
  String roomNumber = "";
  bool isPresent = false;
  String upcomingMeal = getCurrentMealType();

  @override
  void initState() {
    super.initState();
    fetchUserDataFromFirestore();
  }

  void fetchUserDataFromFirestore() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userData.exists) {
        Map<String, dynamic> userDataMap =
            userData.data() as Map<String, dynamic>;
        setState(() {
          name = userDataMap["name"] ?? "Name Not Found";
          regNumber =
              userDataMap["registration_number"] ?? "Reg. Number Not Found";
          roomNumber = userDataMap["room_number"] ?? "Room Number Not Found";
        });
      }

      QuerySnapshot attendance = await FirebaseFirestore.instance
          .collection("attendance")
          .where("timestamp", isGreaterThanOrEqualTo: DateTime.now())
          .get();

      if (attendance.docs.isNotEmpty) {
        for (var doc in attendance.docs) {
          Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;
          if (docData != null) {
            Timestamp? timestamp = docData["timestamp"] as Timestamp?;
            if (timestamp != null && isToday(timestamp.toDate())) {
              setState(() {
                isPresent = true;
              });
              break;
            } else {
              print("Hmmmm");
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.day == date.day &&
        now.month == date.month &&
        now.year == date.year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: 1,
              child: Card(
                elevation: 10,
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align to the left
                    children: <Widget>[
                      SizedBox(height: 20), // Increase spacing
                      Text(
                        "👤 Name: $name",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20), // Increase spacing
                      Text(
                        "🔢 Reg Number: $regNumber",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20), // Increase spacing
                      Text(
                        "🏠 Room Number: $roomNumber",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20), // Increase spacing
                    ],
                  ),
                ),
              ),
            ),
            // Card(
            //   elevation: 10,
            //   margin: EdgeInsets.all(20),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(20.0),
            //     child: Text(
            //       isPresent ? "✅ Present" : "❌ Not Present",
            //       style: TextStyle(
            //         fontSize: 24,
            //         color: isPresent ? Colors.green : Colors.red,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            Card(
              elevation: 10,
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "🍽 Upcoming Meal: $upcomingMeal",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getCurrentMealType() {
  final now = DateTime.now();
  if (now.hour >= 7 && now.hour < 9) {
    return 'Breakfast';
  } else if (now.hour >= 12 && now.hour < 14) {
    return 'Lunch';
  } else if (now.hour >= 17 && now.hour < 18) {
    return 'Snacks';
  } else if (now.hour >= 19 && now.hour < 21) {
    return 'Dinner';
  } else {
    if (now.hour < 7) {
      return 'Breakfast';
    } else if (now.hour < 12) {
      return 'Lunch';
    } else if (now.hour < 17) {
      return 'Snacks';
    } else {
      return 'Breakfast';
    }
  }
}
