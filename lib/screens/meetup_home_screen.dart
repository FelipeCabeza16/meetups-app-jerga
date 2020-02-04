import 'package:flutter/material.dart';
import 'package:meetups_app/models/meetups.dart';
import 'package:meetups_app/screens/meetup_detail_screen.dart';
import 'package:meetups_app/services/meetup_api_provider.dart';

import 'package:meetups_app/utils/hypotenuse.dart';

class MeetupDetailArguments {
  final String id;

  MeetupDetailArguments({this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  final MeetupApiService _api = MeetupApiService();
  MeetupHomeScreenState createState() => MeetupHomeScreenState();
}

class MeetupHomeScreenState extends State<MeetupHomeScreen> {
  List<Meetup> meetups = [];

  @override
  initState() {
    super.initState();
    _fetchMeetups();
  }

  _fetchMeetups() async {
    final meetups = await widget._api.fetchMeetups();
    setState(() => this.meetups = meetups);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_MeetupList(meetups: meetups)],
      ),
      appBar: AppBar(title: Text('Inicio')),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
    );
  }
}

class _MeetupTitle extends StatelessWidget {
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(hypotenuse(height * 0.02, width * 0.02)),
      child: Text('Meetups Relacionados',
          style: TextStyle(
              fontSize: 22.0 * curScaleFactor, fontWeight: FontWeight.bold)),
    );
  }
}

class _MeetupCard extends StatelessWidget {
  final Meetup meetup;

  _MeetupCard({@required this.meetup});

  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(meetup.image, ), radius: 25.0,),
          title: Text(meetup.title),
          subtitle: Text(meetup.description),
        ),
        ButtonTheme(
            child: ButtonBar(
          children: <Widget>[
            FlatButton(
                child: Text('Visitar Meetup'),
                onPressed: () {
                  Navigator.pushNamed(context, MeetupDetailScreen.route,
                      arguments: MeetupDetailArguments(id: meetup.id));
                }),
            FlatButton(child: Text('Favorito'), onPressed: () {})
          ],
        ))
      ],
    ));
  }
}

class _MeetupList extends StatelessWidget {
  final List<Meetup> meetups;

  _MeetupList({@required this.meetups});

  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: meetups.length * 2,
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;

        return _MeetupCard(meetup: meetups[index]);
      },
    ));
  }
}
