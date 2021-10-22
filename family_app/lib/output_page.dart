import 'dart:io';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:family_app/home_page.dart';
import 'package:family_app/input_page.dart';
import 'package:family_app/warning_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OutputPage extends StatefulWidget {
  // String userId, imageName;
  String userId;
  OutputPage({this.userId});

  @override
  _OutputPageState createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  // int _currentIndex = 0;
  //
  // List<Widget> _pageNavigation = <Widget>[
  //   OutputPage(),
  //   HomePage(),
  //   InputPage()
  // ];
  //
  // void _onItemTab(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  // }

  var picture;

  // PickedFile _imageFile;
  // final ImagePicker _picker = ImagePicker();

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    await FirebaseStorageService.loadImage(context, imageName).then((value) {
      picture = value.toString();
      // print(picture);
    });
    return picture;
  }

  final int length = 0;

  Future<List<DocumentSnapshot>> getData() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot info = await firestore
        .collection("Biodata")
        .where('uid', isEqualTo: widget.userId)
        .get();
    return info.docs;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 11.20,
        backgroundColor: Colors.pink,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   width: 20,
              // ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  'Heir',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Stream',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
        ),
      ),
      body:
          // _pageNavigation.elementAt(_currentIndex),
          Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: 0,
              // ),
              // FutureBuilder(
              //     future: _getImage(context, widget.imageName),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.done) {
              //         return Stack(
              //           children: [
              //             CircleAvatar(
              //               radius: 90,
              //               backgroundColor: Colors.white70,
              //               child: CircleAvatar(
              //                 radius: 85,
              //                 // backgroundColor: Colors.lightBlue,
              //                 // foregroundColor: Colors.lightBlue,
              //                 backgroundImage: NetworkImage(picture),
              //               ),
              //             ),
              //           ],
              //         );
              //       } else if (snapshot.connectionState ==
              //           ConnectionState.waiting) {
              //         return Container(
              //           height: MediaQuery.of(context).size.height / 1.2,
              //           width: MediaQuery.of(context).size.width / 1.2,
              //           child: CircularProgressIndicator(),
              //         );
              //       } else {
              //         return WarningBox();
              //       }
              //     }),
              FutureBuilder(
                  future: getData(),
                  builder: (_, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            return Column(
// mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 30,
                                ),
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 90,
                                      backgroundColor: Colors.white70,
                                      child: CircleAvatar(
                                        radius: 85,
                                        // backgroundColor: Colors.lightBlue,
                                        // foregroundColor: Colors.lightBlue,
                                        backgroundImage: NetworkImage(
                                            snapshot.data[index]["imageUrl"]),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  snapshot.data[index]["name"],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.yellowAccent,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
// mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   'Name',
                                        //   style: TextStyle(
                                        //       color: Colors.white,
                                        //       fontSize: 25,
                                        //       fontWeight:
                                        //           FontWeight.bold),
                                        // ),
                                        // SizedBox(
                                        //   height: 20,
                                        // ),
                                        Text(
                                          'Id No.',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Father's Id",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Mother's Id",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Date of Birth',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Date of Dead',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Profession',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 60,
                                    ),
                                    Column(
// mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   snapshot.data[index]["name"],
                                        //   textAlign: TextAlign.start,
                                        //   style: TextStyle(
                                        //       color: Colors.white,
                                        //       fontSize: 25,
                                        //       fontWeight:
                                        //           FontWeight.bold),
                                        //   overflow: TextOverflow.fade,
                                        //   maxLines: 1,
                                        //   softWrap: false,
                                        // ),
                                        // SizedBox(
                                        //   height: 20,
                                        // ),
                                        Text(
                                          snapshot.data[index]["id"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          snapshot.data[index]["fatherId"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          snapshot.data[index]["motherId"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          snapshot.data[index]["date_of_birth"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          snapshot.data[index]["date_of_death"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          snapshot.data[index]["profession"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    }
                  }),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.pink,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.person,
      //           color: Colors.white,
      //           size: 30,
      //         ),
      //         title: Text(
      //           'Profile',
      //           style: TextStyle(
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.white),
      //         )),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.home,
      //           color: Colors.white,
      //           size: 30,
      //         ),
      //         title: Text(
      //           'Home',
      //           style: TextStyle(
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.white),
      //         )),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.add,
      //           color: Colors.white,
      //           size: 30,
      //         ),
      //         title: Text(
      //           'Add',
      //           style: TextStyle(
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.white),
      //         )),
      //   ],
      //   currentIndex: _currentIndex,
      //   onTap: _onItemTab,
      // )
    ));
  }
}

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();

  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
