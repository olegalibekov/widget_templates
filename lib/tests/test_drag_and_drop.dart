import 'package:flutter/material.dart';
import 'package:widget_templates/modified_flutter_widgets/drag_and_drop.dart'
    as dragAndDrop;

class TestDragAndDrop extends StatefulWidget {
  @override
  _TestDragAndDropState createState() => _TestDragAndDropState();
}

class _TestDragAndDropState extends State<TestDragAndDrop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                constraints: BoxConstraints.expand(),
                color: Colors.grey[900],
                child: Stack(children: <Widget>[
                  // Container(
                  //     width: 100,
                  //     height: 100,
                  //     color: Colors.red,
                  //     child: dragAndDrop.DragTarget<List>(
                  //         onWillAccept: (d) => true,
                  //         onAccept: (d) => print("ACCEPT 1!"),
                  //         onLeave: (d) => print("LEAVE 1!"),
                  //         builder: (a, data, c) {
                  //           print(data);
                  //           return Center();
                  //         })),
                  // Align(
                  //     alignment: Alignment.bottomRight,
                  //     child: dragAndDrop.DragTarget<List>(
                  //         onWillAccept: (d) {
                  //           return true;
                  //         },
                  //         onAccept: (d) => print("ACCEPT 2!"),
                  //         onLeave: (d) => print("LEAVE 2!"),
                  //         builder: (context, candidateData, rejectedData) {
                  //           return Container(
                  //               width: 150, height: 150, color: Colors.purple);
                  //         })),
                  Container(
                      width: 100,
                      height: 100,
                      color: Colors.red,
                      child: dragAndDrop.DragTarget<List>(
                          onWillAccept: (d) => true,
                          onAccept: (d) => print("ACCEPT 1!"),
                          onLeave: (d) => print("LEAVE 1!"),
                          builder: (a, data, c) {
                            print(data);
                            return Center();
                          })),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: dragAndDrop.DragTargetInterlayer<List>(
                        child: Container(
                          width: 200,
                          height: 200,
                          color: Colors.blue,
                        ),
                        onWillAccept: (d) {
                          return true;
                        },
                        onAccept: (d) => print("ACCEPT 2!"),
                        onLeave: (d) => print("LEAVE 2!"),
                        // builder: (context, candidateData, rejectedData) {
                        //   return Container(
                        //       width: 150, height: 150, color: Colors.purple);
                        // }
                      )),

                  Align(
                      alignment: Alignment.topRight,
                      child: dragAndDrop.Draggable<List>(
                          data: ["SOME DATA"],
                          onDragUpdate: (position) {
                            print('position');
                          },
                          onDragStarted: (position) => print("DRAG START!"),
                          onDragCompleted: () => print("DRAG COMPLETED!"),
                          onDragEnd: (details) => print("DRAG ENDED!"),
                          onDraggableCanceled: (data, data2) =>
                              print("DRAG CANCELLED!"),
                          feedback: SizedBox(
                              width: 100,
                              height: 100,
                              child: Container(
                                  margin: EdgeInsets.all(10),
                                  color: Colors.green[800])),
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Container(
                                  margin: EdgeInsets.all(10),
                                  color: Colors.blue[800]))))
                ]))));
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: Center(
//           child: Container(
//               constraints: BoxConstraints.expand(),
//               color: Colors.grey[900],
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     width: 100,
//                     height: 100,
//                     color: Colors.red,
//                     child: DragTarget<List>(
//                       onWillAccept: (d) => true,
//                       onAccept: (d) => print("ACCEPT 1!"),
//                       onLeave: (d) => print("LEAVE 1!"),
//                       builder: (a, data, c) {
//                         print(data);
//                         return Center();
//                       },
//                     ),
//                   ),
//                   DragTarget<List>(
//                       onWillAccept: (d) {
//                         return true;
//                       },
//                       onAccept: (d) => print("ACCEPT 2!"),
//                       onLeave: (d) => print("LEAVE 2!"),
//                       builder: (context, candidateData, rejectedData) {
//                         return Container(
//                             width: 150, height: 150, color: Colors.purple);
//                       }),
//                   Draggable<List>(
//                     data: ["SOME DATA"],
//                     onDragStarted: () => print("DRAG START!"),
//                     onDragCompleted: () => print("DRAG COMPLETED!"),
//                     onDragEnd: (details) => print("DRAG ENDED!"),
//                     onDraggableCanceled: (data, data2) =>
//                         print("DRAG CANCELLED!"),
//                     feedback: SizedBox(
//                       width: 100,
//                       height: 100,
//                       child: Container(
//                         margin: EdgeInsets.all(10),
//                         color: Colors.green[800],
//                       ),
//                     ),
//                     child: SizedBox(
//                       width: 100,
//                       height: 100,
//                       child: Container(
//                         margin: EdgeInsets.all(10),
//                         color: Colors.blue[800],
//                       ),
//                     ),
//                   ),
//                 ],
//               )),
//         ));
//   }
// }
