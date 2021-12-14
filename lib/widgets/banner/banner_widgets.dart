import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:rento_admin/main.dart';
import 'package:rento_admin/services/firebase_services.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    FirebaseServices _services = FirebaseServices();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: _services.banners.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              return ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: ListView(
                    controller: _controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Stack(
                            children: [
                              SizedBox(
                                // width: MediaQuery.of(context).size.width,
                                height: 200,
                                child: Card(
                                  elevation: 10,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image(
                                        image: NetworkImage(
                                          document.get('image'),
                                        ),
                                        width: 400,
                                        fit: BoxFit.fill,
                                      )),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                      onPressed: () {
                                        _services.confirmDeleteDialog(
                                            context: context,
                                            message:
                                                'Are you sure you want to delete ? ',
                                            title: 'Delete Banner',
                                            id: document.id);
                                        // .deleteBannerImageFromDb(document.id);
                                      },
                                      icon: Icon(Icons.delete,
                                          color: Colors.red)),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }),
      ],
    );
  }
}
//   int _index = 0;
//   int _dataLength = 1;

//   @override
//   void initState() {
//     getSliderImageFromDb();
//     super.initState();
//   }

//   Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
//       getSliderImageFromDb() async {
//     var _fireStore = FirebaseFirestore.instance;
//     QuerySnapshot<Map<String, dynamic>> snapshot =
//         await _fireStore.collection('slider').get();
//     if (mounted) {
//       setState(() {
//         _dataLength = snapshot.docs.length;
//       });
//     }
//     return snapshot.docs;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (_dataLength != 0)
//           FutureBuilder(
//             future: getSliderImageFromDb(),
//             builder: (_,
//                 AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
//                     snapshot) {
//               if (snapshot.data == null) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else {
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 4),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 300.0,
//                     child: ListView.builder(
//                       //  physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (
//                         BuildContext context,
//                         int index,
//                       ) {
//                         DocumentSnapshot<Map<String, dynamic>> sliderImage =
//                             snapshot.data![index];
//                         Map<String, dynamic>? getImage = sliderImage.data();
//                         return Center(
//                           child: SizedBox(
//                               height: 400,
//                               width: MediaQuery.of(context).size.width / 2,
//                               child: Image.network(
//                                 getImage!['image'],
//                                 fit: BoxFit.contain,
//                               )),
//                         );
//                       },
//                       // options: CarouselOptions(
//                       //     viewportFraction: 1,
//                       //     enableInfiniteScroll: true,
//                       //     initialPage: 0,
//                       //     autoPlay: false,
//                       //     height: 150,
//                       //     onPageChanged: (int i, carouselPageChangedReason) {
//                       //       setState(() {
//                       //         _index = i;
//                       //       });
//                       //     })
//                     ),
//                   ),
//                 );
//               }
//             },
//           ),
//         // if (_dataLength != 0)
//         //   DotsIndicator(
//         //     dotsCount: _dataLength,
//         //     position: _index.toDouble(),
//         //     decorator: DotsDecorator(
//         //         size: const Size.square(5.0),
//         //         activeSize: const Size(18.0, 5.0),
//         //         activeShape: RoundedRectangleBorder(
//         //             borderRadius: BorderRadius.circular(5.0)),
//         //         activeColor: Theme.of(context).primaryColor),
//         //   )
//       ],
//     );
//   }
// }
