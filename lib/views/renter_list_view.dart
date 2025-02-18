import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_db_test/models/renter_model.dart';
import 'package:firestore_db_test/services/time_calculator.dart';
import 'package:firestore_db_test/views/renter_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';

/// Renter List
class RenterListView extends StatefulWidget {
  final Book book;

  const RenterListView({super.key, required this.book});

  @override
  State<RenterListView> createState() => _RenterListViewState();
}

class _RenterListViewState extends State<RenterListView> {
  @override
  Widget build(BuildContext context) {
    var renterList = widget.book.renters;
    return ChangeNotifierProvider<RenterListViewModel>(
      create: (_) => RenterListViewModel(),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: Text('${widget.book.bookName} Renter list'),
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: renterList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              (renterList[index].photoUrl == null ||
                                      renterList[index].photoUrl!.isEmpty)
                                  ? NetworkImage(
                                      'https://i0.wp.com/sportytell.com/wp-content/uploads/2018/12/Lionel-Messi-of-FC-Barcelona.jpg?fit=1920%2C1080&ssl=1',
                                    )
                                  : NetworkImage(renterList[index].photoUrl!),
                        ),
                        title: Text(
                            '${renterList[index].name} ${renterList[index].surname}'),
                      ),
                    );
                  },
                  separatorBuilder: (context, _) => Divider(),
                ),
              ),
              InkWell(
                onTap: () async {
                  RenterInfo newRenterInfo = await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return RenterForm();
                    },
                  );

                  setState(
                    () {
                      renterList.add(newRenterInfo);
                    },
                  );
                  context.read<RenterListViewModel>().updateBook(
                        renterList: renterList,
                        book: widget.book,
                      );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 80,
                  color: Colors.blueAccent,
                  child: Text(
                    'NEW RENT',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renter Form
class RenterForm extends StatefulWidget {
  const RenterForm({super.key});

  @override
  State<RenterForm> createState() => _RenterFormState();
}

class _RenterFormState extends State<RenterForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameCtr = TextEditingController();
  TextEditingController surnameCtr = TextEditingController();
  TextEditingController rentDayCtr = TextEditingController();
  TextEditingController returnDayCtr = TextEditingController();
  DateTime? _selectedRentDay;
  DateTime? _selectedReturnDay;

  File? image;

  /// imagePath
  String imagePath =
      'https://static.vecteezy.com/system/resources/previews/021/548/095/original/default-profile-picture-avatar-user-avatar-icon-person-icon-head-icon-profile-picture-icons-default-anonymous-user-male-and-female-businessman-photo-placeholder-social-network-avatar-portrait-free-vector.jpg';

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 200,
    );

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });

    if (pickedFile != null) {
      imagePath = await uploadImageToStorage(image!);
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    /// Create file name on Storage
    String path = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    /// Send file
    var uploadTask = await FirebaseStorage.instance
        .ref('photos')
        .child(path)
        .putFile(imageFile);

    String uploadedImageUrl = await uploadTask.ref.getDownloadURL();

    return uploadedImageUrl;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameCtr.dispose();
    surnameCtr.dispose();
    rentDayCtr.dispose();
    returnDayCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: (image == null)
                              ? NetworkImage(
                                  'https://i0.wp.com/sportytell.com/wp-content/uploads/2018/12/Lionel-Messi-of-FC-Barcelona.jpg?fit=1920%2C1080&ssl=1',
                                )
                              : FileImage(image!),
                        ),
                        Positioned(
                          bottom: -5,
                          right: -10,
                          child: IconButton(
                            onPressed: getImage,
                            icon: Icon(
                              Icons.photo_camera_rounded,
                              color: Colors.grey.shade100,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameCtr,
                          decoration: InputDecoration(
                            hintText: 'Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter name';
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          controller: surnameCtr,
                          decoration: InputDecoration(
                            hintText: 'Surname',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter surname';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: rentDayCtr,
                      onTap: () async {
                        _selectedRentDay = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                          initialDate: DateTime.now(),
                        );
                        rentDayCtr.text =
                            TimeCalculator.dateTimeToString(_selectedRentDay!);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.date_range),
                        hintText: 'Rent day',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose rent day';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(),
                  Flexible(
                    child: TextFormField(
                      controller: returnDayCtr,
                      decoration: InputDecoration(
                          hintText: 'Return day',
                          prefixIcon: Icon(Icons.date_range)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose return day';
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {
                        _selectedReturnDay = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        returnDayCtr.text = TimeCalculator.dateTimeToString(
                            _selectedReturnDay!);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    RenterInfo newRenterInfo = RenterInfo(
                      name: nameCtr.text,
                      surname: surnameCtr.text,
                      photoUrl: imagePath,
                      rentDay:
                          TimeCalculator.dateTimeToStamp(_selectedRentDay!),
                      returnDay:
                          TimeCalculator.dateTimeToStamp(_selectedReturnDay!),
                    );

                    Navigator.pop(context, newRenterInfo);
                  }
                },
                child: Text('ADD NEW RENTER'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
