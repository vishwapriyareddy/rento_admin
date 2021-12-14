import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:rento_admin/widgets/sidebar.dart';
import 'package:rento_admin/widgets/vendor/vendor_datatable_widget.dart';
import 'package:rento_admin/widgets/vendor/vendor_filter_widget.dart';

class VendorsScreen extends StatefulWidget {
  static const String id = 'vendors-screen';
  const VendorsScreen({Key? key}) : super(key: key);

  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  @override
  Widget build(BuildContext context) {
    SideBarWidget _sidebar = SideBarWidget();
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        title: const Text(
          'Rento App Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      sideBar: _sidebar.sideBarMenu(context, VendorsScreen.id),
      body: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        //  physics: const ScrollPhysics(),
        //physics: BouncingScrollPhysics(),
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text(
                'Manage Vendors',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              const Text('Manage all the Vendors Activities '),
              const Divider(
                thickness: 5,
              ),
              // VendorFilterWidget(),
              // const Divider(
              //   thickness: 5,
              // ),
              //Banner Images
              VendorDataTable(),
              const Divider(
                thickness: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
