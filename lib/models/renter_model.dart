import 'package:cloud_firestore/cloud_firestore.dart';

class RenterInfo {
  final String name;
  final String surname;
  final String? photoUrl;
  final Timestamp rentDay;
  final Timestamp returnDay;

  RenterInfo({
    required this.name,
    required this.surname,
    required this.photoUrl,
    required this.rentDay,
    required this.returnDay,
  });

  /// object --> map

  Map<String, dynamic> toMap() => {
        'name': name,
        'surname': surname,
        'photoUrl': photoUrl,
        'rentDay': rentDay,
        'returnDay': returnDay,
      };

  /// map --> object

  factory RenterInfo.fromMap(Map map) => RenterInfo(
        name: map['name'],
        surname: map['surname'],
        photoUrl: map['photoUrl'],
        rentDay: map['rentDay'],
        returnDay: map['returnDay'],
      );
}
