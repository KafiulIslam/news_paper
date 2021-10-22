import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:family_app/future_fetching.dart';
import 'package:family_app/google_fetch.dart';
import 'package:family_app/home_page.dart';
import 'package:family_app/test_page.dart';
import 'package:family_app/warning_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:family_app/output_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'dart:math';
import 'package:path/path.dart' as path;

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String fileName;
  String id = Random().nextInt(100).toString();
  String url;
  String name;
  // List.generate(5, (_) => Random().nextInt(100)).toString();
  String dob;
  String dod;
  String profession;
  String fatherId;
  String motherId;
  String uid;

  void initState() {
    super.initState();
    getUserId1();
  }

  getUserId1() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final User user = await firebaseAuth.currentUser;
    uid = user.uid.toString();
    // print(uid);
    // here you write the codes to input the data into firestore
  }

  int _currentIndex = 0;

  io.File _image;
  final picker = ImagePicker();

  // void randomNumber() {
  //   Random random = new Random();
  //   id = random.nextInt(100).toString();
  // }

  Widget dialogBox() {
    return Card(
      color: Colors.black.withOpacity(0.5),
      margin: EdgeInsets.fromLTRB(25, 300, 25, 300),
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      // width: MediaQuery.of(context).size.width,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            'Update Profile Picture',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  autofocus: true,
                  iconSize: 55,
                  tooltip: 'Camera',
                  icon: Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                    Navigator.pop(context);
                  }),
              SizedBox(
                width: 30,
              ),
              IconButton(
                  autofocus: true,
                  iconSize: 55,
                  tooltip: 'Gallery',
                  icon: Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                    Navigator.pop(context);
                  }),
            ],
          )
        ],
      ),
    );
  }

  Future takePhoto(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = io.File(pickedFile.path);
      } else {
        return WarningBox(
          title: 'Sorry !',
          content: 'Image is not uploaded',
        );
      }
    });
  }

//   Future<String> storageImage() async {
//     final ref = FirebaseStorage.instance.ref().child('Biodata');
// // no need of the file extension, the name will do fine.
//     url = await ref.getDownloadURL();
//   }

  // void takePhoto(ImageSource source) async {
  //   final PickedFile image = await _picker.getImage(source: source);
  //   setState(() {
  //     _imageFile = image;
  //   });
  // }

  Widget profileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 79,
            backgroundColor: Colors.white70,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 75,
              // backgroundColor: Colors.lightBlue,
              // foregroundColor: Colors.lightBlue,
              backgroundImage: _image == null
                  ? AssetImage('images/human avatar.png')
                  : FileImage(io.File(_image.path)),
            ),
          ),
          Positioned(
            bottom: 6,
            left: 114,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white70,
            ),
          ),
          Positioned(
              bottom: 00,
              right: 2,
              child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context, builder: (context) => dialogBox());
                },
                color: Colors.pink,
                icon: Icon(Icons.camera_alt),
              )),
        ],
      ),
    );
  }

  Future uploadInfo(
      io.File _image1,
      String id,
      // String imageUrl,
      String name,
      String dateOfBirth,
      String dateOfDeath,
      String profession,
      String fatherId,
      String motherId,
      String uid,
      Function callback) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    QuerySnapshot userData = await fireStore
        .collection("Biodata")
        .where('uid', isEqualTo: uid)
        .get();

    if (userData.docs.length > 0) {
      callback(
          false,
          null,
          WarningBox(
            title: 'Warning !',
            content: 'You have a profile already.',
          ));
      return;
    }

    try {
      String imageName = DateTime.now().toString();

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(imageName);
      await ref.putFile(_image1);
      String imageLink = (await ref.getDownloadURL()).toString();

      // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      // final User user = firebaseAuth.currentUser;
      // final uid = user.uid;

      FirebaseFirestore.instance
          .collection("Biodata")
          .add({
            // 'image': imageName,
            'id': id,
            'imageUrl': imageLink,
            'name': name,
            'date_of_birth': dateOfBirth,
            'date_of_death': dateOfDeath,
            'profession': profession,
            'fatherId': fatherId,
            'motherId': motherId,
            'uid': uid,
          })
          .then((value) => callback(true, uid, null))
          .catchError((error) => callback(
              false,
              null,
              WarningBox(
                title: 'Sorry !',
                content: 'Failed to insert data',
              )));
    } on FirebaseException catch (e) {
      callback(
          false,
          null,
          WarningBox(
            title: 'Sorry !',
            content: 'Failed to upload the profile picture',
          ));
    }
  }

  // Future uploadPic(var _image1) async {
  //   fileName = path.basename(_image1.path);
  //
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   Reference ref = storage.ref().child(
  //         "Name" + DateTime.now().toString(),
  //       );
  //
  //   ref.putFile(_image1).then((res) {
  //     // res.ref.getDownloadURL().toString();
  //     //
  //     // if (res.ref.getDownloadURL() != null) {
  //     //   print('this is the image link');
  //     //   print(url);
  //     // } else {
  //     //   print('there is no url link');
  //     // }
  //   });
  // }
  //
  // uploadImage(var _imageFile) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //
  //   Reference ref = storage.ref().child("Name" + DateTime.now().toString());
  //   UploadTask uploadTask = ref.putFile(_imageFile);
  //   uploadTask.whenComplete(() {
  //     ref.getDownloadURL();
  //     // print('it is from upimage -');
  //     // print(ref.getDownloadURL());
  //   }).catchError((onError) {
  //     print(onError);
  //   });
  // }
  //
  // Future sendData() async {
  //   final inputData = FirebaseFirestore.instance.collection("Biodata").add({
  //     'image': url,
  //     'name': name,
  //     'id': id,
  //     'fatherId': fatherId,
  //     'motherId': motherId,
  //     'date of birth': dob,
  //     'date of dead': dod,
  //     'profession': profession,
  //   });
  // }

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
                      // randomNumber();
                      uploadInfo(
                          _image,
                          id,
                          name,
                          dob,
                          dod,
                          profession,
                          fatherId,
                          motherId,
                          uid,
                          (status, uid, error) => {
                                if (status)
                                  {
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OutputPage(
                                                    userId: uid,
                                                    // userId: id,
                                                    // imageName: imageName,
                                                  )));
                                    })
                                  }
                                else
                                  {
                                    WarningBox(
                                      title: 'Sorry !',
                                      content: 'Something went wrong',
                                    )
                                  }
                              });
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ))
              ],
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                profileImage(),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    onChanged: (value) {
                      name = value;
                    },
                    cursorColor: Colors.black,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        hintText: "Enter your name",
                        hintStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    onChanged: (value) {
                      fatherId = value;
                    },
                    cursorColor: Colors.black,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: "Father's Id",
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        hintText: "Enter your father's Id",
                        hintStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    onChanged: (value) {
                      motherId = value;
                    },
                    cursorColor: Colors.black,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: "Mother's Id",
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        hintText: "Enter your mother's Id",
                        hintStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    onChanged: (value) {
                      dob = value;
                    },
                    cursorColor: Colors.black,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        hintText: "Enter your date of birth",
                        hintStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    onChanged: (value) {
                      dod = value;
                    },
                    cursorColor: Colors.black,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Date of Dead',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        hintText: "Enter the date of dead",
                        hintStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    onChanged: (value) {
                      profession = value;
                    },
                    cursorColor: Colors.black,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Profession',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        hintText: "Enter your profession",
                        hintStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                ),
              ],
            ),
          ),
        ),
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
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
