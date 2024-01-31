import 'dart:convert';

import 'package:applegadget/constant.dart';
import 'package:applegadget/profile/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String accessToken = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: loginController,
              decoration: const InputDecoration(labelText: 'UserId'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await login();
                // Navigate to the next screen after successful login
                if(accessToken != ""){
                   Navigator.push(
                    context,
                     MaterialPageRoute(
                      builder: (context) => UserProfilePage(
                        login: loginController.text,
                        accessToken: accessToken,
                      ),
                    ),
                  );
                }

              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    final response = await http.post(
      Uri.parse(baseUrl+"/api/ClientCabinetBasic/IsAccountCredentialsCorrect"),
      body: {
        'login': loginController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      accessToken = data['accessToken'];
    } else {
      Fluttertoast.showToast(
          msg: "Login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}