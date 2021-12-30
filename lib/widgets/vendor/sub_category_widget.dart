import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rento_admin/services/firebase_services.dart';

class SubCategoryWidget extends StatefulWidget {
  final String categoryName;
  SubCategoryWidget({Key? key, required this.categoryName}) : super(key: key);

  @override
  _SubCategoryWidgetState createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  FirebaseServices _services = FirebaseServices();
  var _subCatNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: 300,
            child: FutureBuilder<DocumentSnapshot>(
                future: _services.category.doc(widget.categoryName).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.exists == 0) {
                    return Text('No Categories Added');
                  }
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Main Category : '),
                                Text(
                                  widget.categoryName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Divider(
                              thickness: 3,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Expanded(
                            child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(data['subCat'][index]['name']),
                            );
                          },
                          itemCount: data['subCat'] == null
                              ? 0
                              : data['subCat'].length,
                        )),
                      ),
                      Container(
                          child: Column(children: [
                        Divider(
                          thickness: 4,
                        ),
                        Container(
                          color: Colors.grey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Add New Category',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: SizedBox(
                                            height: 30,
                                            child: TextField(
                                              controller:
                                                  _subCatNameTextController,
                                              decoration: InputDecoration(
                                                  hintText: 'Sub Category Name',
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(),
                                                  focusedBorder:
                                                      OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 10)),
                                            ))),
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black54)),
                                      onPressed: () async {
                                        if (_subCatNameTextController
                                            .text.isEmpty) {
                                          return await _services.showMyDialog(
                                              context: context,
                                              title: 'Add New Subcategory',
                                              message:
                                                  'Need to give Subcategory name');
                                        }
                                        DocumentReference doc = _services
                                            .category
                                            .doc(widget.categoryName);
                                        doc.update({
                                          'subCat': FieldValue.arrayUnion([
                                            {
                                              'name':
                                                  _subCatNameTextController.text
                                            }
                                          ])
                                        });
                                        setState(() {});
                                        _subCatNameTextController.clear();
                                      },
                                      child: Center(
                                          child: Text(
                                        "Save",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic),
                                      )),
                                    ),
                                  ],
                                )
                              ]),
                        )
                      ]))
                    ],
                  );
                })),
      ),
    );
  }
}
