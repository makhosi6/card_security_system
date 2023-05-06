import 'package:flutter/foundation.dart';

class InferCardType with ChangeNotifier {
  String _value = '';

  set value(String val) {
    if (val == "unknown") {
      _value = "";
    } else {
      _value = val.toUpperCase();
    }

    /// broadcast changes
    notifyListeners();
  }

  String get value {
    return _value;
  }
}
