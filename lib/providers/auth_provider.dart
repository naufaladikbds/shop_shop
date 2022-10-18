import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_shop/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _userEmail;
  String? _token;
  DateTime? _expiryDate;
  Timer? _authTimer;

  String? get userId {
    if (_userId != null && _expiryDate!.isAfter(DateTime.now())) {
      return _userId;
    }

    return null;
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }

    return null;
  }

  Future<bool> signUp(String email, String password) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyASCk4VDEJm40D56RZXpElm7ldPAIO2RL8';

    var reqBody = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    try {
      var res = await http.post(
        Uri.parse(url),
        body: jsonEncode(reqBody),
      );
      var resBody = jsonDecode(res.body);
      Map? resError = resBody['error'];
      print('RESSBODY ISSS:::');
      print(resBody);

      if (resError != null) {
        int? resErrorCode = resBody['error']['code'];
        String? resErrorMessage = resBody['error']['message'];
        throw HttpException(message: '$resErrorCode : $resErrorMessage');
      }

      notifyListeners();

      return true;
    } on HttpException catch (e) {
      print(e);
      rethrow;
    } catch (e) {
      throw HttpException(message: 'Please check your internet connection');
    }
  }

  void logout() {
    _token = null;
    _userEmail = null;
    _userId = null;
    _expiryDate = null;
    _authTimer == null;

    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    int secondsToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;

    print('seconds to expiry: $secondsToExpiry');
    _authTimer = Timer(
      Duration(seconds: secondsToExpiry),
      logout,
    );
  }

  Future<void> login(String email, String password) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyASCk4VDEJm40D56RZXpElm7ldPAIO2RL8';

    var reqBody = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    try {
      var res = await http.post(
        Uri.parse(url),
        body: jsonEncode(reqBody),
      );

      var resBody = jsonDecode(res.body);
      Map? resError = resBody['error'];
      print(resBody);

      if (resError != null) {
        int? resErrorCode = resBody['error']['code'];
        String? resErrorMessage = resBody['error']['message'];
        throw HttpException(message: '$resErrorCode : $resErrorMessage');
      }

      _userId = resBody['localId'];
      _userEmail = resBody['email'];
      _token = resBody['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(resBody['expiresIn']),
        ),
      );
      autoLogout();

      notifyListeners();
    } on HttpException catch (e) {
      String error = e.toString();
      if (error.contains('EMAIL_NOT_FOUND')) {
        throw HttpException(
            message: 'User with that email address does not exist');
      } else if (error.contains('INVALID_PASSWORD')) {
        throw HttpException(message: 'Invalid password');
      } else if (error.contains('USER_DISABLED')) {
        throw HttpException(message: 'User has been disabled by admin');
      } else if (error.contains('INVALID_EMAIL')) {
        throw HttpException(message: 'Invalid email address');
      } else {
        throw HttpException(message: 'Something happened');
      }
    } catch (e) {
      throw HttpException(message: 'Please check your internet connection');
    }
  }
}
