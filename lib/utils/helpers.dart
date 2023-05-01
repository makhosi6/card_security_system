import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class BankCardNumberFormatter extends TextInputFormatter {
  String splitNumber(String val) {
    if (val.length <= 4) return val;

    var bufferString = StringBuffer();
    for (int i = 0; i < val.length; i++) {
      bufferString.write(val[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != val.length) {
        bufferString.write(' ');
      }
    }
    return bufferString.toString();
  }

  var sample = 'XXXX-XXXX-XXXX-XXXX'.toLowerCase();

  String separator = "-";
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > sample.length) return oldValue;

        if (newValue.text.length < sample.length &&
            sample[newValue.text.length - 1] == separator) {
          print("${oldValue.text}$separator${newValue.text}");
          var newTxt = splitNumber(newValue.text);
          return TextEditingValue(
              text: newTxt,
              selection: TextSelection.collapsed(offset: newTxt.length));
        }
      }
    }

    return newValue;
  }
}

/// [cardNumber] first 6 digits of a credit card number
Future<Map<String, dynamic>> getIssuingCountry(String cardNumber) async {
  try {
    var request = http.Request(
        'GET', Uri.parse('https://lookup.binlist.net/$cardNumber'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      print("${response.reasonPhrase}");
      return {};
    }
  } catch (e) {
    print(e.toString());
    return {};
  }
}
