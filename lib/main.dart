import 'package:flutter/material.dart';
import 'package:widget_templates/tests/test_drag_and_drop.dart';

import 'templates/player_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: PlayerWidget());
  }
}
