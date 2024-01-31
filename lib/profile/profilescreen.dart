import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatelessWidget {
  final String login;
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
              child: Text('User Profile Data: ${snapshot.data}'),
            );
          }
        },
      ),
    );
  }

  Future<String> fetchUserProfile() async {
    final response = await http.get(
      Uri.parse('https://peanut.ifxdb.com/docs/clientcabinet/index.html/GetAccountInformation?login=$login&token=$accessToken'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}