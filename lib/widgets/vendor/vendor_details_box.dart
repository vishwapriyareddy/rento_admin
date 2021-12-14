import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rento_admin/constants.dart';
import 'package:rento_admin/main.dart';
import 'package:rento_admin/services/firebase_services.dart';

class VendorDetailsBox extends StatefulWidget {
  final String uid;
  const VendorDetailsBox({Key? key, required this.uid}) : super(key: key);

  @override
  State<VendorDetailsBox> createState() => _VendorDetailsBoxState();
}

class _VendorDetailsBoxState extends State<VendorDetailsBox> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _services.vendors.doc(widget.uid).get(),
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
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * .3,
                  child: ListView(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image(
                                image: NetworkImage(
                                  snapshot.data!['imageUrl'],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Container(
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Text(
                              //       snapshot.data!['servicename'],
                              //       overflow: TextOverflow.ellipsis,
                              //       maxLines: 2,
                              //       style: TextStyle(
                              //           fontWeight: FontWeight.bold, fontSize: 25),
                              //     ),
                              //   ),
                              // ),
                              RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 22),
                                    text: snapshot.data!['servicename'],
                                  )),
                              Text(snapshot.data!['dialog'])
                            ],
                          )
                        ],
                      ),
                      Divider(
                        thickness: 4,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    'Contact Number',
                                    style: vendorDetailsTextstyle,
                                  ),
                                )),
                                // ignore: prefer_const_constructors
                                Container(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Text(':'),
                                )),
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    snapshot.data!['mobile'],
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    'Email',
                                    style: vendorDetailsTextstyle,
                                  ),
                                )),
                                // ignore: prefer_const_constructors
                                Container(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Text(':'),
                                )),
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    snapshot.data!['email'],
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    'Address',
                                    style: vendorDetailsTextstyle,
                                  ),
                                )),
                                // ignore: prefer_const_constructors
                                Container(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Text(':'),
                                )),
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    snapshot.data!['address'],
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Text(
                                    'Top Pick Status',
                                    style: vendorDetailsTextstyle,
                                  ),
                                )),
                                // ignore: prefer_const_constructors
                                Container(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Text(':'),
                                )),
                                Expanded(
                                    child: Container(
                                  child: snapshot.data!['isTopPicked']
                                      ? Chip(
                                          backgroundColor: Colors.green,
                                          label: Row(
                                            children: [
                                              Icon(Icons.check,
                                                  color: Colors.white),
                                              Text(
                                                'Top Picked',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Wrap(
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            CupertinoIcons.money_dollar_circle,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Total Revenue'),
                                          Text('20,000'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Active Orders'),
                                          Text('6'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.shopping_bag,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Total Orders'),
                                          Text('130'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.grain_outlined,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Services'),
                                          Text('20 Services'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(.9),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.list_alt_outlined,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Statement'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  child: snapshot.data!['accVerified']
                      ? Chip(
                          backgroundColor: Colors.green,
                          label: Row(
                            children: const [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                'Active',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : Chip(
                          backgroundColor: Colors.red,
                          label: Row(
                            children: const [
                              Icon(
                                Icons.remove_circle,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                'Inactive',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                  top: 10,
                  right: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
