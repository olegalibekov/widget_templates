import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:widget_templates/templates/player_slider.dart';

class PlayerWidget extends StatefulWidget {
  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

double wholeWidgetHeight;
double wholeWidgetWidth;
const double contentPadding = 14.0;

class _PlayerWidgetState extends State<PlayerWidget> {
  static const Color darkBackground = Color.fromRGBO(18, 18, 18, 1);

  // double _trackPositionInFractions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // wholeWidgetHeight = MediaQuery.of(context).size.height / 2.5;
    wholeWidgetHeight = 275;
    wholeWidgetWidth = MediaQuery.of(context).size.width;
    return Scaffold(backgroundColor: Colors.black, body: Center(child: body()));
  }

  Widget body() {
    return SizedBox(
        width: wholeWidgetWidth,
        height: wholeWidgetHeight,
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            color: Color.fromRGBO(30, 30, 30, 1),
            child: Padding(
                padding: const EdgeInsets.all(contentPadding),
                child: Column(children: [
                  topSection(),
                  PlayerSlider(),
                  // middleSection(),
                  // Spacer(),
                  bottomSection()
                ]))));
  }

  Widget topSection() {
    return SizedBox(
        // height: wholeWidgetHeight * 0.481,
        height: 120,
        width: double.infinity,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: darkBackground),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Expanded(
                      flex: 43,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              color: Colors.teal))),
                  SizedBox(width: 12.0),
                  Expanded(
                      flex: 55,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Dependency marquee: ^1.6.1
                            Container(
                                height: 20.0,
                                child: Marquee(
                                    text:
                                        'Will Theater Come Back? What Will It Look Like When It Does? ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.0))),
                            // Text('the Theater back to',
                            //     style: TextStyle(
                            //         color: Colors.white, fontSize: 18.0)),
                            SizedBox(height: 8.0),
                            Text('The Daily',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0)),
                            Spacer(),
                            FlatButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0)),
                                padding: EdgeInsets.zero,
                                splashColor: Colors.grey,
                                onPressed: () {},
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.access_time_rounded,
                                          color: Colors.white),
                                      SizedBox(width: 8.0),
                                      Text('45 mins',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0)),
                                      Spacer(),
                                      Icon(Icons.arrow_forward_ios,
                                          color: Colors.grey, size: 16)
                                    ]))
                          ]))
                ]))));
  }

  Widget middleSection() {
    return Container(
        height: wholeWidgetHeight * 0.237,
        width: double.infinity,
        color: Colors.orange);
  }

  Widget bottomSection() {
    return SizedBox(
        // height: wholeWidgetHeight * 0.177,
        height: 40,
        width: double.infinity,
        child: Row(children: [
          ClipOval(
              child: Material(
                  color: darkBackground,
                  child: InkWell(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.star, color: Colors.grey)),
                      onTap: () {}))),
          SizedBox(width: 12.0),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: darkBackground),
                  child: Center(
                      child: Text('FM · AM',
                          style:
                              TextStyle(color: Colors.grey, fontSize: 16.0))))),
          SizedBox(width: 12.0),
          ClipOval(
              child: Material(
                  color: darkBackground,
                  child: InkWell(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.radio, color: Colors.white)),
                      onTap: () {})))
        ]));
  }
}
