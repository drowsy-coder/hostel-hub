import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_help/screens/stakeholders/lawyer/lawyer_nav.dart';

class AuthorityInfoFormScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📚 Authority Info Form 📝'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AuthorityInfoForm(_auth, _firestore),
      ),
    );
  }
}

class AuthorityInfoForm extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthorityInfoForm(this.auth, this.firestore);

  @override
  _AuthorityInfoFormState createState() => _AuthorityInfoFormState();
}

class _AuthorityInfoFormState extends State<AuthorityInfoForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _employeeIDController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();

  void _saveAuthorityInfoToFirestore() async {
    final User? user = widget.auth.currentUser;
    if (user != null) {
      final String uid = user.uid;

      final authorityInfo = {
        'name': _nameController.text,
        'employeeID': _employeeIDController.text,
        'designation': _designationController.text,
      };

      await widget.firestore.collection('users').doc(uid).update(authorityInfo);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LawyerScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: '👤 Name',
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _employeeIDController,
          decoration: InputDecoration(
            labelText: '🔢 Employee ID',
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _designationController,
          decoration: InputDecoration(
            labelText: '🏢 Designation',
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saveAuthorityInfoToFirestore,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
