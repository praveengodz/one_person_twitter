import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  String email;
  String tweet;
  Timestamp date;
  final DocumentReference reference;

  Tweet.fromMap(Map<String, dynamic> map, {this.reference})
      : email = map['email'],
        tweet = map['tweet'],
        date = map['date'];

  Tweet.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Tweet";
}