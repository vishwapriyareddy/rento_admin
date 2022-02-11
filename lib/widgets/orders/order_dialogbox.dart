import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rento_admin/constants.dart';
import 'package:rento_admin/main.dart';
import 'package:rento_admin/services/firebase_services.dart';
import 'package:rento_admin/services/order_services.dart';

class OrderDetailsBox extends StatefulWidget {
  final DocumentSnapshot document;

  const OrderDetailsBox({Key? key, required this.document}) : super(key: key);

  @override
  State<OrderDetailsBox> createState() => _OrderDetailsBoxState();
}

class _OrderDetailsBoxState extends State<OrderDetailsBox> {
  // FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _orderServices.orders.doc().get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot>? snapshot) {
        if (snapshot!.hasError) {
          return Text('Something Went Wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ExpansionTile(
              title: Text(
                'Order details',
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
              subtitle: Text('View Order Details',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            // backgroundColor: Colors.white,
                            child: Image.network(
                                widget.document.get('serviceBookings')[index]
                                    ['serviceImage'])),
                        title: Text(
                          widget.document.get('serviceBookings')[index]
                              ['serviceName'],
                          style: TextStyle(color: Colors.grey),
                        ),
                        subtitle: Text(
                          '${widget.document.get('serviceBookings')[index]['price'].toString()}',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    );
                  },
                  itemCount: widget.document.get('serviceBookings').length,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 12, top: 8, bottom: 8),
                  child: Card(
                    child: Column(
                      children: [
                        Row(children: [
                          Text('Service : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                              widget.document.get('supervoisor')['serviceName'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ])
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ServiceProviderDetails extends StatefulWidget {
  const ServiceProviderDetails({Key? key}) : super(key: key);

  @override
  _ServiceProviderDetailsState createState() => _ServiceProviderDetailsState();
}

class _ServiceProviderDetailsState extends State<ServiceProviderDetails> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
