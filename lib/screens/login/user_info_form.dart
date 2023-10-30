import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:law_help/screens/stakeholders/undertrial/undertrial_nav.dart';

class StudentInfoFormScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📚 Student Info Form 📝'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StudentInfoForm(_auth, _firestore),
      ),
    );
  }
}

class StudentInfoForm extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  StudentInfoForm(this.auth, this.firestore);

  @override
  _StudentInfoFormState createState() => _StudentInfoFormState();
}

class _StudentInfoFormState extends State<StudentInfoForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _roomNumberController = TextEditingController();

  void _saveStudentInfoToFirestore() async {
    final User? user = widget.auth.currentUser;
    if (user != null) {
      final String uid = user.uid;

      final studentInfo = {
        'name': _nameController.text,
        'registrationNumber': _registrationNumberController.text,
        'roomNumber': _roomNumberController.text,
      };

      await widget.firestore.collection('users').doc(uid).update(studentInfo);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ClientScreen(),
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
          controller: _registrationNumberController,
          decoration: InputDecoration(
            labelText: '🔢 Registration Number',
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _roomNumberController,
          decoration: InputDecoration(
            labelText: '🏠 Room Number',
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saveStudentInfoToFirestore,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
