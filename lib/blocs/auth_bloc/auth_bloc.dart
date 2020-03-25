import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:meetups_app/blocs/auth_bloc/events.dart';
import 'package:meetups_app/blocs/auth_bloc/states.dart';
import 'package:meetups_app/blocs/bloc_provider.dart';
import 'package:meetups_app/services/auth_api_provider.dart';
import 'package:rxdart/rxdart.dart';

export 'package:meetups_app/blocs/auth_bloc/events.dart';
export 'package:meetups_app/blocs/auth_bloc/states.dart';

class AuthBloc extends BlocBase {
  final AuthApiService auth;

  final BehaviorSubject<AuthenticationState> _authController =
      BehaviorSubject<AuthenticationState>();

  Stream<AuthenticationState> get authState => _authController.stream;
  StreamSink<AuthenticationState> get _inAuth => _authController.sink;

  AuthBloc({@required this.auth}) : assert(auth != null);

  void dispatch(AuthenticationEvent event) async {
    await for (var state in _authStream(event)) {
      print('sending state $state');
      _inAuth.add(state);
    }
  }

  Stream<AuthenticationState> _authStream(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool isAuth = await auth.isAuthenticated();

      if (isAuth) {
        auth.initUserFromToken();
        // await auth.fetchAuthUser().catchError((error) {
        //   dispatch(LoggedOut());
        // });
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is InitLogging) {
      yield AuthenticationLoading();
    }

    if (event is LoggedIn) {
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      print('deberia entrar aquí');
      yield AuthenticationUnauthenticated(message: event.message);
    }
  }

  dispose() {
    print('disposing...');
    _authController.close();
  }
}
