// import 'package:firestore_db_test/services/database.dart';
// import 'package:flutter/material.dart';
//
// class UpdateViewModel extends ChangeNotifier {
//   Database database = Database();
//   String collectionPath = 'books';
//
//   String getBook(String id) {
//     return database.getBookFromAPI(collectionPath, id);
//   }
//
//   Future<void> updateBook(String id, Map<String, dynamic> updatedData) async {
//     await database.updateBookData(collectionPath, id, updatedData);
//   }
// }

import 'package:firestore_db_test/services/database.dart';
import 'package:firestore_db_test/services/time_calculator.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';

class UpdateBookViewModel extends ChangeNotifier {
  Database database = Database();
  String collectionPath = 'books';

  Future<void> updateBook({
    required String bookName,
    required String authorName,
    required DateTime publishDate,
    required Book book,
  }) async {
    /// Form-daki datalar ile Book objecti yaradacaq
    Book updatedBook = Book(
      id: book.id,
      bookName: bookName,
      authorName: authorName,
      publishDate: TimeCalculator.dateTimeToStamp(publishDate),
      renters: book.renters,
    );

    /// Ve bu kitabi DB servisi uzerinden FB-e elave edecek
    await database.setBookData(
        collectionPath: collectionPath, bookAsMap: updatedBook.toMap());
  }
}
