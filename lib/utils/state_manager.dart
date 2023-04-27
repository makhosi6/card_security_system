import 'package:flutter/material.dart';

class StateManager extends InheritedWidget {
  ThemeData? userTheme;

  StateManager({super.key, required this.child}) : super(child: child);

  @override
  final Widget child;

  static StateManager? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StateManager>();
  }

  @override
  bool updateShouldNotify(StateManager oldWidget) {
    return true;
  }
}
