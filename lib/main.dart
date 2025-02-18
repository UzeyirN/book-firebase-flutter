import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_db_test/db_constant.dart';
import 'package:firestore_db_test/views/books_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //FirebaseStorage.instance.useStorageEmulator('10.0.2.2', 9199);
  //await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initalization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>(
      initialData: null,
      create: (_) => dataBase.collection('books').snapshots(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          primaryColor: Colors.blueAccent,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueAccent,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
          ),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: _initalization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Undefined error'),
              );
            } else if (snapshot.hasData) {
              return BooksView();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
