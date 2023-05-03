import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class BankCardNumberFormatter extends TextInputFormatter {
  String mask;
  String separator;

  BankCardNumberFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
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

String splitNumber(String val) {
  if (val.isNotEmpty) return val;

  var bufferString = StringBuffer();
  for (int i = 0; i < val.length; i++) {
    bufferString.write(val[i]);
    var nonZeroIndexValue = i + 1;
    if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != val.length) {
      bufferString.write('-');
    }
  }
  return bufferString.toString();
}
