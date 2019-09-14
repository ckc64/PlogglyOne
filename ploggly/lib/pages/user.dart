import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String id;
  final String photoUrl;
  final String displayName;
  final String bio;
  final String age;
  final String birthdate;
  final String name;
  final String gender;

  User({this.id, this.photoUrl, 
  this.displayName, this.bio, this.age, this.birthdate, this.name, this.gender});

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      id:doc['userid'],
      displayName: doc['username'],
      photoUrl: doc['profpic'],
      bio:doc['bio'],
      age:doc['age'],
      birthdate: doc['birthdate'],
      name: doc['name'],
      gender: doc['gender']
    );
  }
}