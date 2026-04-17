import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  String message = "";

  Future<void> createAccount() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      setState(() => message = "All fields are required");
      return;
    }

    setState(() => message = "Creating account...");

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.text.trim(),
          "password": password.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {
        if (response.statusCode == 201) {
          message = "Account created!";

          Future.delayed(Duration(seconds: 1), () {
            if (mounted) { 
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          });

        } else {
          message = data['error'] ?? "Signup failed";
        }
      });
    } catch (e) {
      setState(() => message = "Error: Could not connect to server");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Create Account",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),

            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            if (message.isNotEmpty)
              Text(message,
                  style:
                  TextStyle(color: message.contains("created") ? Colors.green : Colors.red)),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: createAccount,
                child: Text("Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}