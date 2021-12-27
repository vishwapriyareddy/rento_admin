import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:rento_admin/widgets/category/category_list_widget.dart';
import 'package:rento_admin/widgets/category/category_upload_widget.dart';
import 'package:rento_admin/widgets/sidebar.dart';

class CategoryScreen extends StatelessWidget {
  static const String id = 'category-screen';
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sidebar = SideBarWidget();

    return AdminScaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        title: const Text(
          'Rento App Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      sideBar: _sidebar.sideBarMenu(context, CategoryScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              const Text('Add New Categories and Sub Categories'),
              const Divider(
                thickness: 5,
              ),
              CategoryCreateWidget(),
              const Divider(
                thickness: 5,
              ),
              CategoryListWidget()
            ],
          ),
        ),
      ),
    );
  }
}
