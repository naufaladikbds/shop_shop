import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String userId = '';
  String token = '';
  DateTime expiryDate = DateTime.now();

  Future<void> signUp(String email, String password) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyASCk4VDEJm40D56RZXpElm7ldPAIO2RL8';

    var reqBody = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    var response = await http.post(Uri.parse(url), body: jsonEncode(reqBody));

    print(response.body);
  }
}
