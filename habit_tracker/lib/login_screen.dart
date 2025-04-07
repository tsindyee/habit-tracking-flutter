import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:habit_tracker/home_tracker_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Default credentials
  final String defaultUsername = 'testuser';
  final String defaultPassword = 'password123';

  void _login() {
    // The login logic goes here
    print("login logic here");

    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == defaultUsername && password == defaultPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HabitTrackerScreen(username: username),
        ),
      );
    }
  }

  bool validateForm() {
    // create logic to validate form
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> authenticateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the stored user data JSON string
    String? jsonUserData = prefs.getString('userData');

    // Check if registration data exists
    if (jsonUserData != null) {
      // Decode the JSON string back into a Map
      Map<String, dynamic> userData = json.decode(jsonUserData);

      // Compare the stored username with the input from the login screen
      if (userData['username'] == _usernameController.text) {
        // The username exists, proceed with additional authentication logic
        print('User authenticated successfully');
        // Navigate to the next screen or home page
      } else {
        // The username does not match the stored registration data
        print('Username does not exist. Please register first.');
        // Optionally, show an error message to the user
      }
    } else {
      // No registration data exists, prompt the user to register
      print('No registration data found. Please register first.');
    }
  }

  void handleLogin() {
    if (validateForm()) {
      authenticateUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Habitt',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.email, color: Colors.blue.shade700),
                      hintText: 'Enter Username',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
                      hintText: 'Enter Password',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Logic for forgot password can be added here
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'or',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 15),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}