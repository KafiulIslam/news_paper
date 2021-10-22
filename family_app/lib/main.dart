import 'dart:math';
import 'package:family_app/addmember_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:show_dialog/show_dialog.dart';
import 'package:alert_dialog/alert_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var email;
  var password;

  // String currentUserId;
  //
  // void initState() {
  //   super.initState();
  //   getUserId1();
  // }
  //
  // getUserId1() async {
  //   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //   final User user = await firebaseAuth.currentUser;
  //   currentUserId = user.uid.toString();
  //   // return currentUserId;
  //   // here you write the codes to input the data into firestore;
  // }

  register() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddMember(
                  // currentUserId: currentUserId,
                  )));
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) =>
              warningBox('Try again.', ' Invalid email or password.'));
    }
  }

  logIn() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddMember(
                  // currentUserId: currentUserId,
                  )));
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) =>
              warningBox('You have no account.', ' Create an account first.'));
    }
  }

  Widget warningBox(String content1, String content2) {
    return Card(
      margin: EdgeInsets.fromLTRB(25, 300, 25, 300),
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      // width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Warning !',
            style: TextStyle(
                color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          SizedBox(height: 20),
          Text(
            content1,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            content2,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ],
      ),
    );
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
              ],
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   height: 200,
              // ),
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  cursorColor: Colors.black,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: "Enter your email address",
                      hintStyle: TextStyle(fontSize: 20),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  cursorColor: Colors.black,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: "Enter the password",
                      hintStyle: TextStyle(fontSize: 20),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          register();
                        });

                        // setState(() {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => InitialPage()));
                        // });
                      },
                      color: Colors.pink,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          logIn();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => InitialPage()));
                        });
                      },
                      color: Colors.pink,
                      child: Text(
                        'Log In',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                ],
              )
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
