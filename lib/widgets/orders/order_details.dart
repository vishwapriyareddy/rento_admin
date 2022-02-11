import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rento_admin/services/firebase_services.dart';

class OrderDetails extends StatefulWidget {
  final DocumentSnapshot document;
  const OrderDetails({Key? key, required this.document}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  FirebaseServices _services = FirebaseServices();
  DocumentSnapshot? _customer;
  @override
  void initState() {
    _services.getcustomerdetails(widget.document.get('userId')).then((value) {
      if (mounted) {
        if (value != null) {
          setState(() {
            _customer = value;
          });
        } else {
          print('no Data');
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _customer != null ? Text(_customer!.get('number')) : Text(""),
      ],
    );
  }
}
