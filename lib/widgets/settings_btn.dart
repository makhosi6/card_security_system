import 'package:card_security_system/models/theme.dart';
import 'package:card_security_system/pages/country_config_page.dart';
import 'package:card_security_system/provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            elevation: 5.0,
            builder: (context) {
              /// active color
              var activeColor =
                  Provider.of<UserTheme>(context, listen: false).value ==
                          ThemeData.dark()
                      ? const Color.fromARGB(255, 100, 255, 218)
                      : Theme.of(context).colorScheme.primary;

              ///
              return Container(
                  width: 400.0,
                  height: 200.0,
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 246, 246, 246),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView(
                    children: [
                      /// change update the theme
                      Card(
                        key: UniqueKey(),
                        child: ListTile(
                          enableFeedback: true,
                          title: const Text(
                            "Select A Theme",
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () => _changeTheme(context),
                          trailing: Icon(Icons.opacity, color: activeColor),
                        ),
                      ),

                      /// to config banned countries
                      Card(
                        child: ListTile(
                          enableFeedback: true,
                          title: const Text(
                            "Select Banned Countries",
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () => _navigateToBannedCountries(context),
                          trailing:
                              Icon(Icons.list_alt_sharp, color: activeColor),
                        ),
                      )
                    ],
                  ));
            },
          );
        },
        icon: const Icon(Icons.settings));
  }

  void _changeTheme(BuildContext context) {
    ///
    var userTheme = Provider.of<UserTheme>(context, listen: false);

    /// toggle between dark & light mode
    if (userTheme.value == darkTheme) {
      /// update provider and trigger UI update
      userTheme.value = lightTheme;

      /// save the option on a persistent storage
      AppTheme().saveData('light');
    } else {
      /// update provider and trigger UI update
      userTheme.value = darkTheme;

      /// save the option on a persistent storage
      AppTheme().saveData('dark');
    }
  }

  _navigateToBannedCountries(BuildContext context) {
    ///close the modal/bottomSheet
    Navigator.pop(context);

    ///then navigate to the next page
    Navigator.pushNamed(context, ConfigCountriesPage.routeName);
  }
}
