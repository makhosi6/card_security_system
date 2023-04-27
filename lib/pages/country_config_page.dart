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
      appBar: AppBar(),
      body: const Text("Countries"),
    );
  }
}
