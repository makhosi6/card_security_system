import 'package:flutter/material.dart';

class UserTheme with ChangeNotifier {
  UserTheme();

  ThemeData? _value;

  set value(ThemeData? theme) {
    _value = theme;
    notifyListeners();
  }

  ThemeData? get value {
    return _value;
  }
}
