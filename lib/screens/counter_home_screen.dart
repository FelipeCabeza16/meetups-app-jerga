import 'package:flutter/material.dart';
import 'package:meetups_app/blocs/counter_bloc.dart';
import 'package:meetups_app/widgets/bottom_navigation.dart';

class CounterHomeScreen extends StatefulWidget {
  final String _title;

  final CounterBloc bloc;

  CounterHomeScreen({String title, this.bloc}) : _title = title;

  @override
  _CounterHomeScreenState createState() => _CounterHomeScreenState();
}

class _CounterHomeScreenState extends State<CounterHomeScreen> {
  // CounterBloc counterBloc;

  didChangeDependencies() {
    super.didChangeDependencies();
    // counterBloc = CounterBlocProvider.of(context);
  }

  int _counter = 0;

  _increment() {
    widget.bloc.increment(20);
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
          StreamBuilder(
            stream: widget.bloc.counterStream,
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
              stream: widget.bloc.counterStream,
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
