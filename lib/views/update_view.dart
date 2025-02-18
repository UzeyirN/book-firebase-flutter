import 'package:firestore_db_test/models/book_model.dart';
import 'package:firestore_db_test/services/time_calculator.dart';
import 'package:firestore_db_test/views/update_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateBookView extends StatefulWidget {
  final Book book;

  const UpdateBookView({super.key, required this.book});

  @override
  State<UpdateBookView> createState() => _UpdateBookViewState();
}

class _UpdateBookViewState extends State<UpdateBookView> {
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
    bookController.text = widget.book.bookName;
    authorController.text = widget.book.authorName;
    publishController.text = TimeCalculator.dateTimeToString(
      TimeCalculator.dateTimeFromTimestamp(widget.book.publishDate),
    );
    return ChangeNotifierProvider<UpdateBookViewModel>(
      create: (_) => UpdateBookViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text('UPDATE BOOK DATA'),
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
                      await context.read<UpdateBookViewModel>().updateBook(
                            bookName: bookController.text,
                            authorName: authorController.text,
                            publishDate: selectedDate ??
                                TimeCalculator.dateTimeFromTimestamp(
                                    widget.book.publishDate),
                            book: widget.book,
                          );

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'UPDATE',
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
