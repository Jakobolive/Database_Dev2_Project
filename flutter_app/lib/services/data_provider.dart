import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  Map<String, dynamic>? _loggedInUser;

  Map<String, dynamic>? get loggedInUser => _loggedInUser;

  void setUser(Map<String, dynamic> userData) {
    _loggedInUser = userData;
  }
}
