import 'package:firestore_db_test/services/database.dart';
import 'package:firestore_db_test/services/time_calculator.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';

class AddBookViewModel extends ChangeNotifier {
  Database database = Database();
  String collectionPath = 'books';

  Future<void> addBook({
    required String bookName,
    required String authorName,
    required DateTime publishDate,
  }) async {
    /// Form-daki datalar ile Book objecti yaradacaq
    Book newBook = Book(
      id: DateTime.now().toIso8601String(),
      bookName: bookName,
      authorName: authorName,
      publishDate: TimeCalculator.dateTimeToStamp(publishDate),
      renters: [],
    );

    /// Ve bu kitabi DB servisi uzerinden FB-e elave edecek
    database.setBookData(
        collectionPath: collectionPath, bookAsMap: newBook.toMap());
  }
}
