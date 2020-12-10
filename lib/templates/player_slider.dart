import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:widget_templates/templates/player_widget.dart';
import 'package:widget_templates/modified_flutter_widgets/drag_and_drop.dart'
    as dragAndDrop;
import 'package:scroll_to_index/scroll_to_index.dart';
import 'dart:async';

class PlayerSlider extends StatefulWidget {
  @override
  _PlayerSliderState createState() => _PlayerSliderState();
}

class _PlayerSliderState extends State<PlayerSlider>
    with TickerProviderStateMixin {
  final double _sideSliderValue = 0.5;
  final double _sideSliderBound = 0.48;
  final double _maxVelocity = 0.001;

  AnimationController _animationController;
  CurvedAnimation _curvedAnimation;
  Animation _animation;

  ScrollController _scrollController = ScrollController();
  ValueNotifier _tapOn = ValueNotifier(false);
  double _currentSliderValue = 0.0;
  double _timeLinePosition = 0.0;
  double _velocityValue = 0.0;
  double _valueBeforeScrolling;
  List<Widget> _seconds = [];
  Timer _timer;

  final double _handleHeight = 100.0;
  final double _handleMiddlePadding = 5.0;
  final double _handleDefaultWidth = 8.0;
  double _handleMiddleWidth = 8.0;
  double _handleMiddleHeight = 100.0 / 3;
  double _handleEdgeLinesWidth = 2.0;
  BorderRadiusGeometry _handleBorderRadius = BorderRadius.circular(12);

  bool _isScrolling = false;

  HandleWidget _handleWidget = HandleWidget();

  AutoScrollController _autoScrollController;

  @override
  void initState() {
    _autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);

    _handleWidget
      ..handleHeight = _handleHeight
      ..handleMiddleWidth = _handleMiddleWidth
      ..handleMiddleHeight = _handleMiddleHeight
      ..handleEdgeLinesWidth = _handleEdgeLinesWidth
      ..handleBorderRadius = _handleBorderRadius;

    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _curvedAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutQuint);

    for (int second = 0; second <= 100; second++) {
      _seconds.add(Text(' $second ',
          style: TextStyle(color: Colors.white, fontSize: 16.0)));
    }
    //
    // _tapOn.addListener(() {
    //   if (_tapOn.value == true) {
    //     _timer =
    //         Timer.periodic(const Duration(milliseconds: 5), (Timer t)  {
    //       double _futureTimeLinePosition = _timeLinePosition + _velocityValue;
    //
    //       if (_futureTimeLinePosition >= 0.0 &&
    //           _futureTimeLinePosition <= 1.0) {
    //         _timeLinePosition = _futureTimeLinePosition;
    //
    //          _autoScrollController.scrollToIndex(
    //             (_timeLinePosition * 100).toInt(),
    //             preferPosition: AutoScrollPosition.middle);
    //       }
    //     });
    //   } else
    //     _timer.cancel();
    // });

    // _tapOn.addListener(() {
    //   if (_tapOn.value == true) {
    //     _timer = Timer.periodic(const Duration(milliseconds: 20), (Timer t) {
    //       double _futureTimeLinePosition = _timeLinePosition + _velocityValue;
    //
    //       if (_futureTimeLinePosition >= 0.0 &&
    //           _futureTimeLinePosition <= 1.0) {
    //         _timeLinePosition = _futureTimeLinePosition;
    //         _scrollController.jumpTo(
    //             _timeLinePosition * _scrollController.position.maxScrollExtent);
    //       }
    //     });
    //   } else
    //     _timer.cancel();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: Container(
                // color: Colors.teal,
                height: _handleHeight + _handleMiddlePadding,
                child: Stack(children: [
                  Container(
                      width: wholeWidgetWidth,
                      height: _handleHeight + _handleMiddlePadding,
                      child: ListView(
                          controller: _autoScrollController,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            SizedBox(width: wholeWidgetWidth / 2 - 25),
                            ...dragTargetTrack(200),
                            SizedBox(width: wholeWidgetWidth / 2 - 40)
                          ])),
                  Align(
                      alignment: Alignment.center,
                      child: dragAndDrop.Draggable<List>(
                          axis: Axis.horizontal,
                          data: ["data"],
                          onDragStarted: (position) {
                            _tapOn.value = true;
                            _valueBeforeScrolling = 0.0;

                            setState(() {
                              _handleMiddleHeight =
                                  _handleHeight / 3 + _handleMiddlePadding;
                              _handleMiddleWidth = _handleEdgeLinesWidth;
                              _handleBorderRadius = BorderRadius.circular(0.0);

                              _isScrolling = true;
                            });

                            _handleWidget
                              ..handleHeight = _handleHeight
                              ..handleMiddleWidth = _handleMiddleWidth
                              ..handleMiddleHeight = _handleMiddleHeight
                              ..handleEdgeLinesWidth = _handleEdgeLinesWidth
                              ..handleBorderRadius = _handleBorderRadius;
                          },
                          onDragEnd: (details) {
                            _tapOn.value = false;
                            _velocityValue = 0.0;

                            setState(() {
                              _handleMiddleHeight = _handleHeight / 3;
                              _handleMiddleWidth = _handleDefaultWidth;
                              _handleBorderRadius = BorderRadius.circular(12.0);

                              _isScrolling = false;
                            });

                            _handleWidget
                              ..handleHeight = _handleHeight
                              ..handleMiddleWidth = _handleMiddleWidth
                              ..handleMiddleHeight = _handleMiddleHeight
                              ..handleEdgeLinesWidth = _handleEdgeLinesWidth
                              ..handleBorderRadius = _handleBorderRadius;
                          },
                          onDragUpdate: (position) {
                            double _sliderMiddlePosition =
                                (wholeWidgetWidth) / 2;
                            double lengthToBoundFromCenter =
                                _sliderMiddlePosition * 0.92;
                            _currentSliderValue = position.dx /
                                    (_sliderMiddlePosition +
                                        lengthToBoundFromCenter) -
                                0.5;

                            double _valueDifference =
                                -(_valueBeforeScrolling - _currentSliderValue);

                            double _futureVelocityValue =
                                (_currentSliderValue.abs() - _sideSliderBound) /
                                    (_sideSliderValue - _sideSliderBound) *
                                    _maxVelocity;

                            if (_valueDifference >= _sideSliderBound) {
                              _velocityValue = _futureVelocityValue;
                            } else if (_valueDifference <= -_sideSliderBound) {
                              _velocityValue = -_futureVelocityValue;
                            } else {
                              _velocityValue = 0.0;
                            }
                          },
                          feedback: SizedBox(
                              height: _handleHeight + _handleMiddlePadding,
                              child:
                                  _isScrolling ? Container() : _handleWidget),
                          child: _isScrolling ? Container() : _handleWidget)),
                ]))));
  }

  final Color _trackColor = Colors.orange;
  final double _maxLineHeight = 40.0;
  final double _thickness = 2.5;
  final double _divisionLength = 40.0;

  double get _minLineHeight => _maxLineHeight / 2;

  List dragTargetTrack(int divisionNumber) {
    List divisions = [];
    for (int division = 0; division <= divisionNumber; division++) {
      divisions.add(_wrapScrollTag(
          index: division,
          child: dragAndDrop.DragTargetInterlayer<List>(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                            color: _trackColor)),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                            width: _divisionLength,
                            height: _thickness,
                            color: _trackColor))
                  ])),
              SizedBox(height: 12),
              Text(division % 10 == 0 ? division.toString() : '',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18))
            ]),
            onWillAccept: (d) {
              // print(division);
              _autoScrollController.scrollToIndex(division,
                  preferPosition: AutoScrollPosition.middle);
              return true;
            },
            // onAccept: (d) => print("accept "),
            // onLeave: (d) => print("leave")
          )));
    }
    return divisions;
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
      key: ValueKey(index),
      controller: _autoScrollController,
      index: index,
      child: child);
}

// ignore: must_be_immutable
class HandleWidget extends StatefulWidget {
  double handleHeight;
  double handleMiddleWidth;
  double handleMiddleHeight;
  double handleEdgeLinesWidth;
  BorderRadius handleBorderRadius;

  @override
  _HandleWidgetState createState() => _HandleWidgetState();
}

class _HandleWidgetState extends State<HandleWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          width: widget.handleEdgeLinesWidth,
          height: widget.handleHeight / 3,
          color: Colors.white),
      Spacer(),
      AnimatedContainer(
          width: widget.handleMiddleWidth,
          height: widget.handleMiddleHeight,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: widget.handleBorderRadius),
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn),
      Spacer(),
      Container(
          width: widget.handleEdgeLinesWidth,
          height: widget.handleHeight / 3,
          color: Colors.white)
    ]);
  }
}

// class DragTargetTrack extends StatefulWidget {
//   final double divisionNumber;
//
//   const DragTargetTrack(this.divisionNumber, {Key key}) : super(key: key);
//
//   @override
//   _DragTargetTrackState createState() => _DragTargetTrackState();
// }
//
// class _DragTargetTrackState extends State<DragTargetTrack> {
//   // final double _handleHeight = 100.0;
//   // final double _handleMiddlePadding = 5.0;
//
//   final double _maxLineHeight = 50.0;
//   final double _thickness = 5.0;
//   final double _divisionLength = 30.0;
//
//   double get _minLineHeight => _maxLineHeight / 2;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       for (int division = 0; division <= widget.divisionNumber; division++)
//         dragAndDrop.DragTargetInterlayer<List>(
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     // color: Colors.yellow,
//                       height: _maxLineHeight,
//                       child: Stack(children: [
//                         Align(
//                             alignment: Alignment.bottomLeft,
//                             child: Container(
//                                 width: _thickness,
//                                 height: division % 10 == 0
//                                     ? _maxLineHeight
//                                     : _minLineHeight,
//                                 color: Colors.orange)),
//                         Align(
//                             alignment: Alignment.bottomLeft,
//                             child: Container(
//                                 width: _divisionLength,
//                                 height: _thickness,
//                                 color: Colors.orange))
//                       ])),
//                   Text(division.toString(),
//                       style: TextStyle(color: Colors.white))
//                 ]),
//             onWillAccept: (d) {
//               print(division);
//               return true;
//             },
//             onAccept: (d) => print("accept "),
//             onLeave: (d) => print("leave"))
//     ]);
//   }
// }
// Slider(
//     value: _currentSliderValue,
//     min: -_sideSliderValue,
//     max: _sideSliderValue,
//     onChangeStart: (double value) {
//       _tapOn.value = true;
//       _valueBeforeScrolling = value;
//     },
//     onChangeEnd: (double value) {
//       _tapOn.value = false;
//       _velocityValue = 0.0;
//
//       Tween<double> _tween =
//           Tween(begin: _currentSliderValue, end: 0.0);
//       _animation = _tween.animate(_curvedAnimation);
//       _animationController
//         ..reset()
//         ..forward();
//       _animationController.addListener(() {
//         setState(
//             () => _currentSliderValue = _animation.value);
//       });
//
//       _scrollController.jumpTo(_timeLinePosition *
//           _scrollController.position.maxScrollExtent);
//     },
//     onChanged: (double value) {
//       setState(() => _currentSliderValue = value);
//       double _valueDifference =
//           -(_valueBeforeScrolling - _currentSliderValue);
//
//       double _futureVelocityValue =
//           (_currentSliderValue.abs() - _sideSliderBound) /
//               (_sideSliderValue - _sideSliderBound) *
//               _maxVelocity;
//
//       if (_valueDifference >= _sideSliderBound) {
//         _velocityValue = _futureVelocityValue;
//       } else if (_valueDifference <= -_sideSliderBound) {
//         _velocityValue = -_futureVelocityValue;
//       } else {
//         _velocityValue = 0.0;
//       }
//     })
// trackPart()

// Widget handleWidget() {
//   return Column(children: [
//     Container(
//         width: _handleEdgeLinesWidth,
//         height: _handleHeight / 3,
//         color: Colors.white),
//     Spacer(),
//     AnimatedContainer(
//         width: _handleMiddleWidth,
//         height: _handleMiddleHeight,
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: _handleBorderRadius),
//         duration: Duration(milliseconds: 300),
//         curve: Curves.fastOutSlowIn),
//     Spacer(),
//     Container(
//         width: _handleEdgeLinesWidth,
//         height: _handleHeight / 3,
//         color: Colors.white)
//   ]);
//   return GestureDetector(
//       onPanUpdate: (details) {
//         setState(() {
//           _handleMiddleHeight = _handleHeight / 3 + _handleMiddlePadding;
//           _handleMiddleWidth = _handleEdgeLinesWidth;
//           _handleBorderRadius = BorderRadius.circular(0.0);
//         });
//       },
//       onPanEnd: (details) {
//         setState(() {
//           _handleMiddleHeight = _handleHeight / 3;
//           _handleMiddleWidth = _handleDefaultWidth;
//           _handleBorderRadius = BorderRadius.circular(12.0);
//         });
//       },
//       child: Column(children: [
//         Container(
//             width: _handleEdgeLinesWidth,
//             height: _handleHeight / 3,
//             color: Colors.white),
//         Spacer(),
//         AnimatedContainer(
//             width: _handleMiddleWidth,
//             height: _handleMiddleHeight,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: _handleBorderRadius),
//             duration: Duration(milliseconds: 300),
//             curve: Curves.fastOutSlowIn),
//         Spacer(),
//         Container(
//             width: _handleEdgeLinesWidth,
//             height: _handleHeight / 3,
//             color: Colors.white)
//       ]));
// }
