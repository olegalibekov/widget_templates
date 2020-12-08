import 'package:flutter/material.dart';
import 'package:widget_templates/templates/player_slider_canvas.dart';
import 'package:widget_templates/templates/widget_player.dart';
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
    return Column(children: [
      Slider(
          value: _currentSliderValue,
          min: -_sideSliderValue,
          max: _sideSliderValue,
          onChangeStart: (double value) {
            _tapOn.value = true;
            _valueBeforeScrolling = value;
          },
          onChangeEnd: (double value) {
            _tapOn.value = false;
            _velocityValue = 0.0;

            Tween<double> _tween = Tween(begin: _currentSliderValue, end: 0.0);
            _animation = _tween.animate(_curvedAnimation);
            _animationController
              ..reset()
              ..forward();
            _animationController.addListener(() {
              setState(() => _currentSliderValue = _animation.value);
            });

            // print(_scrollController.position.scrol);
            _scrollController.jumpTo(
                _timeLinePosition * _scrollController.position.maxScrollExtent);
          },
          onChanged: (double value) {
            setState(() => _currentSliderValue = value);
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
          }),
      Container(
          height: wholeWidgetHeight * 0.237,
          width: double.infinity,
          child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                SizedBox(width: wholeWidgetWidth / 2 - 25),
                ..._seconds,
                SizedBox(width: wholeWidgetWidth / 2 - 40)
              ])),
      Container(
          // color: Colors.teal,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.center,
                child: CustomPaint(
                    size: Size(wholeWidgetWidth, wholeWidgetHeight),
                    painter: PlayerSliderLineCanvas())),
          ))
    ]);
  }
}
