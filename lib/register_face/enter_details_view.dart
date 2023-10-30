import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law_help/common/utils/custom_snackbar.dart';
import 'package:law_help/common/utils/custom_text_field.dart';
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
  bool isRegistering = false;
  final _formFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController();

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
            colors: [
              scaffoldTopGradientClr,
              scaffoldBottomGradientClr,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  formFieldKey: _formFieldKey,
                  controller: _nameController,
                  hintText: "Name",
                  validatorText: "Name cannot be empty",
                ),
                CustomButton(
                  text: "Register Now",
                  onTap: () async {
                    if (_formFieldKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();

                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        final userId = currentUser.uid;
                        print(currentUser.uid);

                        final user = UserModel(
                          id: userId,
                          name: _nameController.text.trim().toUpperCase(),
                          image: widget.image,
                          registeredOn: DateTime.now().millisecondsSinceEpoch,
                          faceFeatures: widget.faceFeatures,
                        );

                        try {
                          await FirebaseFirestore.instance
                              .collection("face")
                              .doc(userId)
                              .set(user.toJson());

                          CustomSnackBar.successSnackBar(
                              "Registration Success!");
                          Future.delayed(const Duration(seconds: 1), () {
                            // Reaches HomePage
                            Navigator.of(context)
                              ..pop()
                              ..pop()
                              ..pop();
                          });
                        } catch (e) {
                          CustomSnackBar.errorSnackBar(
                              "Registration Failed! Try Again.");
                          print("Error: $e");
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
