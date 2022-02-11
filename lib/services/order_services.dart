import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OrderServices {
  //User user = FirebaseAuth.instance.currentUser!;

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updateOrderStatus(documentId, status) {
    var result = orders.doc(documentId).update({'orderStatus': status});
    return result;
  }

  // Future<double?> checkSupervisor() async {
  //   final snapshot = await orders.doc(user.uid).get();
  //   return snapshot.exists ? snapshot.get('userLocation') : null;
  // }

  Color? statusColor(DocumentSnapshot document) {
    if (document.get('orderStatus') == 'Accepted') {
      return Colors.blueGrey[400];
    }
    if (document.get('orderStatus') == 'Rejected') {
      return Colors.red;
    }
    if (document.get('orderStatus') == 'On the Way') {
      return Colors.purple[900];
    }
    if (document.get('orderStatus') == 'Service Start') {
      return Colors.pink[900];
    }
    if (document.get('orderStatus') == 'Service Completed') {
      return Colors.green;
    }
    return Colors.orange;
  }

  Icon? statusIcon(DocumentSnapshot document) {
    if (document.get('orderStatus') == 'Accepted') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'Rejected') {
      return Icon(
        Icons.assignment_late_outlined,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'On the Way') {
      return Icon(
        Icons.delivery_dining,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'Service Start') {
      return Icon(
        Icons.sailing,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'Service Completed') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    return Icon(
      Icons.assignment_turned_in_outlined,
      color: statusColor(document),
    );
  }

  String statusComment(DocumentSnapshot document) {
    if (document.get('orderStatus') == 'On the Way') {
      return 'Service provider ${document.get('serviceProvider')['name']} is on the way ';
    }
    if (document.get('orderStatus') == 'Service Start') {
      return 'Service started by ${document.get('serviceProvider')['name']}';
    }
    if (document.get('orderStatus') == 'Service Completed') {
      return 'Service is now completed ';
    }
    return 'Service provider ${document.get('serviceProvider')['name']} is on the way';
  }
}
