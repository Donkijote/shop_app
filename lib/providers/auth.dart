import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

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
}
