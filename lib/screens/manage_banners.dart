import 'dart:html';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:rento_admin/services/firebase_services.dart';
import 'package:rento_admin/widgets/banner/banner_upload_widget.dart';
import 'package:rento_admin/widgets/banner/banner_widgets.dart';
import 'package:rento_admin/widgets/sidebar.dart';

//String url = '';

class BannerScreen extends StatelessWidget {
  static const String id = 'banner-screen';

  const BannerScreen({Key? key}) : super(key: key);

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
      sideBar: _sidebar.sideBarMenu(context, BannerScreen.id),
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
                'Banner Screen',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              const Text('ADD / Delete Home Screen Banner Images'),
              Container(
                child: const Divider(
                  thickness: 5,
                ),
              ), //Banner Images
              // ignore: prefer_const_constructors
              BannerWidget(),
              const Divider(
                thickness: 5,
              ),
              BannerUploadWidget()
            ],
          ),
        ),
      ),
    );
  }

//   Future<String> uploadProfilePhoto(html.File image,
//       {String? imageName}) async {
//     try {
//       //Upload Profile Photo
//       fb.StorageReference _storage = fb.storage().ref('image/$imageName');
//       fb.UploadTaskSnapshot uploadTaskSnapshot =
//           await _storage.put(image).future;
//       // Wait until the file is uploaded then store the download url
//       var imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
//       url = imageUri.toString();
//     } catch (e) {
//       print(e);
//     }
//     return url;
//   }
}
