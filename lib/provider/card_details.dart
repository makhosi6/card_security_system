import 'package:flutter/foundation.dart';

class InferCardType with ChangeNotifier {
  String _value = '';

  set value(String val) {
    print("VALUE: |$val|");

    if (val == "unknown") {
      _value = "";
    } else {
      _value = val.toUpperCase();
    }

    ///
    notifyListeners();
  }

  String get value {
    return _value;
  }
}
