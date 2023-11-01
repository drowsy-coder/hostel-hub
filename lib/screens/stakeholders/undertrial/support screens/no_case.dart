import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:law_help/screens/stakeholders/undertrial/support%20screens/mental/chat_support.dart';
import 'package:law_help/screens/stakeholders/undertrial/ut_support.dart';
import 'package:law_help/screens/stakeholders/undertrial/support%20screens/vocational/nik.dart';

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
              userDataMap["registrationNumber"] ?? "Reg. Number Not Found";
          roomNumber = userDataMap["roomNumber"] ?? "Room Number Not Found";
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
        backgroundColor: Colors.blue,
        title: Text("Welcome, $name!"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MentalSupportScreen()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              CardWidget(
                icon: Icons.person,
                text: "Name: $name",
              ),
              CardWidget(
                icon: Icons.confirmation_number,
                text: "Reg Number: $regNumber",
              ),
              CardWidget(
                icon: Icons.home,
                text: "Room Number: $roomNumber",
              ),
              SizedBox(height: 20),
              CardWidget(
                icon: Icons.restaurant,
                text: "Upcoming Meal: $upcomingMeal",
              ),
              CardWidget(
                icon: Icons.calendar_today,
                text: "Chhota Dhobi: 5th Nov",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  CardWidget({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 36,
          color: Colors.indigo,
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
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
