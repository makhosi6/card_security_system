import 'package:card_security_system/data/countries.dart';
import 'package:card_security_system/models/boxes.dart';
import 'package:card_security_system/models/card.dart';
import 'package:card_security_system/models/country.dart';
import 'package:card_security_system/pages/create_edit_card_page.dart';
import 'package:card_security_system/utils/helpers.dart';
import 'package:card_security_system/widgets/fab_helpers.dart';
import 'package:card_security_system/widgets/settings_btn.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CardListPage extends StatefulWidget {
  const CardListPage({super.key});

  @override
  State<CardListPage> createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage>
    with CustomFloatingActionButton {
  ///
  CardDetails? _cardDetails;

  ///
  Future<void> scanCard(BuildContext context) async {
    /// no support for web card scanner
    if (kIsWeb) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..clearMaterialBanners()
        ..showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: const Text(
              "No web support for card scanner",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        );

      return;
    }

    ///open a card scanner
    var cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);

    if (!mounted) return;

    setState(() {
      _cardDetails = cardDetails;
    });

    /// Then navigate to the edit/create page
    if (cardDetails != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CreateEditCard(
            key: UniqueKey(),
            cardDetails: cardDetails,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Card Manager App"),
        actions: const [SettingsButton()],
      ),
      floatingActionButton:
          floatingActionButtonAsSpeedDial(context, scanCard: scanCard),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(bottom: 20.0),
          constraints: const BoxConstraints(maxWidth: 400.0),
          child: ValueListenableBuilder(
              valueListenable: Boxes.getCards().listenable(),
              builder: (context, box, child) {
                /// sort the cards list by [lastUpdate] timestamp
                var cards = box.values.toList()
                  ..sort((a, b) => (b.lastUpdate ?? 0) - (a.lastUpdate ?? 0));

                /// placeholder card if [cards] is empty
                if (cards.isEmpty) {
                  cards = [
                    BankCard()
                      ..cardHolder = "Placeholder Card"
                      ..cardNumber = "0000000000000000"
                      ..country = "ZA"
                      ..cvvNumber = "234"
                      ..expiry = "01/23"
                      ..lastUpdate = DateTime.now().millisecondsSinceEpoch
                  ];
                }

                ///
                return ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return _CardListItem(
                      card: cards.elementAt(index),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _CardListItem extends StatefulWidget {
  final BankCard card;
  const _CardListItem({required this.card});

  @override
  State<_CardListItem> createState() => __CardListItemState();
}

class __CardListItemState extends State<_CardListItem> {
  @override
  Widget build(BuildContext context) {
    //
    var isAndroid = TargetPlatform.android == defaultTargetPlatform;
    var isDark = Theme.of(context).brightness == Brightness.dark;
    var country = Country(
        code: widget.card.country ?? '',
        name: countries[widget.card.country].toString());

    ///
    return Container(
      margin: isAndroid
          ? const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0)
          : null,
      decoration: BoxDecoration(
        color: isAndroid && isDark ? const Color(0xFF424242) : null,
        borderRadius: isAndroid ? BorderRadius.circular(10.0) : null,
        border: isAndroid
            ? isDark
                ? Border.all(color: const Color.fromARGB(255, 143, 137, 137))
                : Border.all(color: const Color.fromARGB(168, 62, 65, 255))
            : null,
      ),
      clipBehavior: Clip.hardEdge,
      child: Card(
        elevation: isAndroid ? 0 : null,
        child: Slidable(
          key: UniqueKey(),
          endActionPane: ActionPane(
            dragDismissible: false,
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(onDismissed: () {}),
            children: [
              SlidableAction(
                onPressed: (_) {
                  print("onDelete  ${widget.card.cardNumber}");

                  if (widget.card.cardHolder == "Placeholder Card") {
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(const SnackBar(
                        backgroundColor: Color.fromARGB(255, 67, 67, 67),
                        content: Text(
                          "You can't edit or delete a placeholder card",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ));
                    return;
                  }

                  /// delete card
                  widget.card.deleteCard();

                  /// show a snackbar confirmation to the user

                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(
                      backgroundColor: Colors.redAccent[400],
                      content: Text(
                        "Card '${widget.card.cardNumber}' was deleted successfully",
                        textAlign: TextAlign.center,
                      ),
                    ));
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
              SlidableAction(
                onPressed: (_) {
                  print("onEdit ${(widget.card.cardNumber)}");

                  ///
                  if (widget.card.cardHolder == "Placeholder Card") {
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        const SnackBar(
                          backgroundColor: Color.fromARGB(255, 67, 67, 67),
                          content: Text(
                            "You can't edit or delete a placeholder card",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );

                    return;
                  }

                  /// Set this card editing mode
                  widget.card.setToEditingMode();

                  ///
                  CardDetails cardDetails = CardDetails.fromMap({
                    "cardNumber": widget.card.cardNumber!,
                    "cardHolderName": widget.card.cardHolder!,
                    "expiryDate": widget.card.expiry!,
                    // "_cardIssuer":
                  });

                  /// Navigate to the Edit screen/page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateEditCard(
                        key: UniqueKey(),
                        cardDetails: cardDetails,
                      ),
                    ),
                  );
                },
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),

          // The child of the Slidable is what the user sees when the
          // component is not dragged.
          child: ListTile(
            isThreeLine: true,
            //card number
            title: Text((widget.card.cardNumber ?? "NO CARD NUMBER")),

            /// type
            subtitle: SizedBox(
              height: 40.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${widget.card.expiry}"),
                  Text(
                    "${widget.card.cardHolder}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),

            /// expiration data
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  country.flag,
                  style: const TextStyle(fontSize: 22.0),
                ),
                Text(
                  widget.card.cardType ?? "ISSUER",
                ),
              ],
            ),
            dense: false,
          ),
        ),
      ),
    );
  }
}

var issuers = CardIssuer.values.map((e) => e.name).toList();
// var list = List.generate(
//     20,
//     (index) => CardDetails.fromMap({
//           'cardNumber': "${Random().nextInt(9018) + 1000}890278230972",
//           'cardIssuer': issuers[Random().nextInt(13)],
//           'cardHolderName': "J Wick",
//           'expiryDate': "$index/30",
//         }))
//   ..sort((a, b) => int.parse(b.cardNumber) - int.parse(a.cardNumber));
