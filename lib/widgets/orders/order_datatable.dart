import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rento_admin/main.dart';
import 'package:rento_admin/providers/order_provider.dart';
import 'package:rento_admin/services/firebase_services.dart';
import 'package:rento_admin/services/order_services.dart';
import 'package:rento_admin/widgets/orders/order_details.dart';
import 'package:rento_admin/widgets/orders/order_dialogbox.dart';

class OrderDataTable extends StatefulWidget {
  const OrderDataTable({Key? key}) : super(key: key);

  @override
  _OrderDataTableState createState() => _OrderDataTableState();
}

class _OrderDataTableState extends State<OrderDataTable> {
  OrderServices _orderServices = OrderServices();
  final ScrollController controller = ScrollController();
  FirebaseServices _services = FirebaseServices();

  int tag = 0;
  List<String> options = [
    'All Orders',
    'Ordered',
    'Accepted',
    'On the Way',
    'Start Service',
    'Service Completed',
  ];

  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);

    return Column(
      children: [
        // SizedBox(
        //   height: 56,
        //   width: MediaQuery.of(context).size.width,
        //   child: ChipsChoice<int>.single(
        //     value: tag,
        //     onChanged: (val) {
        //       if (val == 0) {
        //         setState(() {
        //           _orderProvider.status = null;
        //         });
        //       }
        //       setState(() {
        //         tag = val;
        //         if (tag > 0) {
        //           _orderProvider.status = options[val];
        //         }
        //       });
        //     },
        //     choiceItems: C2Choice.listFrom<int, String>(
        //       source: options,
        //       value: (i, v) => i,
        //       label: (i, v) => v,
        //     ),
        //     choiceStyle: C2ChoiceStyle(
        //       color: Colors.green,
        //       borderRadius: const BorderRadius.all(Radius.circular(5)),
        //     ),
        //   ),
        // ),
        Container(
          child: StreamBuilder<QuerySnapshot?>(
              stream: _orderServices.orders
                  // .where(
                  //   'orderStatus',
                  // )
                  //  isEqualTo: tag > 0 ? _orderProvider.status : null)
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
                        DataColumn(label: Text('Order Status')),
                        DataColumn(label: Text('Booked on')),
                        DataColumn(label: Text('Picked Date on')),
                        DataColumn(label: Text('View Order Details')),
                        DataColumn(label: Text('Total Amount')),
                        DataColumn(label: Text('Mobile')),
                        DataColumn(label: Text('Assigned Service Provider')),
                        //DataColumn(label: Text('View Details')),
                      ],
                      rows: _orderDetailrows(snapshot.data!, _orderServices),
                      showBottomBorder: true,
                      dataRowHeight: 60,
                      headingRowColor:
                          MaterialStateProperty.all(Colors.grey[200]),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  List<DataRow> _orderDetailrows(
      QuerySnapshot snapshot, OrderServices orderServices) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(Text(
          document.get('orderStatus'),
          style: TextStyle(
              color: orderServices.statusColor(document),
              fontSize: 12,
              fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
            'On ${DateFormat.yMMMd().format(DateTime.parse(document.get('timestamp')))}',
            style: TextStyle(
              fontSize: 12,
            ))),
        DataCell(Text(
          'Service Date: ${DateFormat.yMMMd().format(DateTime.parse(document.get('pickdate')))}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        )),
        DataCell(IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return OrderDetailsBox(document: document);
                });
          },
          icon: Icon(Icons.info_outline),
        )),
        DataCell(Text(
          'Amount : ${document.get('total').toStringAsFixed(0)} Rupees',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        )),
        //DataCell(Text(document.get('mobile'))),
        // DataCell(Text(document.get('email'))),
        DataCell(OrderDetails(document: document)),
        document.get('serviceProvider')['name'].length > 2
            ? DataCell(
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: ListTile(
                      tileColor: Color(0xFF3c5784).withOpacity(.2),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.network(
                          document.get('serviceProvider')['image'],
                          height: 24,
                        ),
                      ),
                      title: Text(document.get('serviceProvider')['name'],
                          style: TextStyle(fontSize: 14)),
                      subtitle: Text(_orderServices.statusComment(document),
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
              )
            : DataCell(Text('No Service Provider Assigned')),
      ]);
    }).toList();
    return newList;
  }
}
