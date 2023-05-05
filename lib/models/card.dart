import 'package:card_security_system/models/boxes.dart';
import 'package:hive/hive.dart';

part 'card.g.dart';

@HiveType(typeId: 1)
class BankCard extends HiveObject {
  ///
  @HiveField(1)
  String? cardNumber;

  @HiveField(2)
  String? cardHolder;

  @HiveField(3)
  String? cardType;

  @HiveField(4)
  String? expiry;

  @HiveField(5)
  String? cvvNumber;

  @HiveField(6)
  String? country;

  @HiveField(7)
  int? lastUpdate;

  saveCard(Map<String, dynamic> card) {
    ///
    var box = Boxes.getCards();

    var toStore = BankCard()
      ..cardNumber = card["cardNumber"]
      ..cardHolder = card['cardHolder']
      ..cardType = card["cardType"]
      ..expiry = card["expiry"]
      ..cvvNumber = card["cvvNumber"]
      ..country = card["country"]
      ..lastUpdate = DateTime.now().millisecondsSinceEpoch;

    ///
    box.put(card["cardNumber"], toStore);
  }

  Future<void> deleteCard(String key) => Boxes.getCards().delete(key);

  @override
  String toString() {
    return "";
  }
}
