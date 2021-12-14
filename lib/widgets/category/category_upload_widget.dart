import 'dart:html';
import 'package:firebase/firebase.dart' as db;

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rento_admin/services/firebase_services.dart';

class CategoryCreateWidget extends StatefulWidget {
  const CategoryCreateWidget({Key? key}) : super(key: key);

  @override
  _CategoryCreateWidgetState createState() => _CategoryCreateWidgetState();
}

class _CategoryCreateWidgetState extends State<CategoryCreateWidget> {
  FirebaseServices _services = FirebaseServices();
  var _fileNameTextController = TextEditingController();
  var _categoryNameTextController = TextEditingController();

  bool _visible = false;
  bool _imageSelected = true;
  String _url = '';
  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0xFF3c5784).withOpacity(.3),
        animationDuration: Duration(milliseconds: 500));
    return Container(
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Row(
          children: [
            Visibility(
              visible: _visible,
              child: Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 30,
                      child: TextField(
                        controller: _categoryNameTextController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1)),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'No category name given',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 20)),
                      ),
                    ),
                    AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(
                          width: 200,
                          height: 30,
                          child: TextField(
                            controller: _fileNameTextController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'No Image Selected',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(left: 20)),
                          )),
                    ),
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black54)),
                      onPressed: () {
                        uploadStorage();
                      },
                      child: Center(
                          child: Text(
                        "Upload Image",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontStyle: FontStyle.italic),
                      )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AbsorbPointer(
                      absorbing: _imageSelected,
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                _imageSelected
                                    ? Colors.black12
                                    : Colors.black54)),
                        onPressed: () async {
                          if (_categoryNameTextController.text.isEmpty) {
                            return await _services.showMyDialog(
                                context: context,
                                title: 'Add New Category',
                                message: 'New Category name not given');
                          }
                          progressDialog.show();
                          _services
                              .uploadCategoryImageToDb(
                                  _url, _categoryNameTextController.text)
                              .then((downloadUrl) {
                            if (downloadUrl != null) {
                              progressDialog.dismiss();
                              _services.showMyDialog(
                                title: 'New Category',
                                message: 'Saved New Category Successfully',
                                context: context,
                              );
                            }
                          });
                          _categoryNameTextController.clear();
                          _fileNameTextController.clear();
                        },
                        child: Center(
                            child: Text(
                          "Save New Category",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _visible ? false : true,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black54)),
                onPressed: () {
                  setState(() {
                    _visible = true;
                  });
                },
                child: Center(
                    child: Text(
                  "Add New Category",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void uploadImage({required Function(File file) onSelected}) {
    InputElement uploadInput = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  void uploadStorage() {
    //upload selected image to Firebase storage
    final dateTime = DateTime.now();
    final path = 'categoryImage/$dateTime';
    uploadImage(onSelected: (file) {
      if (file != null) {
        setState(() {
          _fileNameTextController.text = file.name;
          _imageSelected = false;
          _url = path;
        });
        // Reference firebaseStorageRef = FirebaseStorage.instance
        //     .ref('CategoryImage/$dateTime')
        //     .child(file.name);
        // UploadTask uploadTask = firebaseStorageRef.putFile(file);
        // uploadTask.whenComplete(() async {
        //   String imgUrl = await firebaseStorageRef.getDownloadURL();
        // });
        db
            .storage()
            .refFromURL('gs://rento-users.appspot.com')
            .child(path)
            .put(file);
      }
    });
  }
}
