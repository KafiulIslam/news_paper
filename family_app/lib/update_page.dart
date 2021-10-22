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

class UpdatePage extends StatefulWidget {
  String userId;

  UpdatePage({this.userId});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _controller = TextEditingController();
  String fileName;
  String id = Random().nextInt(100).toString();
  String url;
  String name;
  String dob;
  String dod;
  String profession;
  String fatherId;
  String motherId;

  // String uid;

  io.File _image;
  final picker = ImagePicker();

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

  Future<List<DocumentSnapshot>> getData() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot info = await firestore
        .collection("Biodata")
        .where('uid', isEqualTo: widget.userId)
        .get();
    return info.docs;
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
                              widget.userId,
                              (status, uid, error) => {
                                    if (status)
                                      {
                                        setState(() {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OutputPage(
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
            body: Container(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: FutureBuilder(
                        future: getData(),
                        builder: (_,
                            AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                        height: 12,
                                      ),
                                      profileImage(),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 30),
                                        child: TextFormField(
                                          controller: _controller,
                                          //snapshot.data[index]["name"],
                                          onChanged: (value) {
                                            setState(() {
                                              name = value;
                                            });
                                          },
                                          cursorColor: Colors.black,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                              labelText: 'Name',
                                              labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                              hintText: snapshot.data[index]
                                                  ['name'],
                                              hintStyle:
                                                  TextStyle(fontSize: 20),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              25)))),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          obscureText: false,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 30),
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
                                              hintText:
                                                  "Enter your father's Id",
                                              hintStyle:
                                                  TextStyle(fontSize: 20),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              25)))),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          obscureText: false,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 30),
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
                                              hintText:
                                                  "Enter your mother's Id",
                                              hintStyle:
                                                  TextStyle(fontSize: 20),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              25)))),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          obscureText: false,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 30),
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
                                              hintText:
                                                  "Enter your date of birth",
                                              hintStyle:
                                                  TextStyle(fontSize: 20),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              25)))),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          obscureText: false,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 30),
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
                                              hintText:
                                                  "Enter the date of dead",
                                              hintStyle:
                                                  TextStyle(fontSize: 20),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              25)))),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          obscureText: false,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 30),
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
                                              hintStyle:
                                                  TextStyle(fontSize: 20),
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              25)))),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          obscureText: false,
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          }
                        })))));
  }
}
