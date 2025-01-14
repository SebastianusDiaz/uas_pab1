import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectuas1/main.dart';
import 'package:projectuas1/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (emailController.text == savedEmail && passwordController.text == savedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      ); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color(0xFF00BFA5),
        child: Column(
          children: [
            const Expanded(
              flex: 2,
              child: SafeArea(
                child: Center(
                  child: Text(
                    'Sportify',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, -2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter Email',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'example@gmail.com',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF00BFA5)),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF00BFA5)),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              login();
                            },
                            child: const Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00BFA5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: const TextStyle(
                                  color: Color(0xFF00BFA5),
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterScreen()),
                                    );
                                  },
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
          ],
        ),
      ),
    );
  }
}
