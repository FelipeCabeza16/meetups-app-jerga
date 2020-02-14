import 'package:flutter/material.dart';
import 'package:meetups_app/models/meetups.dart';
import 'package:meetups_app/screens/meetup_detail_screen.dart';
import 'package:meetups_app/services/auth_api_provider.dart';
import 'package:meetups_app/services/meetup_api_provider.dart';

import 'package:meetups_app/utils/hypotenuse.dart';

class MeetupDetailArguments {
  final String id;

  MeetupDetailArguments({this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  static final String route = '/meetups';
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
        children: [_MeetupTitle(), _MeetupList(meetups: meetups)],
      ),
      appBar: AppBar(title: Text('Inicio')),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
    );
  }
}

class _MeetupTitle extends StatelessWidget {
  final AuthApiService auth = AuthApiService();

  Widget _buildUserWelcome(BuildContext context) {
    return FutureBuilder<bool>(
      future: auth.isAuthenticated(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
          final user = auth.authUser;
          return Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01),
              child: Row(
                children: <Widget>[
                  user.avatar != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.avatar),
                        )
                      : Container(width: 0, height: 0),
                  Text('Bienvenido ${user.username}'),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      auth.logout().then((isLogout) =>
                          Navigator.pushNamedAndRemoveUntil(context, '/login',
                              (Route<dynamic> route) => false));
                    },
                    child: Text('Salir',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  )
                ],
              ));
        } else {
          return Container(width: 0, height: 0);
        }
      },
    );
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(hypotenuse(height * 0.02, width * 0.02)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Meetups Relacionados',
              style: TextStyle(
                  fontSize: 22.0 * curScaleFactor,
                  fontWeight: FontWeight.bold)),
          _buildUserWelcome(context)
        ]));
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
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              meetup.image,
            ),
            radius: 25.0,
          ),
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
