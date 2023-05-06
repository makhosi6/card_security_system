import 'package:card_security_system/models/boxes.dart';
import 'package:card_security_system/models/card.dart';
import 'package:card_security_system/models/country.dart';
import 'package:card_security_system/provider/card_details.dart';
import 'package:card_security_system/utils/helpers.dart';
import 'package:card_security_system/widgets/settings_btn.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class CreateEditCard extends StatefulWidget {
  /// Named of the page/route
  static const routeName = "create-edit-card-details";

  /// (Optional) Initial card details passed from the previous page
  final CardDetails? cardDetails;

  /// a page that contains the form used to create or edit the card details
  const CreateEditCard({super.key, this.cardDetails});

  @override
  State<CreateEditCard> createState() => _CreateEditCardState();
}

class _CreateEditCardState extends State<CreateEditCard> {
  /// value received from the child input field [Card number], as a String because [TextFormField] returns Strings only
  String cardNumber = "";

  /// value received from the child input field [Cardholder Name], as a String because [TextFormField] returns Strings only
// ignore: prefer_final_fields
  String cardHolder = "";

  /// value received from the child input field [Card type], as a String because [TextFormField] returns Strings only
  // ignore: prefer_final_fields
  String cardType = "";

  /// value received from the child input field [CVV number], as a String because [TextFormField] returns Strings only
  // ignore: prefer_final_fields
  String cvvNumber = "";
  // ignore: prefer_final_fields
  String cardExpiry = "";

  /// a [Country] object, received from the [binlist.net] API via the [fetchIssuingCountry] function, calculated using the first 6 digits of a credit card number
  /// - Requests are throttled at 10 per minute
  Country? country;

  /// Get the issuing country using the first  6 digits of a bank card number
  /// - powered by the [binlist.net] API
  void fetchIssuingCountry() async {
    try {
      var issuingCountry =
          cardNumber.isNotEmpty ? await getIssuingCountry(cardNumber) : null;

      if (issuingCountry != null && issuingCountry.isNotEmpty && mounted) {
        setState(() {
          country = Country(
              name: issuingCountry["country"]["name"],
              code: issuingCountry["country"]["alpha2"]);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    /// on edit mode, get the stored record
    var card = Boxes.getCards().get(cardNumber);

    /// next tick callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// show edit only banner
      if (card?.editing == true) {
        ScaffoldMessenger.of(context)
            .showMaterialBanner(editOnlyMaterialBanner(context));
      }
    });

    ///
    return WillPopScope(
      onWillPop: () async {
        try {
          /// clear stale data as we dispose the page
          Provider.of<InferCardType>(context, listen: false).value = "";
          //close the Snackbar/MaterialBanner
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        } catch (e) {
          debugPrint(e.toString());
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create or Update Card"),
          actions: const [SettingsButton()],
        ),
        body: SizedBox(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        /// card number input field
                        _NamedTextInputWidget(
                          setValue: (String value) {
                            /// wen done editing update values

                            if (mounted) {
                              setState(() {
                                cardNumber = value.replaceAll("-", "");
                              });
                            }

                            ///and fetch issuing country, if necessary
                            Future.microtask(fetchIssuingCountry);
                          },
                          readOnly: card?.editing == true,
                          type: TextInputType.text,
                          initialValue: widget.cardDetails?.cardNumber,
                          hint: 'Type a valid Card Number',
                          label: 'Card Number',
                          inputLimit: 19, // (4*4) + 3
                        ),

                        /// cardholder name input field
                        _NamedTextInputWidget(
                          setValue: (String value) {
                            if (mounted) {
                              setState(() {
                                cardHolder = value;
                              });
                            }
                          },
                          hint: 'Type Cardholder Name',
                          label: 'Cardholder Name',
                          initialValue: widget.cardDetails?.cardHolderName,
                          type: TextInputType.text,
                        ),

                        /// Card type input field, listens for changes from the [InferCardType] provider and acts accordingly
                        ValueListenableBuilder<String?>(
                          valueListenable: ValueNotifier(
                              Provider.of<InferCardType>(context).value),
                          builder: (context, value, child) {
                            return _NamedTextInputWidget(
                              key: Key("$value"),
                              readOnly: true,
                              setValue: (String value) {
                                if (mounted) {
                                  setState(() {
                                    cardType = value;
                                  });
                                }
                              },
                              hint: 'Type a Card type, i.e, Visa',
                              label: 'Card Type (read only)',
                              initialValue: value,
                              type: TextInputType.text,
                            );
                          },
                        ),

                        /// Card expiryDate input field,
                        _NamedTextInputWidget(
                            setValue: (String value) {
                              if (mounted) {
                                setState(() {
                                  cardExpiry = value;
                                });
                              }
                            },
                            type: TextInputType.text,
                            hint: 'Expiry Date, i.e, 12/30',
                            label: 'Expiry Date',
                            initialValue: widget.cardDetails?.expiryDate,
                            inputLimit: 5),

                        /// Card CVV input field,
                        _NamedTextInputWidget(
                            setValue: (String value) {
                              if (mounted) {
                                setState(() {
                                  cvvNumber = value;
                                });
                              }
                            },
                            hint: 'Type a valid CVV',
                            initialValue: "",
                            label: 'CVV Number',
                            inputLimit: 4 // 3 to 4,
                            ),

                        /// issuing country, powered by the [binlist.net] API
                        Container(
                          width: 400.0,
                          padding: const EdgeInsets.only(bottom: 10),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 270.0,
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Issuing Country (read only)',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          key: Key('input-label'),
                                        ),
                                      ),
                                      Text.rich(TextSpan(children: [
                                        TextSpan(
                                          text: country != null
                                              ? "${country?.name}, "
                                              : 'Country Name, ',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        TextSpan(
                                          text: country != null
                                              ? "${country?.code} ${country?.flag}"
                                              : '## 🏴',
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        )
                                      ])),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, top: 10),
                                  child: Icon(
                                    country != null
                                        ? Icons.check_circle
                                        : Icons.error,
                                    color: country != null
                                        ? Colors.greenAccent[400]
                                        : Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        ///divider
                        const SizedBox(width: 400.0, child: Divider()),

                        ///Submit button
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextButton.icon(
                            icon: const Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              /// check if form is filled correctly
                              if (_formKey.currentState!.validate()) {
                                /// dismiss the keyboard
                                FocusManager.instance.primaryFocus?.unfocus();

                                /// if the form is validated check if the card exits before saving the data
                                /// and if the [editing] value is true
                                if (Boxes.getCards().get(cardNumber) != null &&
                                    Boxes.getCards().get(cardNumber)?.editing !=
                                        true) {
                                  ScaffoldMessenger.of(context)
                                    ..clearSnackBars()
                                    ..clearMaterialBanners()
                                    ..showSnackBar(SnackBar(
                                      backgroundColor: Colors.red[400],
                                      content: Text(
                                        'Card $cardNumber exists already',
                                        textAlign: TextAlign.center,
                                      ),
                                    ));

                                  return;
                                }

                                /// Check if the country is banned
                                ///
                                var bannedCountries =
                                    Boxes.getBannedCountries().values.toList();

                                if (bannedCountries
                                    .where((e) => e.code == country?.code)
                                    .isNotEmpty) {
                                  ScaffoldMessenger.of(context)
                                    ..clearSnackBars()
                                    ..clearMaterialBanners()
                                    ..showSnackBar(SnackBar(
                                      backgroundColor: Colors.red[400],
                                      content: Text(
                                        "'${country?.name}'(${country?.code}) is banned country'",
                                        textAlign: TextAlign.center,
                                      ),
                                    ));

                                  return;
                                }

                                ///data as a Map
                                var data = {
                                  "cardNumber": cardNumber,
                                  "cardHolder": cardHolder,
                                  "cardType": cardType,
                                  "expiry": cardExpiry,
                                  "cvvNumber": cvvNumber,
                                  "country": country?.code
                                };

                                /// save store the data
                                BankCard().saveCard(data);
                                // and clear the form
                                _formKey.currentState
                                  ?..save()
                                  ..reset();

                                /// show a snackbar confirmation to the user

                                ScaffoldMessenger.of(context)
                                  ..clearMaterialBanners()
                                  ..clearSnackBars()
                                  ..showSnackBar(SnackBar(
                                    backgroundColor: Colors.greenAccent[400],
                                    content: const Text(
                                      'A bank card has been added/updated successfully!',
                                      textAlign: TextAlign.center,
                                    ),
                                  ));
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.only(
                                  top: 5.0,
                                  bottom: 5.0,
                                  left: 22.0,
                                  right: 22.0,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _NamedTextInputWidget extends StatefulWidget {
  /// Use this callback/param to update the parent, push the value up the tree
  final void Function(String value) setValue;

  /// Displayed name of the ipt field
  final String? label;

  /// Hint or helper text OR description
  final String? hint;

  /// data type, text or number
  final TextInputType? type;

  /// Expected maximum number of digits or letter
  final int? inputLimit;

  /// initial value of the field passed from the parent widget
  final dynamic initialValue;

  /// is it a read oly input field
  final bool? readOnly;

  const _NamedTextInputWidget({
    Key? key,
    required this.setValue,
    required this.label,
    required this.hint,
    this.inputLimit,
    this.type,
    this.initialValue,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<_NamedTextInputWidget> createState() => _NamedTextInputWidgetState();
}

class _NamedTextInputWidgetState extends State<_NamedTextInputWidget> {
  ///
  TextEditingController inputController = TextEditingController();

  ///
  final FocusNode focusNode = FocusNode();

  /// is the field value a valid input
  var isValidated = false;

  ///
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.addListener(() {
        /// on focus event, update the parent, push the value up the tree
        if (widget.label == 'Card Number') {
          widget.setValue(inputController.value.text);
        }
      });

      /// is [widget.initialValue] a valid value
      isValidated = validate(widget.initialValue) == null;

      /// set initial value if available
      if ((widget.initialValue != null && widget.initialValue != "")) {
        inputController.text = "${widget.initialValue}";

        if (widget.label == 'Card Number') {
          /// And
          ///  - broadcast type inferred card type using the card number
          var types = detectCCType(widget.initialValue);

          Provider.of<InferCardType>(context, listen: false).value = types.name;
        }

        ///Check the value, and then,
        /// update the check icon to a green color for user confirmation
        isValidated = validate("${widget.initialValue}") == null;
      }
    });
  }

  ///
  Future<void> scanCard() async {
    var cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);

    if (!mounted) return;

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

  ///
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      width: 400.0,
      child: TextFormField(
        key: Key('${widget.label.hashCode}-input-field'),
        focusNode: focusNode,
        autofocus: true,
        readOnly: widget.readOnly ?? false,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintMaxLines: 1,
          errorMaxLines: 1,
          constraints: const BoxConstraints(maxWidth: 400.0),
          hintText: widget.hint ?? "Please type...",
          labelText: widget.label,
          // prefixIcon: (widget.label == 'Card Number')
          //     ? InkWell(
          //         onTap: scanCard,
          //         child: const Icon(Icons.qr_code_scanner_outlined))
          //     : null,
          suffixIcon: Icon(
            isValidated ? Icons.check_circle : Icons.error,
            color: isValidated ? Colors.greenAccent[400] : Colors.grey,
          ),
          border: const OutlineInputBorder(),
        ),
        controller: inputController,
        onChanged: (input) {
          var value = input.replaceAll("-", "");

          /// onChange
          ///  - broAdcast type inferred card type using the card number
          if (value.isNotEmpty && widget.label == 'Card Number') {
            var types = detectCCType(value);

            Provider.of<InferCardType>(context, listen: false).value =
                types.name;
          }

          ///Check the value, and then,
          /// update the check icon to a green color for user confirmation
          setState(() {
            isValidated = validate(value) == null;
          });
        },
        keyboardType: widget.type ?? TextInputType.number,
        inputFormatters: [
          if (widget.type == TextInputType.number || widget.type == null)
            FilteringTextInputFormatter.digitsOnly,
          // : FilteringTextInputFormatter.allow(r'[a-zA-Z]'),
          LengthLimitingTextInputFormatter(widget.inputLimit),

          /// Formatter for the card number only
          /// - separate card number by 4*4 for readability
          /// - and deny letters
          if (widget.label == 'Card Number')
            BankCardNumberFormatter(
              mask: 'xxxx-xxxx-xxxx-xxxx',
              separator: '-',
            ),
          if (widget.label == 'Card Number')
            FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')),
        ],
        validator: validate,
      ),
    );
  }

  /// Check if the [value] is valid
  /// - returns [null] is its valid
  /// - a string if it's not valid
  String? validate(String? value) {
    if (value != null && value.isNotEmpty) widget.setValue(value);
    if (value == null || value.isEmpty) {
      /// hint for the card Type | Card Issuer field
      if (widget.label == 'Card Type (read only)') {
        return "The provided card number is not from a valid card issuer, please type a correct card number";
      }
      return widget.hint;
    }

    /// validation for each type
    switch (widget.label) {
      case 'Card Number':
        {
          /// must have more than 16 digits
          if (value.length < 16) {
            return "A valid card number has more than 16 digits.";
          }

          /// must have less than 19 digits
          if (value.length > 19) {
            return "A valid card number has a maximum of 19 digits.";
          }
          //
          break;
        }
      case 'Cardholder Name':
        {
          /// must have more than 2 letters
          if (value.length < 2) {
            return "A valid name has more than 2 letters.";
          }
          break;
        }
      case 'Card Type (read only)':
        {
          /// Valid card issues, 'unknown' is not a valid issue
          var issuers = CardIssuer.values.map((e) => e.name).toList()
            ..remove("unknown");

          /// must be one of the issuers

          if (!issuers.contains(value.toLowerCase())) {
            return "The provided value is not a valid issuer";
          }
          //
          break;
        }
      case 'CVV Number':
        {
          /// must have between 3 and 4 digits
          if (value.trim().length != 3 && value.trim().length != 4) {
            return "A valid CVV number has 3 to 4 digits.";
          }
          break;
        }

      default:
        {
          debugPrint("default");
        }
    }

    /// update the parent, push the value up the tree
    widget.setValue(value);

    /// at this the field value is valid
    setState(() {
      isValidated = true;
    });

    /// then return null
    return null;
  }

  @override
  void dispose() {
    focusNode.dispose();
    inputController.dispose();
    super.dispose();
  }
}
