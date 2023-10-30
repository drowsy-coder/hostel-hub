import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_help/common/utils/custom_snackbar.dart';
import 'package:law_help/common/views/custom_button.dart';
import 'package:law_help/constants/theme.dart';
import 'package:law_help/model/user_model.dart';

class EnterDetailsView extends StatefulWidget {
  final String image;
  final FaceFeatures faceFeatures;

  const EnterDetailsView({
    Key? key,
    required this.image,
    required this.faceFeatures,
  }) : super(key: key);

  @override
  State<EnterDetailsView> createState() => _EnterDetailsViewState();
}

class _EnterDetailsViewState extends State<EnterDetailsView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setNameFromFirebase();
  }

  void _setNameFromFirebase() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      final String userId = currentUser.uid;

      try {
        final DocumentSnapshot userDoc =
            await _firestore.collection("users").doc(userId).get();

        if (userDoc.exists) {
          final String userName = userDoc['name'];
          setState(() {
            _nameController.text = userName;
          });
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Add Details"),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [scaffoldTopGradientClr, scaffoldBottomGradientClr],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: CustomButton(
                    text: "Register Now",
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      final User? currentUser = _auth.currentUser;
                      if (currentUser != null) {
                        final String userId = currentUser.uid;

                        final user = UserModel(
                          id: userId,
                          name: _nameController.text.trim().toUpperCase(),
                          image: widget.image,
                          registeredOn: DateTime.now().millisecondsSinceEpoch,
                          faceFeatures: widget.faceFeatures,
                        );

                        try {
                          await _firestore
                              .collection("face")
                              .doc(userId)
                              .set(user.toJson());

                          CustomSnackBar.successSnackBar(
                              "Registration Success!");
                        } catch (e) {
                          CustomSnackBar.errorSnackBar(
                              "Registration Failed! Try Again.");
                          print("Error: $e");
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
