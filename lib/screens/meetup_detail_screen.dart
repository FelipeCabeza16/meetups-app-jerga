import 'package:flutter/material.dart';

class MeetupDetailScreen extends StatelessWidget {
 static final String route = '/meetupDetail';
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Detalles del meetup'),
      appBar: AppBar(title: Text('Detalles del Meetup')),
    );
  }
}