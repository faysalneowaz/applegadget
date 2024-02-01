import 'dart:convert';

import 'package:applegadget/constant.dart';
import 'package:applegadget/model/profilemodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatelessWidget {
  final int login;
  final String accessToken;

  UserProfilePage({required this.login, required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: FutureBuilder(
        future: fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Display user profile data
            // You can create widgets to display the data as per your UI design
            return Center(
              child: Text('User Profile Data: ${snapshot.data!.address}'),
            );
          }
        },
      ),
    );
  }

  Future<ProfileModel> fetchUserProfile() async {

    ProfileModel profileModel = new ProfileModel();
    var body = json.encode({
      'login': login,
      'token': accessToken,
    });
    var header = {"Content-Type": "application/json"};

    print(body + header.toString());
    try {
      var response = await http.post(
        Uri.parse(baseUrl+'/api/ClientCabinetBasic/GetAccountInformation'),
        body: body,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {

        profileModel = ProfileModel.fromJson(jsonDecode(response.body));
        print(profileModel.address);
      } else {
        print(await response.body);
        Fluttertoast.showToast(
            msg: "Not Getting any data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
    return profileModel;
  }
}