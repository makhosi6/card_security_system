import 'package:flutter/material.dart';

class StateManager extends InheritedWidget {
  const StateManager({super.key, required Widget child}) : super(child: child);

  static StateManager? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StateManager>();
  }

  @override
  bool updateShouldNotify(StateManager oldWidget) {
    return true;
  }
}
