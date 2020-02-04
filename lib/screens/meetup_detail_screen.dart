import 'package:flutter/material.dart';
import 'package:meetups_app/models/meetups.dart';
import 'package:meetups_app/services/meetup_api_provider.dart';
import 'package:meetups_app/utils/hypotenuse.dart';

class MeetupDetailScreen extends StatefulWidget {
  static final String route = '/meetupDetail';
  final String meetupId;
  final MeetupApiService api = MeetupApiService();

  MeetupDetailScreen({this.meetupId});

  @override
  _MeetupDetailScreenState createState() => _MeetupDetailScreenState();
}

class _MeetupDetailScreenState extends State<MeetupDetailScreen> {
  Meetup meetup;
  initState() {
    super.initState();
    _fetchMeetup();
  }

  _fetchMeetup() async {
    final meetup = await widget.api.fetchMeetupById(widget.meetupId);
    setState(() => this.meetup = meetup);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: meetup != null
          ? ListView(
              children: <Widget>[
                HeaderSection(meetup),
                TitleSection(meetup),
                AdditionalInfoSection(meetup),
                Padding(
                    padding: EdgeInsets.all(hypotenuse(
            MediaQuery.of(context).size.height * 0.04,
            MediaQuery.of(context).size.width * 0.04)),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
                            'Alps. Situated 1,578 meters above sea level, it is one of the '
                            'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
                            'half-hour walk through pastures and pine forest, leads you to the '
                            'lake, which warms to 20 degrees Celsius in the summer. Activities '
                            'enjoyed here include rowing, and riding the summer toboggan run.')))
              ],
            )
          : Container(width: 0, height: 0),
      appBar: AppBar(title: Text('Detalles del Meetup')),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final Meetup meetup;

  HeaderSection(this.meetup);

  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print(height);
    print(height * 0.4);

    return Stack(
      //IMPORTANTE PARA ALINEAR COMPONENTE EN LA PARTE DE ABAJO DE LA IMAGEN

      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        Image.network(meetup.image,
            width: width, height: height * 0.4, fit: BoxFit.cover),
        Container(
            width: width,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.03),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      'https://cdn1.vectorstock.com/i/thumb-large/82/55/anonymous-user-circle-icon-vector-18958255.jpg'),
                ),
                title: Text(meetup.title,
                    style: TextStyle(
                        fontSize: 20.0 * curScaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                subtitle: Text(meetup.shortInfo,
                    style: TextStyle(
                        fontSize: 17.0 * curScaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ))
      ],
    );
  }
}

class AdditionalInfoSection extends StatelessWidget {
  final Meetup meetup;

  AdditionalInfoSection(this.meetup);


  String _capitilize(String word) {
    return (word != null && word.isNotEmpty)
        ? word[0].toUpperCase() + word.substring(1)
        : '';
  }

  Widget _buildColumn(
      String label, String text, Color color, double curScaleFactor) {
    return Column(
      children: <Widget>[
        Text(label,
            style: TextStyle(
                fontSize: 13.0 * curScaleFactor,
                fontWeight: FontWeight.w400,
                color: color)),
        Text(_capitilize(text),
            style: TextStyle(
                fontSize: 25.0 * curScaleFactor,
                fontWeight: FontWeight.w500,
                color: color))
      ],
    );
  }

  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    Color color = Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildColumn('CATEGORIA', meetup.category.name, color, curScaleFactor),
        _buildColumn('DESDE', meetup.timeFrom, color, curScaleFactor),
        _buildColumn('HASTA', meetup.timeTo, color, curScaleFactor)
      ],
    );
  }
}

class TitleSection extends StatelessWidget {
  final Meetup meetup;

  TitleSection(this.meetup);

  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Padding(
        padding: EdgeInsets.all(hypotenuse(
            MediaQuery.of(context).size.height * 0.035,
            MediaQuery.of(context).size.width * 0.035)),
//  padding: EdgeInsets.all(30),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(meetup.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(meetup.shortInfo,
                      style: TextStyle(color: Colors.grey[500]))
                ],
              ),
            ),
            Icon(Icons.people, color: color),
            Text('${meetup.joinedPeopleCount} People')
          ],
        ));
  }
}
