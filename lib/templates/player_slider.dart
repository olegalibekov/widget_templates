import 'package:flutter/material.dart';
import 'package:widget_templates/templates/player_line_canvas.dart';
import 'package:widget_templates/templates/player_widget.dart';
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

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _curvedAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutQuint);

    for (int second = 0; second <= 100; second++) {
      _seconds.add(Text(' $second ',
          style: TextStyle(color: Colors.white, fontSize: 16.0)));
    }

    _tapOn.addListener(() {
      if (_tapOn.value == true) {
        _timer = Timer.periodic(const Duration(milliseconds: 20), (Timer t) {
          double _futureTimeLinePosition = _timeLinePosition + _velocityValue;

          if (_futureTimeLinePosition >= 0.0 &&
              _futureTimeLinePosition <= 1.0) {
            _timeLinePosition = _futureTimeLinePosition;
            _scrollController.jumpTo(
                _timeLinePosition * _scrollController.position.maxScrollExtent);
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
            child: Container(
                color: Colors.teal,
                height: _handleHeight + _handleMiddlePadding,
                width: wholeWidgetWidth,
                child: Stack(children: [
                  Positioned(
                      top: (_handleHeight + _handleMiddlePadding) / 2 + 15,
                      child: Container(
                          // color: Colors.red,
                          height: 20,
                          child: ListView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                SizedBox(width: wholeWidgetWidth / 2 - 25),
                                ..._seconds,
                                SizedBox(width: wholeWidgetWidth / 2 - 40)
                              ]))),
                  Align(
                    alignment: Alignment.center,
                    child: Draggable(
                      child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              _handleMiddleHeight =
                                  _handleHeight / 3 + _handleMiddlePadding;
                              _handleMiddleWidth = _handleEdgeLinesWidth;
                              _handleBorderRadius = BorderRadius.circular(0.0);
                            });
                          },
                          onPanEnd: (details) {
                            setState(() {
                              _handleMiddleHeight = _handleHeight / 3;
                              _handleMiddleWidth = _handleDefaultWidth;
                              _handleBorderRadius = BorderRadius.circular(12.0);
                            });
                          },
                          child: Column(children: [
                            Container(
                                width: _handleEdgeLinesWidth,
                                height: _handleHeight / 3,
                                color: Colors.white),
                            Spacer(),
                            AnimatedContainer(
                                width: _handleMiddleWidth,
                                height: _handleMiddleHeight,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: _handleBorderRadius),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.fastOutSlowIn),
                            Spacer(),
                            Container(
                                width: _handleEdgeLinesWidth,
                                height: _handleHeight / 3,
                                color: Colors.white)
                          ])),
                    ),
                  ),
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
                ]))));
  }
}
