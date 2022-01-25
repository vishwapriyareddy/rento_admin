import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:rento_admin/services/firebase_services.dart';

class ApprovedBoys extends StatefulWidget {
  const ApprovedBoys({Key? key}) : super(key: key);

  @override
  State<ApprovedBoys> createState() => _ApprovedBoysState();
}

class _ApprovedBoysState extends State<ApprovedBoys> {
  bool status = false;
  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot?>(
          stream:
              _services.boys.where('accVerified', isEqualTo: true).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
            if (snapshot.hasError) {
              return Text('Something Went Wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            QuerySnapshot snap = snapshot.data!;
            if (snap.size == 0) {
              return Center(
                  child: Text('No Approved Service providers to List'));
            }
            return SingleChildScrollView(
              child: DataTable(
                columns: <DataColumn>[
                  DataColumn(label: Expanded(child: Text('Profile Pic'))),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Mobile')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _boysList(snapshot.data!, _services, context),
                showBottomBorder: true,
                dataRowHeight: 50,
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              ),
            );
          }),
    );
  }

  List<DataRow> _boysList(
      QuerySnapshot snapshot, FirebaseServices services, context) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      // if (document != null) {
      return DataRow(cells: [
        DataCell(Container(
          width: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              document.get('imageUrl'),
              fit: BoxFit.contain,
            ),
          ),
        )),
        DataCell(Text(
          document.get('name'),
        )),
        DataCell(Text(
          document.get('email'),
        )),
        DataCell(Text(
          document.get('mobile'),
        )),
        DataCell(Text(
          document.get('address'),
        )),
        DataCell(
          FlutterSwitch(
            activeText: "Approved",
            inactiveText: "Not Approved",
            value: document.get('accVerified'),
            valueFontSize: 10.0,
            width: 110,
            borderRadius: 30.0,
            showOnOff: true,
            onToggle: (val) {
              _services.updateBoyStatus(
                  id: document.id, context: context, status: false);
            },
          ),
        ),
      ]);
    }).toList();
    return newList;
  }
}
