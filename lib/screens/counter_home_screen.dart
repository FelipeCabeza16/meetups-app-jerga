import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meetups_app/widgets/bottom_navigation.dart';

class CounterHomeScreen extends StatefulWidget {
  final String _title;

  CounterHomeScreen({String title}) : _title = title;

  @override
  _CounterHomeScreenState createState() => _CounterHomeScreenState();
}

class _CounterHomeScreenState extends State<CounterHomeScreen> {
  final StreamController<int> _streamController =
      StreamController<int>.broadcast();
  // final StreamTransformer<int, int> _streamTransformer = StreamTransformer.fromHandlers(
  //   handleData: (int data, EventSink<int> sink) {
  //     print('CALLING FROM HANDLE DATA!!!!!!!');
  //     print(data);
  //     sink.add(data ~/ 2);
  //   }
  // );
  final StreamController<int> _counterController =
      StreamController<int>.broadcast();

  int _counter = 0;

  initState() {
    super.initState();
    _streamController.stream
        // .skip(5)
        // .map((data) {
        //   print(data);
        //   return data * 2;
        // })
        // // .where((data) => data < 15
        // .map((data) => data - 4)
        // .map((data) => data * data)
        // .listen((data) {
        //   print('LISTENER IN INIT STATE FUNCTION');
        //   print(data);
        .listen((int number) {
      _counter += number;
      _counterController.sink.add(_counter);
    });
  }


  dispose() {
    _streamController.close();
    _counterController.close();
    super.dispose();
  }

  _increment() {
    _streamController.sink.add(15);
  }

  Widget build(BuildContext context) {
    _streamController.stream.listen((data) {
      print('LISTENER IN BUILD FUNCTION');
      print(data);
    });
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Bienvenido ${widget._title}, vamos a incrementar!!',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 15.0)),
          StreamBuilder(
            stream: _counterController.stream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                return Text('Countador: ${snapshot.data}',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 30.0));
              } else {
                return Text('El countador está triste :(',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 30.0));
              }
            },
          ),
          RaisedButton(
            child: StreamBuilder(
              stream: _counterController.stream,
              initialData: _counter,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  return Text('Countador --> ${snapshot.data}');
                } else {
                  return Text('El countador está triste :(');
                }
              },
            ),
            onPressed: () => Navigator.pushNamed(context, '/meetupDetail'),
          )
        ],
      )),
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: FloatingActionButton(
          onPressed: _increment,
          tooltip: 'Incrementar',
          child: Icon(Icons.add)),
      appBar: AppBar(title: Text(widget._title)),
    );
  }
}
