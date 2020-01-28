import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> _auth(String email, String password, String segment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=AIzaSyB-dUEoCDLY3xxOUraoQt4LX9dLRw_IBrM';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final resp = json.decode(response.body);
      if (resp['error'] != null) {
        throw HttpException(resp['error']['message']);
      }

      _token = resp['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            resp['expiresIn'],
          ),
        ),
      );
      _userId = resp['localId'];
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> sigup(String email, String password) async {
    /*final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyB-dUEoCDLY3xxOUraoQt4LX9dLRw_IBrM';

    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );*/
    return _auth(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    /*final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyB-dUEoCDLY3xxOUraoQt4LX9dLRw_IBrM';
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );*/
    _auth(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLoging() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('userData')) {
      return false;
    }

    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = extractedData['expiryDate'];

    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
