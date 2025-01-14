import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void register() async {
    if (passwordController.text == confirmPasswordController.text) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', emailController.text);
      await prefs.setString('username', usernameController.text);
      await prefs.setString('phone', phoneController.text);
      await prefs.setString('password', passwordController.text);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please log in.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter Username',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF00BFA5)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
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
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter Phone Number',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '08123456789',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.phone_outlined, color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF00BFA5)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
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
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Confirm Password',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: register,
                            child: const Text(
                              'SIGN UP',
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
                        const SizedBox(height: 16),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: const TextStyle(
                                    color: Color(0xFF00BFA5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context);
                                    },
                                ),
                              ],
                            ),
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
