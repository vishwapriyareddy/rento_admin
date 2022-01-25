import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:rento_admin/services/firebase_services.dart';
import 'package:rento_admin/widgets/service_provider/approved_boys.dart';
import 'package:rento_admin/widgets/service_provider/create_service_provider.dart';
import 'package:rento_admin/widgets/service_provider/new_boys.dart';
import 'package:rento_admin/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class ServiceProviderBoys extends StatelessWidget {
  const ServiceProviderBoys({Key? key}) : super(key: key);

  static const String id = 'service-providerboy-screen';

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sidebar = SideBarWidget();

    return DefaultTabController(
      length: 2,
      child: AdminScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black87,
          title: const Text(
            'Rento App Dashboard',
            style: TextStyle(color: Colors.white),
          ),
        ),
        sideBar: _sidebar.sideBarMenu(context, ServiceProviderBoys.id),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Provider Screen',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
                Text(
                    'Create new service providers and Manage all Service providers'),
                Divider(thickness: 5),
                CreateServiceBoy(),
                Divider(thickness: 5),
                TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      Tab(
                        text: 'NEW',
                      ),
                      Tab(
                        text: 'APPROVED',
                      ),
                    ]),
                Expanded(
                  child: Container(
                    child: TabBarView(children: [
                      NewBoys(),
                      ApprovedBoys(),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
