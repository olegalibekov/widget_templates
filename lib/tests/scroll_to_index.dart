//Copyright (C) 2019 Potix Corporation. All Rights Reserved.
//History: Tue Apr 24 09:29 CST 2019
// Author: Jerry Chen

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:widget_templates/modified_flutter_widgets/drag_and_drop.dart';
import 'package:widget_templates/templates/player_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scroll To Index Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Scroll To Index Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const maxCount = 100;
  final random = math.Random();
  final scrollDirection = Axis.horizontal;

  AutoScrollController controller;
  List<List<int>> randomList;

  final double _maxLineHeight = 50.0;
  final double _thickness = 5.0;
  final double _divisionLength = 30.0;

  double get _minLineHeight => _maxLineHeight / 2;
  List divisions = [];

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    // randomList = List.generate(maxCount,
    //     (index) => <int>[index, (1000 * random.nextDouble()).toInt()]);

    for (int division = 0; division <= 100; division++)
      divisions.add(_wrapScrollTag(
          index: division,
          child: DragTargetInterlayer<List>(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        // color: Colors.yellow,
                        height: _maxLineHeight,
                        child: Stack(children: [
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                  width: _thickness,
                                  height: division % 10 == 0
                                      ? _maxLineHeight
                                      : _minLineHeight,
                                  color: Colors.orange)),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                  width: _divisionLength,
                                  height: _thickness,
                                  color: Colors.orange))
                        ])),
                    Text(division.toString(),
                        style: TextStyle(color: Colors.black))
                  ]),
              onWillAccept: (d) {
                print(division);
                return true;
              },
              onAccept: (d) => print("accept "),
              onLeave: (d) => print("leave"))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        scrollDirection: scrollDirection,
        controller: controller,
        children: [...divisions],
        // children: [DragTargetTrack(100)],
        // children: randomList.map<Widget>((data) {
        //   return Padding(
        //     padding: EdgeInsets.all(8),
        //     child: _getRow(data[0], math.max(data[1].toDouble(), 50.0)),
        //   );
        // }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToIndex,
        tooltip: 'Increment',
        child: Text(counter.toString()),
      ),
    );
  }

  int counter = -1;

  Future _scrollToIndex() async {
    setState(() {
      counter++;

      if (counter >= maxCount) counter = 0;
    });

    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(counter);
  }

  Widget _getRow(int index, double height) {
    return _wrapScrollTag(
        index: index,
        child: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.topCenter,
          height: height,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue, width: 4),
              borderRadius: BorderRadius.circular(12)),
          child: Text('index: $index, height: $height'),
        ));
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );
}
