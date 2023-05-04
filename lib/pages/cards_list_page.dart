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
  Future<void> scanCard() async {
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

  var lipd = 0;
  @override
  void initState() {
    super.initState();
    Boxes.getCards().listenable().addListener(() {
      if (mounted) {
        setState(() {
          lipd = Boxes.getCards().keys.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${Boxes.getCards().keys.length} $lipd Bank Card Manager App"),
        actions: const [SettingsButton()],
      ),
      floatingActionButton:
          floatingActionButtonAsSpeedDial(context, scanCard: scanCard),
      body: Container(
        padding: const EdgeInsets.only(bottom: 20.0),
        constraints: const BoxConstraints(maxWidth: 400.0),
        child: ValueListenableBuilder(
            valueListenable: Boxes.getCards().listenable(),
            builder: (context, box, child) {
              return ListView.builder(
                itemCount: box.keys.length,
                itemBuilder: (context, index) {
                  return _CardListItem(
                    card: box.values.elementAt(index),
                  );
                },
              );
            }),
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
                : Border.all(color: const Color.fromARGB(255, 165, 212, 250))
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
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
              SlidableAction(
                onPressed: (_) {
                  print("onEdit ${(widget.card.cardNumber)}");
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
            //card number
            title: Text((widget.card.cardNumber ?? "NO CARD NUMBER")),

            /// type
            subtitle: Text("${widget.card.expiry}"),

            /// expiration data
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
