import 'package:cloud_firestore/cloud_firestore.dart';

class MyObject {
  final String country;
  final String countryName;
  final String image;

  MyObject(
      {required this.country, required this.countryName, required this.image});

  MyObject.fromSnapshot(DocumentSnapshot snapshot)
      : country = snapshot['country'],
        countryName = snapshot['country'],
        image = snapshot['image'];
}

class Place {
  final String place;
  final String church;
  final String imageLink;

  Place({required this.place, required this.church, required this.imageLink});

  Place.fromSnapshot(DocumentSnapshot snapshot)
      : place = snapshot['place'],
        church = snapshot['church'],
        imageLink = snapshot['image'];
}

class MyMeetingObject {
  final String meeting;
  final String meetingId;

  MyMeetingObject({required this.meeting, required this.meetingId});

  MyMeetingObject.fromSnapshot(DocumentSnapshot snapshot)
      : meeting = snapshot['meeting'],
        meetingId = snapshot['meeting'];
}

class Year {
  final String year;

  Year({required this.year});

  Year.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        year = snapshot['year'];
}
