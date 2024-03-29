import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meetups_app/blocs/bloc_provider.dart';

class CounterBloc extends BlocBase{
  final StreamController<int> _streamController =
      StreamController<int>.broadcast();
  final StreamController<int> _counterController =
      StreamController<int>.broadcast();

  Stream<int> get counterStream => _counterController.stream;
  StreamSink<int> get counterSink => _counterController.sink;

  int _counter = 0;
  CounterBloc() {
    _streamController.stream.listen(_handleIncrement);
  }

  _handleIncrement(int number) {
    counterSink.add(_counter);
    _counter += number;
  }

  increment(int incrementer) {
    _streamController.sink.add(incrementer);
  }

  dispose() {
    _streamController.close();
    _counterController.close();
  }
}

class CounterBlocProvider extends StatefulWidget {
  final Widget child;
  final CounterBloc bloc;

  CounterBlocProvider({Key key, @required this.child})
      : bloc = CounterBloc(),
        super(key: key);

  _CounterBlocProviderState createState() => _CounterBlocProviderState();

static CounterBloc of(BuildContext context) {
    _CounterBlocProviderInherited provider =
      (context.getElementForInheritedWidgetOfExactType<_CounterBlocProviderInherited>()?.widget
     as _CounterBlocProviderInherited);

    return provider.bloc;
  }
}

class _CounterBlocProviderState extends State<CounterBlocProvider> {
  dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return _CounterBlocProviderInherited(
      child: widget.child,
      bloc: widget.bloc
    );
  }
}

class _CounterBlocProviderInherited extends InheritedWidget {
  final CounterBloc bloc;

  _CounterBlocProviderInherited({@required Widget child, @required this.bloc, Key key})
    : super(key: key, child: child);

  bool updateShouldNotify(InheritedWidget oldWidget) => true;


}
