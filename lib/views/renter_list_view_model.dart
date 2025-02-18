import 'package:firestore_db_test/models/renter_model.dart';
import 'package:firestore_db_test/services/database.dart';
import 'package:flutter/cupertino.dart';

import '../models/book_model.dart';

class RenterListViewModel extends ChangeNotifier {
  Database database = Database();
  String collectionPath = 'books';

  Future<void> updateBook(
      {required List<RenterInfo> renterList, required Book book}) async {
    Book newBook = Book(
      id: book.id,
      bookName: book.bookName,
      authorName: book.authorName,
      publishDate: book.publishDate,
      renters: renterList,
    );

    await database.setBookData(
        collectionPath: collectionPath, bookAsMap: newBook.toMap());
  }
}
