import 'package:flutter/material.dart';
import 'package:meetups_app/blocs/bloc_provider.dart';
import 'package:meetups_app/blocs/counter_bloc.dart';
import 'package:meetups_app/widgets/bottom_navigation.dart';

class CounterHomeScreen extends StatefulWidget {
  final String _title;

  CounterHomeScreen({String title}) : _title = title;

  @override
  _CounterHomeScreenState createState() => _CounterHomeScreenState();
}

class _CounterHomeScreenState extends State<CounterHomeScreen> {
  CounterBloc counterBloc;

  didChangeDependencies() {
    super.didChangeDependencies();
    counterBloc = BlocProvider.of<CounterBloc>(context);
  }

  int _counter = 0;

  _increment() {
    counterBloc.increment(15);
    // widget.bloc.increment(20);
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
            stream: counterBloc.counterStream,
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
              stream: counterBloc.counterStream,
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
