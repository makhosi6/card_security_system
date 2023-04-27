import 'package:card_security_system/models/country.dart';

class Card {
  Card(
      {required this.number,
      required this.expiration,
      required this.countryCode,
      required this.holder,
      this.type = "credit"}) {
    //set uuid
    _key = number.hashCode.toString();
  }
  String number;

  late String _key;

  String expiration;

  String? type;

  String countryCode;

  Country holder;

//// clear record
  Future<bool> delete() async {
// use [_key] to delete a record from localstorage

    return _key == "";
  }

  /// update | insert record
  Future<bool> upsert() async {
// use [_key] to delete a record from localstorage

    return _key == "";
  }

  $toMap() {}
}
