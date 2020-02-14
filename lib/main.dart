import 'package:flutter/material.dart';
import 'package:meetups_app/models/arguments.dart';
import 'package:meetups_app/screens/counter_home_screen.dart';
import 'package:meetups_app/screens/login_screen.dart';
import 'package:meetups_app/screens/meetup_detail_screen.dart';
import 'package:meetups_app/screens/meetup_home_screen.dart';
import 'package:meetups_app/screens/register_screen.dart';

void main() => runApp(MeetuperApp());

class MeetuperApp extends StatelessWidget {
  final String appTitle = 'Meetuper App';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: CounterHomeScreen(title: appTitle),
        // home: LoginScreen(),
        routes: {
          MeetupHomeScreen.route: (context) => MeetupHomeScreen(),
          RegisterScreen.route: (context) => RegisterScreen(),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == MeetupDetailScreen.route) {
            final MeetupDetailArguments arguments = settings.arguments;
            return MaterialPageRoute(
                builder: (context) =>
                    MeetupDetailScreen(meetupId: arguments.id));
          }
          if (settings.name == LoginScreen.route) {
            final LoginScreenArguments arguments = settings.arguments;

            return MaterialPageRoute(
                builder: (context) => LoginScreen(message: arguments?.message));
          }
        });
  }
}
