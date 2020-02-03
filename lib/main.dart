import 'package:flutter/material.dart';
import 'package:meetups_app/screens/counter_home_screen.dart';
import 'package:meetups_app/screens/meetup_detail_screen.dart';
import 'package:meetups_app/screens/post_screen.dart';

void main() => runApp(MeetuperApp());

class MeetuperApp extends StatelessWidget {
  final String appTitle = 'Meetuper App';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: PostScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
      MeetupDetailScreen.route: (context) => MeetupDetailScreen()
      },
      );
  }
}

