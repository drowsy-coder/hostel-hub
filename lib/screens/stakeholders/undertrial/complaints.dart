import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../login/login_method.dart';

void main() {
  runApp(const MaterialApp(home: Complaints()));
}

class Complaints extends StatelessWidget {
  const Complaints({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Complaint'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset('assets/images/orange-error-icon-0.png',
                      height: 100, width: 100),
                ],
              ),
            ),
            Container(
              width: 380,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[900],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[800]!,
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const ComplaintsForm(),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class ComplaintsForm extends StatefulWidget {
  const ComplaintsForm({super.key});

  @override
  _ComplaintsFormState createState() => _ComplaintsFormState();
}

class _ComplaintsFormState extends State<ComplaintsForm> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _deScriptionController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final TextEditingController _CategoryController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  late MultiValueDropDownController _cntMulti;

  @override
  void initState(){
    _cnt = SingleValueDropDownController();
    _cntMulti = MultiValueDropDownController();
    super.initState();
  }

  @override
  void dispose(){
    _cnt.dispose();
    _cntMulti.dispose();
    super.dispose();
  }

  bool _deScriptionFocused = false;
  bool _subCategoryFocused = false;
  bool _CategoryFocused = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout(BuildContext context) async {
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    prefs.remove('email');
    prefs.remove('subCategory');
    prefs.remove('isLoggedIn');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  List<DropDownValueModel> categoryList = [
  const DropDownValueModel(name: 'ACADEMICS', value: 'ACADEMICS'),
  const DropDownValueModel(name: 'ADMISSION', value: 'ADMISSION'),
  const DropDownValueModel(name: 'COE', value: 'COE'),
  const DropDownValueModel(name: 'COURSE REGISTRATION', value: 'COURSE REGISTRATION'),
  const DropDownValueModel(name: 'CTS', value: 'CTS'),
  const DropDownValueModel(name: 'HOSTEL', value: 'HOSTEL'),
  const DropDownValueModel(name: 'HOSTEL REGISTRATION', value: 'HOSTEL REGISTRATION'),
  const DropDownValueModel(name: 'HR', value: 'HR'),
  const DropDownValueModel(name: 'MELITE', value: 'MELITE'),
  const DropDownValueModel(name: 'OTHERS', value: 'OTHERS'),
  const DropDownValueModel(name: 'P2P', value: 'P2P'),
  const DropDownValueModel(name: 'PAT PLACEMENT', value: 'PAT PLACEMENT'),
  const DropDownValueModel(name: 'STUDENT WELFARE', value: 'STUDENT WELFARE'),
  const DropDownValueModel(name: 'VIT EVENTS', value: 'VIT EVENTS'),
  const DropDownValueModel(name: 'VIT WEBSITE', value: 'VIT WEBSITE'),
  const DropDownValueModel(name: 'VITIAN APP', value: 'VITIAN APP'),
  const DropDownValueModel(name: 'VTOP', value: 'VTOP'),
];


  void _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String courtId = user.uid;
        final String courtEmail = user.email!;

        final String Category = _CategoryController.text.trim();
        final String deScription = _deScriptionController.text.trim();
        final String subCategory = _subCategoryController.text.trim();

        try {
          final QuerySnapshot existingComplaints = await FirebaseFirestore
              .instance
              .collection('complaints')
              .where('courtId', isEqualTo: courtId)
              .where('deScription', isEqualTo: deScription)
              .get();

          if (existingComplaints.docs.isNotEmpty) {
            for (QueryDocumentSnapshot doc in existingComplaints.docs) {
              await FirebaseFirestore.instance
                  .collection('complaints')
                  .doc(doc.id)
                  .delete();
            }
          }

          final QuerySnapshot lawyerQuery = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: Category)
              .get();

          if (lawyerQuery.docs.isNotEmpty) {
            final String lawyerName = lawyerQuery.docs[0]['name'];

            final DocumentSnapshot userData = await FirebaseFirestore.instance
                .collection('users')
                .doc(courtId)
                .get();

            final String judgeName = userData['name'];

            await FirebaseFirestore.instance.collection('complaints').add({
              'judgeName': judgeName,
              'courtId': courtId,
              'courtEmail': courtEmail,
              'subCategory': subCategory,
              'deScription': deScription,
              'Category': Category,
            });

            _deScriptionController.clear();
            _subCategoryController.clear();
            _CategoryController.clear();
          }
        } catch (error) {
          print('Error: $error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _CategoryController,
            decoration: InputDecoration(
              labelText: 'Category',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: _CategoryFocused ? 3 : 1,
                  color: Colors.lightBlueAccent,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.grey[900],
              icon: const Icon(
                Icons.email,
                color: Colors.lightBlueAccent,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the category';
              }
              return null;
            },
            onTap: () {
              setState(() {
                _CategoryFocused = true;
                _subCategoryFocused = false;
                _deScriptionFocused = false;
              });
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _subCategoryController,
            decoration: InputDecoration(
              labelText: 'Sub-Category',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: _subCategoryFocused ? 3 : 1,
                  color: Colors.pink,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.grey[900],
              icon: const Icon(
                Icons.numbers,
                color: Colors.pink,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the subCategory';
              }
              return null;
            },
            onTap: () {
              setState(() {
                _deScriptionFocused = false;
                _subCategoryFocused = true;
                _CategoryFocused = false;
              });
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _deScriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: _deScriptionFocused ? 3 : 1,
                  color: Colors.green,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.grey[900],
              icon: const Icon(
                Icons.email,
                color: Colors.green,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the lawyer\'s email';
              }
              return null;
            },
            onTap: () {
              setState(() {
                _deScriptionFocused = true;
                _subCategoryFocused = false;
                _CategoryFocused = false;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitComplaint,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.amberAccent),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
