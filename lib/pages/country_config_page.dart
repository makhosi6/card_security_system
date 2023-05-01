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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () async {},
              child: const Text('scan card'),
            ),
            const Text('oppo'),
          ],
        ),
      ),
    );
  }
}
