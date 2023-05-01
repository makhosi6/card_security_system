import 'package:card_security_system/models/country.dart';
import 'package:card_security_system/provider/card_details.dart';
import 'package:card_security_system/utils/helpers.dart';
import 'package:credit_card_scanner/models/card_details.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class CreateEditCard extends StatefulWidget {
  static const routeName = "create-edit-card-details";

  final CardDetails? cardDetails;

  const CreateEditCard({super.key, this.cardDetails});

  @override
  State<CreateEditCard> createState() => _CreateEditCardState();
}

class _CreateEditCardState extends State<CreateEditCard> {
  String _cardNumber = "";

  Country? country;

  void fetchIssuingCountry() async {
    print("Update country");
    var issuingCountry =
        _cardNumber.isEmpty ? null : await getIssuingCountry(_cardNumber);

    if (issuingCountry != null && issuingCountry.isNotEmpty && mounted) {
      print("Update country");
      setState(() {
        country = Country(
            name: issuingCountry["country"]["name"],
            code: issuingCountry["country"]["alpha2"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create or Update Card"),
      ),
      body: Container(
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
                              _cardNumber = value;
                            });
                          }

                          ///and fetch issuing country, if necessary
                          Future.microtask(fetchIssuingCountry);
                        },
                        initialValue: "",
                        hint: 'Type a valid Card Number',
                        label: 'Card Number',
                        inputLimit: 19, // (4*4) + 3
                      ),

                      /// cardholder name input field
                      _NamedTextInputWidget(
                        setValue: (String value) {},
                        hint: 'Type Cardholder Name',
                        label: 'Cardholder Name',
                        initialValue: "Bob Marley",
                        type: TextInputType.name,
                      ),

                      /// card type input field
                      ValueListenableBuilder<String?>(
                        valueListenable: ValueNotifier(
                            Provider.of<InferCardType>(context).value),
                        builder: (context, value, child) {
                          return _NamedTextInputWidget(
                            key: Key("$value"),
                            readOnly: true,
                            setValue: (String value) {},
                            hint: 'Type a Card type, i.e, Visa',
                            label: 'Card Type (read only)',
                            initialValue: value,
                            type: TextInputType.text,
                          );
                        },
                      ),

                      /// Card CVV input field
                      _NamedTextInputWidget(
                          setValue: (String value) {},
                          hint: 'Type a valid CVV',
                          label: 'CVV Number',
                          inputLimit: 4 // 3 to 4,
                          ),

                      /// issuing country
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
                              SizedBox(
                                width: 270.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'Issuing Country',
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
                                            ? "${country?.code} ${country?.flag()}"
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
                                    left: 20.0, right: 20.0),
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
                      const Divider(),

                      ///Submit button
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextButton.icon(
                          icon: const Icon(Icons.send),
                          label: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                            }
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  top: 5.0,
                                  bottom: 5.0,
                                  left: 22.0,
                                  right: 22.0),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _NamedTextInputWidget extends StatefulWidget {
  void Function(String value) setValue;

  String? label;

  String? hint;

  TextInputType? type;

  int? inputLimit;

  dynamic initialValue;

  bool? readOnly;

  _NamedTextInputWidget({
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

  ///
  @override
  void initState() {
    super.initState();
    print("SET TO ${widget.initialValue}");

    /// set initial value if available
    if (widget.initialValue != null) inputController.text = widget.initialValue;
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

        ///
        decoration: InputDecoration(
          hintMaxLines: 1,
          errorMaxLines: 1,
          constraints: const BoxConstraints(maxWidth: 400.0),
          hintText: widget.hint ?? "Please type...",
          // icon: const Icon(Icons.favorite),
          labelText: widget.label,
          helperText: 'Helper text',
          suffixIcon: const Icon(
            Icons.check_circle,
          ),
          border: const OutlineInputBorder(),
        ),

        ///
        controller: inputController,
        onSaved: (input) {},
        onTapOutside: (_) {
          print("EDIT COMPLETE");
          if (widget.label == 'Card Number') {
            widget.setValue(inputController.value.text);
          }
        },
        onChanged: (value) {
          print(value.isNotEmpty);

          /// onChange
          ///  - brodcast type inferred card type using the card number
          if (value.isNotEmpty && widget.label == 'Card Number') {
            var types = detectCCType(value);

            Provider.of<InferCardType>(context, listen: false).value =
                types.name;
          }
        },

        keyboardType: widget.type ?? TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          (widget.type == TextInputType.number || widget.type == null)
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
          LengthLimitingTextInputFormatter(widget.inputLimit)
        ],
        validator: (value) {
          if (kDebugMode) {
            print("Value From ${widget.label} | $value");
          }
          if (value == null || value.isEmpty) {
            return widget.hint;
          }

          widget.setValue(value);
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    inputController.dispose();
    super.dispose();
  }
}
