import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_db_test/models/book_model.dart';

class Database {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// READ
  Stream<QuerySnapshot> getBookListFromAPI(String referencePath) {
    return firestore.collection(referencePath).snapshots();
  }

  String getBookFromAPI(String referencePath, String id) {
    return firestore.collection(referencePath).doc(id).id;
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

  Future<void> updateBookData(String collectionPath, String id,
      Map<String, dynamic> updatedData) async {
    await firestore.collection(collectionPath).doc(id).update(updatedData);
  }
}
