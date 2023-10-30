import 'package:flutter/material.dart';
import '../../models/user_role.dart';

class LoginUI extends StatelessWidget {
  final bool isLoginForm;
  final UserRole userRole;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController identifierController;
  final TextEditingController caseNumberController;
  final TextEditingController courtIdController;
  final Function(UserRole?) onUserRoleChanged;
  final Function() onFormSubmitted;
  final Function() onToggleFormMode;
  final bool isLoading;

  const LoginUI({
    Key? key,
    required this.isLoginForm,
    required this.userRole,
    required this.emailController,
    required this.passwordController,
    required this.identifierController,
    required this.caseNumberController,
    required this.courtIdController,
    required this.onUserRoleChanged,
    required this.onFormSubmitted,
    required this.onToggleFormMode,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 0,
        title: Text(
          isLoginForm ? 'Login' : 'Create Account',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.grey[800]!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/-Building-Letters.gif',
                              width: 80,
                              height: 80,
                            ),
                            Image.asset(
                              'assets/images/Colorize Image.png',
                              width: 80,
                              height: 80,
                            ),
                          ],
                        ),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Hostel',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 26),
                              ),
                              TextSpan(
                                text: 'Hub',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => onUserRoleChanged(UserRole.student),
                    style: ElevatedButton.styleFrom(
                      primary: userRole == UserRole.student
                          ? Colors.orange
                          : Colors.grey[800],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Student',
                      style: TextStyle(
                        fontSize: 18,
                        color: userRole == UserRole.student
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => onUserRoleChanged(UserRole.authorities),
                    style: ElevatedButton.styleFrom(
                      primary: userRole == UserRole.authorities
                          ? Colors.greenAccent
                          : Colors.grey[800],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Authorities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: userRole == UserRole.authorities
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextFormField(emailController, 'Email'),
            const SizedBox(height: 20),
            _buildTextFormField(passwordController, 'Password',
                isPassword: true),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: ElevatedButton(
                onPressed: onFormSubmitted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      isLoginForm
                          ? 'assets/images/key.png'
                          : 'assets/images/plus.png',
                      width: 30,
                      height: 30,
                    ),
                    Text(
                      isLoginForm ? 'Login' : 'Create Account',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onToggleFormMode,
              child: Text(
                isLoginForm ? 'Create an account' : 'Have an account? Sign in',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            if (isLoading) const SizedBox(height: 20),
            // if (isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String labelText,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        obscureText: isPassword,
      ),
    );
  }
}
