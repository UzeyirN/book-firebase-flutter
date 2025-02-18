import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_db_test/models/renter_model.dart';

class Book {
  final String id;
  final String bookName;
  final String authorName;
  final Timestamp publishDate;
  final List<RenterInfo> renters;

  Book({
    required this.id,
    required this.bookName,
    required this.authorName,
    required this.publishDate,
    required this.renters,
  });

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> renters =
        this.renters.map((renterInfo) => renterInfo.toMap()).toList();
    return {
      'id': id,
      'bookName': bookName,
      'authorName': authorName,
      'publishDate': publishDate,
      'renters': renters,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    var renterListAsMap = map['renters'] as List;
    List<RenterInfo> renters = renterListAsMap
        .map((renterAsMap) => RenterInfo.fromMap(renterAsMap))
        .toList();

    return Book(
      id: map['id'] as String,
      bookName: map['bookName'] as String,
      authorName: map['authorName'] as String,
      publishDate: map['publishDate'] as Timestamp,
      renters: renters,
    );
  }
}
