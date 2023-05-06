import 'dart:convert';
import 'package:credit_card_scanner/models/card_scan_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// is it a iOS device
var isApple = TargetPlatform.iOS == defaultTargetPlatform;

/// default theme
var defaultTheme = ThemeData(
    colorScheme:
        isApple ? ColorScheme.fromSwatch(primarySwatch: Colors.indigo) : null,
    primarySwatch: !isApple ? Colors.indigo : null,
    primaryColor: !isApple ? Colors.indigo : null,
    useMaterial3: isApple);

/// default light theme
var lightTheme = ThemeData.light(useMaterial3: isApple).copyWith(
    colorScheme:
        !isApple ? ColorScheme.fromSwatch(primarySwatch: Colors.indigo) : null,
    // primarySwatch: isApple ? Colors.indigo : null,
    primaryColor: !isApple ? Colors.indigo : null,
    useMaterial3: isApple);

/// default dark theme
var darkTheme = ThemeData.dark(useMaterial3: isApple);

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

/// Slipt bank card number for readability
/// - 4by4
String splitNumber(String val) {
  if (val.length < 4) return val;

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

///
CardScanOptions scanOptions = const CardScanOptions(
  scanExpiryDate: true,
  scanCardHolderName: true,
  enableDebugLogs: true,
  validCardsToScanBeforeFinishingScan: 5,
  considerPastDatesInExpiryDateScan: true,
  // enableLuhnCheck: true,
  possibleCardHolderNamePositions: [
    CardHolderNameScanPosition.aboveCardNumber,
    CardHolderNameScanPosition.belowCardNumber,
  ],
);

MaterialBanner editOnlyMaterialBanner(BuildContext context) => MaterialBanner(
      backgroundColor: Colors.grey,
      content: const Text('You can\'t edit the card number.'),
      leading: const Icon(Icons.edit_off_rounded),
      actions: <Widget>[
        TextButton(
          onPressed: () {},
          child: const Text(''),
        ),
      ],
    );
