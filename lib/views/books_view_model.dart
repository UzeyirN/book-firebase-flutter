import 'package:firestore_db_test/models/book_model.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';

class BooksViewModel extends ChangeNotifier {
  Database database = Database();
  String collectionPath = 'books';

  Stream<List<Book>> getBookList() {
    /// stream<QuerySnapshot> --> stream<List<DocumentSnapshot>> --> stream<List<Book>>
    ///
    /// Ilk addim: stream<QuerySnapshot> --> stream<List<DocumentSnapshot>>
    var streamListDocument = database
        .getBookListFromAPI(collectionPath)
        .map((querySnapshot) => querySnapshot.docs);

    /// Ikinci addim: stream<List<DocumentSnapshot>> --> stream<List<Book>>
    Stream<List<Book>> streamListBook = streamListDocument.map(
        (listOfDocSnap) => listOfDocSnap
            .map((docSnap) =>
                Book.fromMap(docSnap.data() as Map<String, dynamic>))
            .toList());

    return streamListBook;
  }

  Future<void> deleteDocument(Book book) async {
    await database.deleteDocument(collectionPath, book.id);
  }
}
