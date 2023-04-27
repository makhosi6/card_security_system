import 'package:card_security_system/provider/theme.dart';
import 'package:card_security_system/widgets/fab_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CardListPage extends StatefulWidget {
  const CardListPage({super.key});

  @override
  State<CardListPage> createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage>
    with CustomFloatingActionButton {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Credit Card"),
        actions: [
          IconButton(
              onPressed: () {
                var userTheme = Provider.of<UserTheme>(context, listen: false);
                if (userTheme.value == ThemeData.dark()) {
                  print("TO LIGHT");
                  userTheme.value = ThemeData.light();
                } else {
                  print("TO DARK");
                  userTheme.value = ThemeData.dark();
                }
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      floatingActionButton: floatingActionButtonAsSpeedDial(),
      body: Container(
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return const _ListItem();
          },
        ),
      ),
    );
  }
}

class _ListItem extends StatefulWidget {
  const _ListItem();

  @override
  State<_ListItem> createState() => __ListItemState();
}

class __ListItemState extends State<_ListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          dragDismissible: false,
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (_) {},
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (_) {},
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
          title: const Text('5593 7219 5084 9284'),

          /// type
          subtitle: const Text("12/30"),

          /// expiration data
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                "🇦🇪",
                style: TextStyle(fontSize: 22.0),
              ),
              Text('Visa'),
            ],
          ),
          dense: false,
        ),
      ),
    );
  }
}
