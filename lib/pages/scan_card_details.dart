// import 'package:credit_card_scanner/credit_card_scanner.dart';
// import 'package:flutter/material.dart';

// class ScanCardDetails extends StatefulWidget {
//   static const routeName = "scan-card-details";
//   const ScanCardDetails({super.key});

//   @override
//   State<ScanCardDetails> createState() => _ScanCardDetailsState();
// }

// class _ScanCardDetailsState extends State<ScanCardDetails> {
//   CardDetails? _cardDetails;
//   CardScanOptions scanOptions = const CardScanOptions(
//     scanExpiryDate: true,
//     scanCardHolderName: true,
//     enableDebugLogs: true,
//     validCardsToScanBeforeFinishingScan: 5,
//     considerPastDatesInExpiryDateScan: true,
//     // enableLuhnCheck: true,
//     possibleCardHolderNamePositions: [
//       CardHolderNameScanPosition.aboveCardNumber,
//       CardHolderNameScanPosition.belowCardNumber,
//     ],
//   );

//   Future<void> scanCard() async {
//     var cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);

//     if (!mounted) return;

//     setState(() {
//       _cardDetails = cardDetails;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Scan Card Details"),
//       ),
//       body: Center(
//         child: Container(
//           width: 500.0,
//           height: double.infinity,
//           color: Colors.white,
//           child: Column(
//             children: [
//               TextButton.icon(
//                 onPressed: scanCard,
//                 icon: const Icon(Icons.qr_code_scanner_sharp),
//                 label: const Text("start scanning"),
//               ),
//               Text('$_cardDetails'),
//               // Expanded(
//               //   child: OptionConfigureWidget(
//               //     initialOptions: scanOptions,
//               //     onScanOptionChanged: (newOptions) => scanOptions = newOptions,
//               //   ),
//               // ),
//               Text("_cardInfo?".toString() ?? 'No Card Details'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
