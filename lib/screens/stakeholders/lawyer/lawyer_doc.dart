import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class LocationTrackingScreen extends StatefulWidget {
  const LocationTrackingScreen({Key? key}) : super(key: key);

  @override
  _LocationTrackingScreenState createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userRole;
  String? username;
  late StreamSubscription<Position> positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  void fetchUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          userRole = userDoc['userRole'];
          username = userDoc['name'];
        });
        startLocationTracking(user.uid);
      }
    }
  }

  void startLocationTracking(String uid) {
    Stream<User?> userStream = _auth.authStateChanges();
    userStream.listen((User? user) {
      positionStreamSubscription =
          Geolocator.getPositionStream().listen((Position position) {
        print(position.latitude);

        if (username != null) {
          _firestore.collection('authority_locations').doc(uid).set({
            'uid': uid,
            'username': username,
            'userRole': userRole,
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      });
    });
  }

  @override
  void dispose() {
    positionStreamSubscription
        .cancel(); // Cancel the stream subscription when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Tracking"),
        actions: <Widget>[],
      ),
      body: Center(
        child: Text("Location Tracking Screen"),
      ),
    );
  }
}
