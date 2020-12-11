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
  final double _maxVelocity = 0.006;

  final Color _trackColor = Color.fromRGBO(52, 52, 52, 1);
  final double _maxLineHeight = 20.0;
  final double _thickness = 2.2;
  final double _divisionLength = 10.0;

  double get _minLineHeight => _maxLineHeight / 2.5;

  ValueNotifier _tapOn = ValueNotifier(false);
  double _currentSliderValue = 0.0;
  double _timeLinePosition = 0.0;
  double _velocityValue = 0.0;
  double _valueBeforeScrolling;

  final double _handleHeight = 70.0;
  final double _handleMiddleVerticalPadding = 4.0;
  final double _handleDefaultWidth = 6.0;
  double _handleMiddleHorizontalPadding = 0.0;
  double _handleMiddleWidth = 6.0;
  double _handleMiddleHeight = 70.0 / 3;
  double _handleEdgeLinesWidth = 2.0;
  BorderRadiusGeometry _handleBorderRadius = BorderRadius.circular(12);

  HandleWidget _handleWidget = HandleWidget();
  AutoScrollController _autoScrollController;
  int _currentDivision = 0;
  Timer _timer;
  int _durationInSeconds = 200;

  @override
  void initState() {
    _autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);

    updateHandleWidget();

    _tapOn.addListener(() {
      if (_tapOn.value == true) {
        _timer = Timer.periodic(const Duration(milliseconds: 40), (Timer t) {
          double _futureTimeLinePosition = _timeLinePosition + _velocityValue;

          if (_futureTimeLinePosition >= 0.0 &&
              _futureTimeLinePosition <= 1.0) {
            _timeLinePosition = _futureTimeLinePosition;
          }

          if (_futureTimeLinePosition >= 0.0 &&
              _futureTimeLinePosition <= 1.0 &&
              _velocityValue != 0.0) {
            _autoScrollController.scrollToIndex(
                (_timeLinePosition * _durationInSeconds).toInt(),
                preferPosition: AutoScrollPosition.middle,
                duration: Duration(milliseconds: 1));
            _currentDivision = (_timeLinePosition * _durationInSeconds).toInt();
          }
        });
      } else
        _timer.cancel();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: SizedBox(
                height: _handleHeight + _handleMiddleVerticalPadding,
                child: Stack(children: [
                  Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: wholeWidgetWidth,
                          child: ListView(
                              controller: _autoScrollController,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                SizedBox(width: wholeWidgetWidth / 2 - 25),
                                ...dragTargetTrack(_durationInSeconds),
                                SizedBox(width: wholeWidgetWidth / 2 - 10)
                              ]))),
                  Align(
                      alignment: Alignment.center,
                      child: dragAndDrop.Draggable<List>(
                          axis: Axis.horizontal,
                          data: ["data"],
                          onDragStarted: (position) {
                            _valueBeforeScrolling = 0.0;

                            setState(() {
                              _handleMiddleHeight = _handleHeight / 3 +
                                  _handleMiddleVerticalPadding;
                              _handleMiddleWidth = _handleEdgeLinesWidth;
                              _handleBorderRadius = BorderRadius.circular(0.0);
                              _handleMiddleHorizontalPadding =
                                  _handleMiddleWidth;
                              _tapOn.value = true;
                            });
                            updateHandleWidget();
                          },
                          onDragEnd: (details) {
                            _velocityValue = 0.0;

                            setState(() {
                              _handleMiddleHeight = _handleHeight / 3;
                              _handleMiddleWidth = _handleDefaultWidth;
                              _handleBorderRadius = BorderRadius.circular(12.0);
                              _handleMiddleHorizontalPadding = 0.0;
                              _tapOn.value = false;
                            });

                            updateHandleWidget();

                            _timeLinePosition =
                                _currentDivision / _durationInSeconds;

                            _autoScrollController.scrollToIndex(
                                (_currentDivision).toInt(),
                                preferPosition: AutoScrollPosition.middle,
                                duration: Duration(milliseconds: 175));
                          },
                          onDragUpdate: (position) {
                            double _sliderMiddlePosition =
                                (wholeWidgetWidth) / 2;
                            double lengthToBoundFromCenter =
                                _sliderMiddlePosition * 0.92;
                            _currentSliderValue = position.dx /
                                    (_sliderMiddlePosition +
                                        lengthToBoundFromCenter) -
                                _sideSliderValue;

                            double _valueDifference =
                                -(_valueBeforeScrolling - _currentSliderValue);

                            if (_valueDifference >= _sideSliderBound) {
                              _velocityValue = _maxVelocity;
                            } else if (_valueDifference <= -_sideSliderBound) {
                              _velocityValue = -_maxVelocity;
                            } else {
                              _velocityValue = 0.0;
                            }
                          },
                          feedback: SizedBox(
                              height:
                                  _handleHeight + _handleMiddleVerticalPadding,
                              child:
                                  _tapOn.value ? Container() : _handleWidget),
                          child: _tapOn.value ? Container() : _handleWidget))
                ]))));
  }

  updateHandleWidget() {
    _handleWidget
      ..handleHeight = _handleHeight
      ..handleMiddleWidth = _handleMiddleWidth
      ..handleMiddleHeight = _handleMiddleHeight
      ..handleMiddleHorizontalPadding = _handleMiddleHorizontalPadding
      ..handleEdgeLinesWidth = _handleEdgeLinesWidth
      ..handleBorderRadius = _handleBorderRadius;
  }

  List dragTargetTrack(int divisionNumber) {
    List divisions = [];
    for (int division = 0; division <= divisionNumber; division++) {
      divisions.add(_wrapScrollTag(
          index: division,
          child: dragAndDrop.DragTargetInterlayer<List>(
              child: Center(
                  child: SizedBox(
                      height: _maxLineHeight,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: _maxLineHeight / 3),
                          child: Stack(overflow: Overflow.visible, children: [
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    width: _thickness,
                                    height: division % 10 == 0
                                        ? _maxLineHeight
                                        : _minLineHeight,
                                    color: _trackColor)),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    width: _divisionLength,
                                    height: _thickness,
                                    color: _trackColor)),
                            Positioned(
                                top: _maxLineHeight + 1,
                                right: (division > -10 && division < 10)
                                    ? 3
                                    : (division >= 10 && division < 100)
                                        ? -1.5
                                        : -6.0,
                                child: Text(
                                    division % 10 == 0
                                        ? division.toString()
                                        : '',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)))
                          ])))),
              onWillAccept: (d) {
                _currentDivision = division;
                return true;
              })));
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
  double handleMiddleHorizontalPadding;
  double handleEdgeLinesWidth;

  BorderRadius handleBorderRadius;

  @override
  _HandleWidgetState createState() => _HandleWidgetState();
}

class _HandleWidgetState extends State<HandleWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.handleMiddleHorizontalPadding),
      child: Column(children: [
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
          duration: Duration(milliseconds: 2000),
          // curve: Curves.fastOutSlowIn
        ),
        Spacer(),
        Container(
            width: widget.handleEdgeLinesWidth,
            height: widget.handleHeight / 3,
            color: Colors.white)
      ]),
    );
  }
}
