import 'dart:html';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rento_admin/main.dart';
import 'package:rento_admin/services/firebase_services.dart';
import 'package:rento_admin/widgets/vendor/vendor_details_box.dart';

class VendorDataTable extends StatefulWidget {
  VendorDataTable({Key? key}) : super(key: key);

  @override
  State<VendorDataTable> createState() => _VendorDataTableState();
}

class _VendorDataTableState extends State<VendorDataTable> {
  final ScrollController controller = ScrollController();
  FirebaseServices _services = FirebaseServices();
  int tag = 0;
  List<String> options = [
    'All Vendors',
    'Active Vendors',
    'Inactive Vendors',
    'Top Picked',
    'Top Rated',
  ];
  bool? topPicked;
  bool? active;
  filter(val) {
    if (val == 1) {
      setState(() {
        active = true;
      });
    }
    if (val == 2) {
      setState(() {
        active = false;
      });
    }
    if (val == 3) {
      setState(() {
        topPicked = true;
      });
    }
    if (val == 0) {
      setState(() {
        topPicked = null;
        active = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipsChoice<int>.single(
          choiceActiveStyle: const C2ChoiceStyle(
            color: Colors.black54,
            brightness: Brightness.dark,
          ),
          value: tag,
          onChanged: (val) {
            setState(() {
              tag = val;
            });
            filter(val);
          },
          choiceItems: C2Choice.listFrom<int, String>(
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
        ),
        Divider(
          thickness: 5,
        ),
        StreamBuilder<QuerySnapshot?>(
            stream: _services.vendors
                .where('isTopPicked', isEqualTo: topPicked)
                .where('accVerifired', isEqualTo: active)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
              if (snapshot.hasError) {
                return Text('Something Went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: SingleChildScrollView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Active/Inactive')),
                      DataColumn(label: Text('Top Picked')),
                      DataColumn(label: Text('Service Name')),
                      DataColumn(label: Text('Service rating')),
                      DataColumn(label: Text('Total Services')),
                      DataColumn(label: Text('Mobile')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('View Details')),
                    ],
                    rows: _vendorDetailrows(snapshot.data!, _services),
                    showBottomBorder: true,
                    dataRowHeight: 60,
                    headingRowColor:
                        MaterialStateProperty.all(Colors.grey[200]),
                  ),
                ),
              );
            }),
      ],
    );
  }

  List<DataRow> _vendorDetailrows(
      QuerySnapshot snapshot, FirebaseServices services) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(IconButton(
            onPressed: () {
              services.updateVendorStatus(
                  id: document.get('uid'), status: document.get('accVerified'));
            },
            icon: document.get('accVerified')
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ))), 
        DataCell(IconButton(
            onPressed: () {
              services.updateTopPickedStatus(
                  id: document.get('uid'), status: document.get('isTopPicked'));
            },
            icon: document.get('isTopPicked')
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ))),
        DataCell(Text(document.get('servicename'))),
        DataCell(Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.grey,
            ),
            Text('3.5')
          ],
        )),
        DataCell(Text('20,000')),
        DataCell(Text(document.get('mobile'))),
        DataCell(Text(document.get('email'))),
        DataCell(IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return VendorDetailsBox(uid: document.get('uid'));
                });
          },
          icon: Icon(Icons.info_outline),
        ))
      ]);
    }).toList();
    return newList;
  }
}
