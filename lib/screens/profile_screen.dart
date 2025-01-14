import 'package:flutter/material.dart';
import 'package:projectuas1/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  Widget buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget buildProfileView(
      BuildContext context, String username, String email, String phone) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF00BFA5),
        child: Column(
          children: [
            const Expanded(
              flex: 2,
              child: SafeArea(
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF00BFA5),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      buildProfileField('username', username),
                      buildProfileField('Email', email),
                      buildProfileField('phone', phone),
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00BFA5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        SharedPreferences prefs = snapshot.data!;
        String username = prefs.getString('username') ?? 'N/A';
        String email = prefs.getString('email') ?? 'N/A';
        String phone = prefs.getString('phone') ?? 'N/A';

        return buildProfileView(context, username, email, phone);
      },
    );
  }
}
