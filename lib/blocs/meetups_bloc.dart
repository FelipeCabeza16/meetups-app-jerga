import 'dart:async';

import 'package:meetups_app/blocs/bloc_provider.dart';
import 'package:meetups_app/models/meetups.dart';
import 'package:meetups_app/models/user.dart';
import 'package:meetups_app/services/auth_api_provider.dart';
import 'package:meetups_app/services/meetup_api_provider.dart';

class MeetupBloc implements BlocBase {
  final MeetupApiService _api = MeetupApiService();
  final AuthApiService _auth = AuthApiService();

  final StreamController<List<Meetup>> _meetupController =
      StreamController.broadcast();
  Stream<List<Meetup>> get meetups => _meetupController.stream;
  StreamSink<List<Meetup>> get _inMeetups => _meetupController.sink;

  final StreamController<Meetup> _meetupDetailController =
      StreamController.broadcast();
  Stream<Meetup> get meetup => _meetupDetailController.stream;
  StreamSink<Meetup> get _inMeetup => _meetupDetailController.sink;

  void fetchMeetups() async {
    final meetups = await _api.fetchMeetups();
    _inMeetups.add(meetups);
  }

  void fetchMeetup(String meetupId) async {
    final meetup = await _api.fetchMeetupById(meetupId);
    _inMeetup.add(meetup);
  }

void joinMeetup(Meetup meetup) {
    _api.joinMeetup(meetup.id)
      .then((_) {
        User user = _auth.authUser;
        user.joinedMeetups.add(meetup.id);

        meetup.joinedPeople.add(user);
        meetup.joinedPeopleCount++;
        _inMeetup.add(meetup);
      })
      .catchError((err) => print(err));
  }

  void leaveMeetup(Meetup meetup) {
    _api.leaveMeetup(meetup.id)
      .then((_) {
        User user = _auth.authUser;
        user.joinedMeetups.removeWhere((jMeetup) => jMeetup == meetup.id);

        meetup.joinedPeople.removeWhere((jUser) => jUser.id == user.id);
        meetup.joinedPeopleCount--;
        _inMeetup.add(meetup);
      })
      .catchError((err) => print(err));
  }
  
  void dispose() {
    _meetupController.close();
    _meetupDetailController.close();
  }
}
