import 'package:card_security_system/models/boxes.dart';
import 'package:card_security_system/models/theme.dart';
import 'package:card_security_system/pages/country_config_page.dart';
import 'package:flutter/material.dart';

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
                  Boxes.getThemeData().get("theme")?.theme == "dark"
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
    /// theme storage box
    var themeBox = Boxes.getThemeData();

    /// theme provider
    // var userTheme = Provider.of<UserTheme>(context, listen: false);

    // /// system theme and brightness
    Brightness brightness =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    /// toggle between dark & light mode
    /// if [themeBox] empty set to system theme
    if (themeBox.isEmpty) {
      if (isDarkMode) {
        AppTheme().saveData('light');
      } else {
        AppTheme().saveData('dark');
      }
    } else if (themeBox.values.first.theme == "dark") {
      /// save the option on a persistent storage
      /// update provider and trigger UI update
      themeBox.values.first.saveData('light');
    } else {
      /// save the option on a persistent storage
      /// update provider and trigger UI update
      themeBox.values.first.saveData('dark');
    }
  }

  _navigateToBannedCountries(BuildContext context) {
    ///close the modal/bottomSheet
    Navigator.pop(context);

    ///then navigate to the next page
    Navigator.pushNamed(context, ConfigCountriesPage.routeName);
  }
}
