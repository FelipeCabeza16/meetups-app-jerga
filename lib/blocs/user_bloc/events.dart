import 'package:meetups_app/models/meetups.dart';
import 'package:meta/meta.dart';

abstract class UserEvent {}

class CheckUserPermissionsOnMeetup extends UserEvent {
  Meetup meetup;

  CheckUserPermissionsOnMeetup({@required this.meetup});

  @override
  String toString() => 'CheckUserPermissionsOnMeetup';
}

class JoinMeetup extends UserEvent {

  @override
  String toString() => 'JoinMeetup';
}

class LeaveMeetup extends UserEvent {

  @override
  String toString() => 'LeaveMeetup';
}