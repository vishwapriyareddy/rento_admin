import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference banners = FirebaseFirestore.instance.collection('slider');
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<DocumentSnapshot> getAdmincredentials(id) {
    var result = FirebaseFirestore.instance.collection('Admin').doc(id).get();
    return result;
  }

//Banner
  Future<String> uploadBannerImageToDb(url) async {
    String downloadUrl = await storage.ref(url).getDownloadURL();
    if (downloadUrl != null) {
      firestore.collection('slider').add({'image': downloadUrl});
    }
    return downloadUrl;
  }

  deleteBannerImageFromDb(id) async {
    firestore.collection('slider').doc(id).delete();
  }

//Vendor
  updateVendorStatus({id, status}) async {
    vendors.doc(id).update({
      'accVerified': status ? false : true,
    });
  }

  updateTopPickedStatus({id, status}) async {
    vendors.doc(id).update({'isTopPicked': status ? false : true});
  }

  Future<String> uploadCategoryImageToDb(url, catName) async {
    String downloadUrl = await storage.ref(url).getDownloadURL();
    if (downloadUrl != null) {
      category.doc(catName).set({'image': downloadUrl, 'name': catName});
    }
    return downloadUrl;
  }

//Category(new code)
  Future<void> saveCategory(Map<String, dynamic> data) {
    return category.doc(data['name']).set(data);
  }

  Future<void> confirmDeleteDialog({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteBannerImageFromDb(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog({title, message, context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
