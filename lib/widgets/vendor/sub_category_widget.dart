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
  @override
  Widget build(BuildContext context) {
    return Dialog(
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

              // if (snapshot.hasData && !snapshot.data!.exists) {
              //   return Text("Document does not exist");
              // }

              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return Center(child: Text('No SubCategories Added'));
                }
                // Map<String, dynamic> data =
                //     snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [],
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          )),
    );
  }
}
