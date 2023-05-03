import 'package:flutter/material.dart';
import 'package:selectable_container/selectable_container.dart';

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
      ),
      body: Center(
        child: Container(
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(15, (index) {
                return _SelectableCountry(
                  key: Key("$index"),
                );
              }),
            )),
      ),
    );
  }
}

class _SelectableCountry extends StatefulWidget {
  const _SelectableCountry({Key? key}) : super(key: key);

  @override
  State<_SelectableCountry> createState() => __SelectableCountryState();
}

class __SelectableCountryState extends State<_SelectableCountry> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    var textStyles = Theme.of(context).textTheme;
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return SelectableContainer(
      onValueChanged: (newValue) {
        setState(() {
          isSelected = newValue;
        });
      },
      // unselectedBorderColor: isDark
      //     ? const Color.fromARGB(255, 143, 137, 137)
      //     : const Color.fromARGB(255, 165, 212, 250),
      selectedBorderColor: Colors.red[700],
      iconColor: const Color.fromRGBO(211, 47, 47, 1),
      selectedBackgroundColor: Colors.red[50],
      selectedBackgroundColorIcon: Colors.red[50],
      selectedBorderColorIcon: Colors.red[700],
      selected: isSelected,
      padding: 8.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "ZA,",
            style: textStyles.headlineSmall
                ?.copyWith(color: isSelected ? Colors.red[700] : null),
          ),
          SizedBox(
            height: 60.0,
            child: Text(
              "South Africa (Country Name)",
              style: textStyles.bodyLarge
                  ?.copyWith(color: isSelected ? Colors.red[700] : null),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
