import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_help/authenticate_face/authenticate_face_view.dart';
import 'package:law_help/common/utils/custom_snackbar.dart';
import 'package:law_help/common/utils/extensions/size_extension.dart';
import 'package:law_help/common/utils/screen_size_util.dart';
import 'package:law_help/common/views/custom_button.dart';
import 'package:law_help/constants/theme.dart';
import 'package:law_help/register_face/enter_password_view.dart';

class Face extends StatefulWidget {
  const Face({Key? key}) : super(key: key);

  @override
  _FaceState createState() => _FaceState();
}

class _FaceState extends State<Face> {
  bool isUserRegistered = false; // Track if the user is already registered

  @override
  void initState() {
    super.initState();
    // Check if the current user's UID is already registered in the "face" collection
    checkIfUserIsRegistered();
  }

  // Function to check if the current user's UID is registered in the "face" collection
  void checkIfUserIsRegistered() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Use Firebase Firestore to check if the UID exists in the "face" collection
      FirebaseFirestore.instance
          .collection('face')
          .doc(currentUser.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          // The user is registered, so hide the "Register User" button
          setState(() {
            isUserRegistered = true;
          });
        }
      }).catchError((error) {
        print('Error checking user registration: $error');
      });
    }
  }

  void initializeUtilContexts(BuildContext context) {
    ScreenSizeUtil.context = context;
    CustomSnackBar.context = context;
  }

  @override
  Widget build(BuildContext context) {
    initializeUtilContexts(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey[900]!,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Attendance System 🚨",
              style: TextStyle(
                color: textColor,
                fontSize: 0.033.sh,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.07.sh),
            if (!isUserRegistered) // Display the button only if the user is not registered
              CustomButton(
                text: "Register User",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EnterPasswordView(),
                    ),
                  );
                },
              ),
            SizedBox(height: 0.025.sh),
            CustomButton(
              text: "Mark Attendance",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AuthenticateFaceView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}




