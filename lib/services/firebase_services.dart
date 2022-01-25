import 'package:ars_progress_dialog/ars_progress_dialog.dart';
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
  CollectionReference boys = FirebaseFirestore.instance.collection('boys');
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

  Future<void> saveServiceProviderBoys(email, password) async {
    boys.doc(email).set({
      'accVerified': false,
      'address': '',
      'email': email,
      'imageUrl': '',
      'location': GeoPoint(0, 0),
      'mobile': '',
      'name': '',
      'password': password,
      'uid': ''
    });
  }

  updateBoyStatus({id, context, status}) {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0xFF3c5784).withOpacity(.3),
        animationDuration: Duration(milliseconds: 500));
    progressDialog.show();
    // Create a reference to the document the transaction will use
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('boys').doc(id);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      // Update the follower count based on the current count
      // Note: this could be done without a transaction
      // by updating the population using FieldValue.increment()

      // Perform an update on the document
      transaction.update(documentReference, {'accVerified': status});

      // Return the new count
    }).then((value) {
      progressDialog.dismiss();
      showMyDialog(
          title: "Service Provider status",
          message: status == true
              ? "Service provider approved Status Updated as Approved"
              : "Service provider approved Status Updated as Not Approved",
          context: context);
    }).catchError((error) => showMyDialog(
        title: "Service Provider status",
        message: "Failed to update Service provider status: $error",
        context: context));
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
