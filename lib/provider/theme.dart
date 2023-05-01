import 'package:flutter/foundation.dart';
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

var defaultTheme =
    ThemeData(useMaterial3: TargetPlatform.iOS == defaultTargetPlatform);

var lightTheme =
    ThemeData.light(useMaterial3: TargetPlatform.iOS == defaultTargetPlatform);

var darkTheme =
    ThemeData.dark(useMaterial3: TargetPlatform.iOS == defaultTargetPlatform);
