import 'package:firestore_db_test/services/time_calculator.dart';
import 'package:firestore_db_test/views/add_book_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookView extends StatefulWidget {
  const AddBookView({super.key});

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  TextEditingController bookController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController publishController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var selectedDate;

  @override
  void dispose() {
    bookController.dispose();
    authorController.dispose();
    publishController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookViewModel>(
      create: (_) => AddBookViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text('ADD BOOK'),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: bookController,
                  decoration: InputDecoration(
                    hintText: 'Book name',
                    icon: Icon(Icons.book),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return " Book name can't be empty! ";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: authorController,
                  decoration: InputDecoration(
                    hintText: 'Author name',
                    icon: Icon(Icons.edit),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return " Author name can't be empty! ";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  onTap: () async {
                    selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(-1000),
                      lastDate: DateTime.now(),
                    );
                    publishController.text =
                        TimeCalculator.dateTimeToString(selectedDate!);
                  },
                  controller: publishController,
                  decoration: InputDecoration(
                    hintText: 'Publish date',
                    icon: Icon(Icons.date_range),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return " Publish can't be empty! ";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await context.read<AddBookViewModel>().addBook(
                            bookName: bookController.text,
                            authorName: authorController.text,
                            publishDate: selectedDate,
                          );

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
