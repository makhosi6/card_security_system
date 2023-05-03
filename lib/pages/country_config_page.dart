// import 'package:card_security_system/data/countries.dart';
import 'package:card_security_system/data/countries.dart';
import 'package:card_security_system/models/country.dart';
import 'package:card_security_system/widgets/selectable_container.dart';
import 'package:card_security_system/widgets/settings_btn.dart';
import 'package:flutter/material.dart';

class ConfigCountriesPage extends StatefulWidget {
  static const String routeName = 'config-banned-countries';
  const ConfigCountriesPage({super.key});

  @override
  State<ConfigCountriesPage> createState() => _ConfigCountriesPageState();
}

class _ConfigCountriesPageState extends State<ConfigCountriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Banned Countries"),
        actions: const [SettingsButton()],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400.0),
          padding: const EdgeInsets.only(top: 20.0),
          child: GridView.count(
            key: const Key("countries_grid"),
            crossAxisCount: 3,
            children: countries.keys.map(
              (key) {
                return _SelectableCountry(
                  key: Key("country_$key"),
                  country: Country(code: key, name: "${countries[key]}"),
                  isCountryBanned: key.startsWith('A'),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}

class _SelectableCountry extends StatefulWidget {
  final Country country;

  final bool isCountryBanned;

  const _SelectableCountry(
      {Key? key, required this.country, required this.isCountryBanned})
      : super(key: key);

  @override
  State<_SelectableCountry> createState() => __SelectableCountryState();
}

class __SelectableCountryState extends State<_SelectableCountry> {
  ///
  var isSelected = false;

  ///
  @override
  void initState() {
    super.initState();

    /// set to current state
    isSelected = widget.isCountryBanned;
  }

  @override
  Widget build(BuildContext context) {
    ///
    var textStyles = Theme.of(context).textTheme;
    var isDark = Theme.of(context).brightness == Brightness.dark;
    var color = !isDark ? Colors.black : null;

    ///
    return SelectableContainer(
      key: UniqueKey(),
      onValueChanged: (newValue) {
        print("SET SELECTED COUNTRY:  $newValue AS ${widget.country.code}");
        setState(() {
          isSelected = newValue;
        });
      },
      unselectedBorderColor: const Color.fromARGB(255, 143, 137, 137),
      selectedBorderColor: Colors.red[700],
      iconColor: const Color.fromRGBO(211, 47, 47, 1),
      selectedBackgroundColor: Colors.red[50],
      selectedBackgroundColorIcon: Colors.red[50],
      selectedBorderColorIcon: const Color.fromRGBO(211, 47, 47, 1),
      selected: isSelected,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.country.code},",
            style: textStyles.headlineSmall
                ?.copyWith(color: isSelected ? Colors.red[700] : color),
          ),
          SizedBox(
            height: 50.0,
            width: 100.0,
            child: Text(
              widget.country.name,
              style: textStyles.bodyLarge
                  ?.copyWith(color: isSelected ? Colors.red[700] : color),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
