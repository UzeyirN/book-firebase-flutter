import 'package:firestore_db_test/views/add_book_view.dart';
import 'package:firestore_db_test/views/books_view_model.dart';
import 'package:firestore_db_test/views/renter_list_view.dart';
import 'package:firestore_db_test/views/update_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';

class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BooksViewModel>(
      create: (_) => BooksViewModel(),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('Book list'),
        ),
        body: Center(
          child: Column(
            children: [
              Divider(),
              StreamBuilder<List<Book>>(
                stream: Provider.of<BooksViewModel>(context, listen: false)
                    .getBookList(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error happened,Please check it later '),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<Book>? bookList = snapshot.data;
                  return BuildListData(bookList: bookList);
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBookView(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class BuildListData extends StatefulWidget {
  const BuildListData({
    super.key,
    required this.bookList,
  });

  final List<Book>? bookList;

  @override
  State<BuildListData> createState() => _BuildListDataState();
}

class _BuildListDataState extends State<BuildListData> {
  bool isFiltering = false;
  List<Book> filteredList = [];

  @override
  Widget build(BuildContext context) {
    var fullList = widget.bookList;
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: TextField(
              onChanged: (query) {
                if (query.isNotEmpty) {
                  isFiltering = true;
                  setState(() {
                    filteredList = fullList!
                        .where((book) => book.bookName
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  });
                } else {
                  WidgetsBinding.instance.focusManager.primaryFocus!.unfocus();
                  setState(() {
                    isFiltering = false;
                  });
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search book',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: isFiltering ? filteredList.length : fullList!.length,
              itemBuilder: (context, index) {
                var list = isFiltering ? filteredList : fullList;
                return Slidable(
                  key: ValueKey(list?[index].id),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    dismissible: DismissiblePane(
                      onDismissed: () {
                        context
                            .read<BooksViewModel>()
                            .deleteDocument(list![index]);
                      },
                    ),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          context
                              .read<BooksViewModel>()
                              .deleteDocument(list![index]);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateBookView(
                                book: list![index],
                              ),
                            ),
                          );
                        },
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  startActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RenterListView(
                                book: list![index],
                              ),
                            ),
                          );
                        },
                        backgroundColor: Color(0xFF0392CF),
                        foregroundColor: Colors.white,
                        icon: Icons.attach_money,
                        label: 'Rent',
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(list![index].bookName),
                      subtitle: Text(list[index].authorName),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
