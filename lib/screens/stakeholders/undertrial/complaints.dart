import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class Complaints extends StatelessWidget {
  const Complaints({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Complaint'),
        centerTitle: true, // Center the title in the app bar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Change background color
                  shape: BoxShape.circle, // Make it a circle
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/-Error-GIF-unscreen.gif'),
                  radius: 50,
                ),
              ),
              SizedBox(height: 20), // Add spacing
              Container(
                width: 380,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black, // Change background color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ComplaintsForm(),
              ),
            ],
          ),
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
  final TextEditingController _CategoryController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  late MultiValueDropDownController _cntMulti;

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    _cntMulti = MultiValueDropDownController();
    super.initState();
  }

  @override
  void dispose() {
    _cnt.dispose();
    _cntMulti.dispose();
    super.dispose();
  }

  bool _deScriptionFocused = false;
  bool _CategoryFocused = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<DropDownValueModel> categoryList = [
    const DropDownValueModel(name: 'ACADEMICS', value: 'ACADEMICS'),
    const DropDownValueModel(name: 'ADMISSION', value: 'ADMISSION'),
    const DropDownValueModel(name: 'COE', value: 'COE'),
    const DropDownValueModel(
        name: 'COURSE REGISTRATION', value: 'COURSE REGISTRATION'),
    const DropDownValueModel(name: 'CTS', value: 'CTS'),
    const DropDownValueModel(name: 'HOSTEL', value: 'HOSTEL'),
    const DropDownValueModel(
        name: 'HOSTEL REGISTRATION', value: 'HOSTEL REGISTRATION'),
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
        final String userId = user.uid;
        final String Category = _CategoryController.text.trim();
        final String deScription = _deScriptionController.text.trim();

        try {
          CollectionReference complaints =
              FirebaseFirestore.instance.collection('complaints');
          Map<String, dynamic> data = {
            "userId": userId,
            "Category": Category,
            "deScription": deScription,
          };
          await complaints.add(data);
          _deScriptionController.clear();
          _CategoryController.clear();
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
          DropDownTextField(
            textFieldDecoration: const InputDecoration(
              icon: Icon(
                Icons.category,
                color: Colors.blue,
              ),
            ),
            controller: _cnt, // Use the SingleValueDropDownController
            clearOption: true,
            searchDecoration: const InputDecoration(
              hintText: 'Select a category',
            ),
            validator: (value) {
              if (value == null) {
                return 'Please select a category';
              } else {
                return null;
              }
            },
            dropDownItemCount: categoryList.length,
            dropDownList: categoryList,
            onChanged: (val) {
              _CategoryController.text = val?.value;
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
