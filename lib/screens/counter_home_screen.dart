import 'package:flutter/material.dart';
import 'package:meetups_app/widgets/bottom_navigation.dart';

class CounterHomeScreen extends StatefulWidget {
  final String _title;

  CounterHomeScreen({String title}) : _title = title;

  @override
  _CounterHomeScreenState createState() => _CounterHomeScreenState();
}

class _CounterHomeScreenState extends State<CounterHomeScreen> {
  int _counter = 0;

  _increment() {
    setState(() {
      _counter++;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Bienvenido ${widget._title}, vamos a incrementar!!',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 15.0)),
          Text('Contador: $_counter',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 30.0)),
               RaisedButton(
              child: Text('Ir a detalles'),
              onPressed: () => Navigator.pushNamed(context, '/meetupDetail'),
            )
        ],
      )),
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: FloatingActionButton(
          onPressed: _increment, tooltip: 'Incrementar', child: Icon(Icons.add)),
      appBar: AppBar(title: Text(widget._title)),
    );
  }
}

