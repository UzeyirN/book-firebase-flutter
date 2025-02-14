import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String bookName;
  final String authorName;
  final Timestamp publishDate;

  Book({
    required this.id,
    required this.bookName,
    required this.authorName,
    required this.publishDate,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'bookName': bookName,
        'authorName': authorName,
        'publishDate': publishDate,
      };

  factory Book.fromMap(Map<String, dynamic> map) => Book(
        id: map['id'] as String,
        bookName: map['bookName'] as String,
        authorName: map['authorName'] as String,
        publishDate: map['publishDate'] as Timestamp,
      );
}
