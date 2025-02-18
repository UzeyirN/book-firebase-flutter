import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_db_test/models/book_model.dart';

class Database {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// READ
  Stream<QuerySnapshot> getBookListFromAPI(String referencePath) {
    return firestore.collection(referencePath).snapshots();
  }

  /// DELETE
  Future<void> deleteDocument(String collectionPath, String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }

  /// CREATE (ADD)
  Future<void> setBookData(
      {required String collectionPath,
      required Map<String, dynamic> bookAsMap}) async {
    await firestore
        .collection(collectionPath)
        .doc(Book.fromMap(bookAsMap).id)
        .set(bookAsMap);
  }
}
