import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_role.dart';
import '../stakeholders/court/court_nav.dart';
import '../stakeholders/lawyer/lawyer_nav.dart';
import '../stakeholders/undertrial/undertrial_nav.dart';
import 'login_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _identifierController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoginForm = true;
  bool _isLoading = false;
  UserRole _userRole = UserRole.student;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final String? uid = _prefs.getString('uid');
      final String? email = _prefs.getString('email');
      final String? identifier = _prefs.getString('identifier');
      final String? storedUserRole = _prefs.getString('userRole');

      if (uid != null &&
          email != null &&
          identifier != null &&
          storedUserRole != null) {
        setState(() {
          _userRole = stringToUserRole(storedUserRole);
        });

        // Redirect the user to the appropriate screen
        _redirectToRequiredScreen();
      }
    }
  }

  void _saveUserDataToPrefs(String uid, String email) {
    _prefs.setString('uid', uid);
    _prefs.setString('email', email);
    _prefs.setString('userRole', userRoleToString(_userRole));
    _prefs.setBool('isLoggedIn', true);
  }

  Future<void> _signInWithEmail(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = userCredential.user!;
      final String uid = user.uid;

      final DocumentSnapshot userData =
          await _firestore.collection('users').doc(uid).get();

      if (userData.exists) {
        final String storedUserRole = userData['userRole'];
        final UserRole userRole = stringToUserRole(storedUserRole);

        if (userRole == _userRole) {
          _saveUserDataToPrefs(uid, email);

          // Redirect the user to the appropriate screen
          _redirectToRequiredScreen();

          setState(() {
            _isLoading = false;
          });
        }
      }
    } on FirebaseAuthException {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _redirectToRequiredScreen() {
    if (_userRole == UserRole.student) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ClientScreen(),
        ),
      );
    } else if (_userRole == UserRole.authorities) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LawyerScreen(),
        ),
      );
    }
  }

  void _toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  Future<void> _createAccount(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = userCredential.user!;
      final String uid = user.uid;

      await _storeUserData(uid, email);

      _saveUserDataToPrefs(uid, email);

      // Redirect the user to the appropriate screen
      _redirectToRequiredScreen();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _storeUserData(String uid, String email) async {
    final userData = {
      'name': email.split('@')[0],
      'email': email,
      'userRole': userRoleToString(_userRole),
      'uid': uid,
    };

    await _firestore.collection('users').doc(uid).set(userData);
  }

  void _submitForm() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (_isLoginForm) {
      _signInWithEmail(email, password);
    } else {
      _createAccount(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginUI(
      isLoginForm: _isLoginForm,
      userRole: _userRole,
      emailController: _emailController,
      passwordController: _passwordController,
      identifierController: _identifierController,
      onUserRoleChanged: (UserRole? newValue) {
        setState(() {
          _userRole = newValue!;
        });
      },
      onFormSubmitted: () {
        _submitForm();
      },
      onToggleFormMode: () {
        _toggleFormMode();
      },
      isLoading: _isLoading,
      caseNumberController: TextEditingController(),
      courtIdController: TextEditingController(),
    );
  }
}
