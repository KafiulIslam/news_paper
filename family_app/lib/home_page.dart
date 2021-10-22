import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_app/output_page.dart';
import 'package:family_app/warning_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var picForHome;

  String url;

  List<ImageName> items = [
    ImageName()
    // GridListItems(color:Colors.green,title: 'Bicycle', icon: Icons.directions_bike),
    // GridListItems(color:Colors.pink[300],title:'Boat', icon: Icons.directions_boat),
    // GridListItems(color:Colors.pink[300],title: 'Bus', icon: Icons.directions_bus),
    // GridListItems(color:Colors.pink[300],title: 'Train', icon: Icons.directions_railway),
    // GridListItems(color:Colors.pink[300],title: 'Walk', icon: Icons.directions_walk),
    // GridListItems(color:Colors.pink[300],title: 'Contact', icon: Icons.contact_mail),
    // GridListItems(color:Colors.green,title: 'Bicycle', icon: Icons.directions_bike),
  ];

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    await FirebaseStorageService.loadImage(context, imageName).then((value) {
      picForHome = value.toString();
      // print(picture);
    });
    return picForHome;
  }

  // Future<List<DocumentSnapshot>> getData() async {
  //   var firestore = FirebaseFirestore.instance;
  //   QuerySnapshot info = await firestore
  //       .collection("Biodata")
  //       .where('id', isEqualTo: widget.idForHome)
  //       .get();
  //   return info.docs;
  // }

  // int _currentIndex = 0;

  // Widget imageGrid() {
  //   return GridView.builder(
  //       gridDelegate:
  //           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  //       itemBuilder: (context, index) {
  //         return ImageGridItem();
  //       });
  // }

//   Future<String> storageImage() async {
//     final ref = FirebaseStorage.instance.ref().child('Biodata');
// // no need of the file extension, the name will do fine.
//     url = await ref.getDownloadURL();
//   }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 11.20,
        backgroundColor: Colors.pink,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50),
            child: Text(
              'Home',
              style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Biodata").snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(child: CircularProgressIndicator())
                : Container(
                    margin: EdgeInsets.only(top: 12),
                    child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 12, right: 12),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OutputPage(
                                                userId: snapshot
                                                    .data.docs[index]
                                                    .get("uid"),
                                              )));
                                });
                              },
                              child: Container(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.all(5),
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5.1,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.1,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(snapshot
                                                .data.docs[index]
                                                .get("imageUrl")
                                                .toString()),
                                            fit: BoxFit.cover,
                                          ),
                                          // shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        snapshot.data.docs[index].get("name"),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ]),
                              ),
                            ),
                          );
                          // child: FadeInImage.memoryNetwork(
                          //    placeholder: null,
                          //   image: snapshot.data.docs[index].get('image'),
                          // )
                        }),
                  );
          }),
      // GridView.builder(
      //   itemCount: items.length,
      //   gridDelegate:
      //       SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      //   itemBuilder: (BuildContext context, int index) {
      //     return new Card(
      //       child: new GridTile(
      //         child: ImageName(), //just for testing, will fill with image later
      //       ),
      //     );
      //   },
      // ),
    ));
    // bottomNavigationBar: BottomNavigationBar(
    //   currentIndex: _currentIndex,
    //   backgroundColor: Colors.pink,
    //   items: [
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
    //   onTap: (index) {
    //     setState(() {
    //       _currentIndex = index;
    //     });
    //   },
    // ),
  }
}

class ImageName extends StatefulWidget {
  // String idForHome;
  // String imageNameForHome;
  //
  // ImageName({this.idForHome, this.imageNameForHome});

  @override
  _ImageNameState createState() => _ImageNameState();
}

class _ImageNameState extends State<ImageName> {
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

  dynamic data;

  var picForHome;

  // PickedFile _imageFile;
  // final ImagePicker _picker = ImagePicker();

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    await FirebaseStorageService.loadImage(context, imageName).then((value) {
      picForHome = value.toString();
      // print(picture);
    });
    return picForHome;
  }

  final int length = 0;

  Future<List<DocumentSnapshot>> getData() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot info = await firestore
        .collection("Biodata")
        // .where('id', isEqualTo: widget.idForHome)
        .get();
    return info.docs;
  }

  Future<dynamic> getInfo() async {
    final DocumentReference document =
        FirebaseFirestore.instance.collection("Biodata").doc('ac1');

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
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
              SizedBox(
                width: 50,
              ),
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
              FlatButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ))
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
              SizedBox(
                height: 30,
              ),
              FutureBuilder(
                  future: getData(),
                  builder: (_, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    // DocumentSnapshot data = snapshot.data.[index];
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            return Text(
                              snapshot.data[index]["name"],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            );
                          });
                    }
                  }),
              FutureBuilder(
                  future: _getImage(context, data["image"]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Card(
                        child: Image.network(picForHome, fit: BoxFit.fill),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 1.2,
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return WarningBox();
                    }
                  }),
            ],
          ),
        ),
      ),
    ));
  }
}

class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();

  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
