import 'package:card_security_system/models/boxes.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Card extends HiveObject {
  ///
  @HiveField(1)
  String? cardNumber;

  @HiveField(2)
  String? placeHolder;

  @HiveField(3)
  String? cardType;

  @HiveField(4)
  String? expiry;

  @HiveField(5)
  String? cvvNumber;

  @HiveField(6)
  String? country;

  saveCard(Map<String, dynamic> card) {
    ///
    var box = Boxes.getCards();

    var toStore = Card()
      ..cardNumber = ""
      ..cardType = "";

    ///
    box.put(card["cardNumber"], toStore);
  }

  Future<void> deleteCard(String key) => Boxes.getCards().delete(key);

  @override
  String toString() {
    return "";
  }
}
