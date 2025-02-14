// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firestore_db_test/views/update_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../services/time_calculator.dart';
//
// class UpdateView extends StatefulWidget {
//   final String bookID;
//   final String bookName;
//   final String authorName;
//   final Timestamp publishDate;
//
//   const UpdateView(
//       {super.key,
//       required this.bookID,
//       required this.bookName,
//       required this.authorName,
//       required this.publishDate});
//
//   @override
//   State<UpdateView> createState() => _UpdateViewState();
// }
//
// class _UpdateViewState extends State<UpdateView> {
//   final formKey = GlobalKey<FormState>();
//   TextEditingController bookController = TextEditingController();
//   TextEditingController authorController = TextEditingController();
//   TextEditingController publishController = TextEditingController();
//
//   @override
//   void dispose() {
//     bookController.dispose();
//     authorController.dispose();
//     publishController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     bookController.text = widget.bookName;
//     authorController.text = widget.authorName;
//     publishController.text =
//         TimeCalculator.timestampToString(widget.publishDate);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<UpdateViewModel>(
//       create: (_) => UpdateViewModel(),
//       builder: (context, child) => Scaffold(
//         appBar: AppBar(
//           title: Text('UPDATE'),
//         ),
//         body: Expanded(
//           child: Container(
//             padding: EdgeInsets.all(15),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextFormField(
//                     controller: bookController,
//                     decoration: InputDecoration(
//                       icon: Icon(Icons.book),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return " Book name can't be empty! ";
//                       } else {
//                         return null;
//                       }
//                     },
//                   ),
//                   TextFormField(
//                     controller: authorController,
//                     decoration: InputDecoration(
//                       icon: Icon(Icons.edit),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return " Author name can't be empty! ";
//                       } else {
//                         return null;
//                       }
//                     },
//                   ),
//                   TextFormField(
//                     controller: publishController,
//                     decoration: InputDecoration(
//                       icon: Icon(Icons.date_range),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return " Publish can't be empty! ";
//                       } else {
//                         return null;
//                       }
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (formKey.currentState!.validate()) {
//                         Map<String, dynamic> updatedData = {
//                           "bookName": bookController.text.isEmpty
//                               ? widget.bookName
//                               : bookController.text,
//                           "authorName": authorController.text.isEmpty
//                               ? widget.authorName
//                               : authorController.text,
//                           "publishDate": publishController.text.isEmpty
//                               ? widget.publishDate
//                               : TimeCalculator.dateTimeToStamp(
//                                   DateFormat('dd-MM-yyyy')
//                                       .parse(publishController.text)),
//                         };
//
//                         await context
//                             .read<UpdateViewModel>()
//                             .updateBook(widget.bookID, updatedData);
//
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: Text(
//                       'UPDATE',
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
