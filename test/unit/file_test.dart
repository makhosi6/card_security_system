import 'package:credit_card_scanner/models/card_issuer.dart';

void main() {
  // ignore: iterable_contains_unrelated_type
  var r = CardIssuer.values.map((e) => e.name.toString()).toList();

  var input = "1234314542244565";
  print(input.split(''));
  var lr = [1, 2, 3, 4, 3, 1, 4, 5, 4, 2, 2, 4, 4, 5, 6, 5];

  for (var i = 0; i < lr.length; i++) {
    var t = lr[i];
    print('$r========> $t');
    if (t >= 3 && t <= 4) {
      print("$t  A valid CVV number has 3 to 4 digits.");
    } else {
      // print(t);
    }
  }
}
