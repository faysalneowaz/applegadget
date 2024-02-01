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
    var body = json.encode({
      'login': int.parse(loginController.text),
      'password': passwordController.text,
    });
    var header = {"Content-Type": "application/json"};

    print(body + header.toString());
    try {
      var response = await http.post(
        Uri.parse(baseUrl+'/api/ClientCabinetBasic/IsAccountCredentialsCorrect'),
        body: json.encode({
          "login": 2088888,
          "password": "ral11lod"
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(await response.body);
        if (data['token'] != null) {
          accessToken = data['token'];
        } else {
          print("AccessToken is null");
        }
      } else {
        print(await response.body);
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }
}