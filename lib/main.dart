import 'package:flutter/material.dart';
import 'package:meetups_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:meetups_app/blocs/auth_bloc/events.dart';
import 'package:meetups_app/blocs/auth_bloc/states.dart';
import 'package:meetups_app/blocs/bloc_provider.dart';
import 'package:meetups_app/blocs/meetups_bloc.dart';
import 'package:meetups_app/blocs/user_bloc/user_bloc.dart';
import 'package:meetups_app/models/arguments.dart';
import 'package:meetups_app/screens/login_screen.dart';
import 'package:meetups_app/screens/meetup_detail_screen.dart';
import 'package:meetups_app/screens/meetup_home_screen.dart';
import 'package:meetups_app/screens/register_screen.dart';
import 'package:meetups_app/services/auth_api_provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      bloc: AuthBloc(auth: AuthApiService()),
      child: MeetuperApp(),
    );
  }
}

class MeetuperApp extends StatefulWidget {
  _MeetuperAppState createState() => _MeetuperAppState();
}

class _MeetuperAppState extends State<MeetuperApp> {
  final String appTitle = 'Meetuper App';

  AuthBloc authBloc;
  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.dispatch(AppStarted());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: StreamBuilder<AuthenticationState>(
          stream: authBloc.authState,
          initialData: AuthenticationUninitialized(),
          builder: (BuildContext context,
              AsyncSnapshot<AuthenticationState> snapshot) {
            final state = snapshot.data;
            print('current state');
            print(state);
            if (state is AuthenticationUninitialized) {
              return SplashScreen();
            }

            if (state is AuthenticationAuthenticated) {
              return BlocProvider<MeetupBloc>(
                bloc: MeetupBloc(),
                child: MeetupHomeScreen(),
              );
            }

            if (state is AuthenticationUnauthenticated) {
              final LoginScreenArguments arguments =
                  ModalRoute.of(context).settings.arguments;
              final message = state.message ?? arguments?.message;
              state.message = null;
              return LoginScreen(message: message);
            }

            if (state is AuthenticationLoading) {
              return LoadingScreen();
            }
          },
        ),
        routes: {
          MeetupHomeScreen.route: (context) 
          => BlocProvider<MeetupBloc>(
                bloc: MeetupBloc(),
                child: MeetupHomeScreen(),
              ),
          RegisterScreen.route: (context) => RegisterScreen(),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == MeetupDetailScreen.route) {
            final MeetupDetailArguments arguments = settings.arguments;

            return MaterialPageRoute(
                builder: (context) 
                => BlocProvider<MeetupBloc>(
                    bloc: MeetupBloc(),
                    child: BlocProvider<UserBloc>(
                        bloc: UserBloc(auth: AuthApiService()),
                        child: MeetupDetailScreen(meetupId: arguments.id))));
          }
          
          if (settings.name == LoginScreen.route) {
            final LoginScreenArguments arguments = settings.arguments;

            return MaterialPageRoute(
                builder: (context) => LoginScreen(message: arguments?.message));
          }
        });
  }
}

class SplashScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Splash Screen')));
  }
}

class LoadingScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
