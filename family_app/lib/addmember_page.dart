import 'package:family_app/home_page.dart';
import 'package:family_app/input_page.dart';
import 'package:family_app/output_page.dart';
import 'package:family_app/test_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'input_page.dart';
import 'profile_page.dart';

class AddMember extends StatefulWidget {
  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  int _currentIndex = 0;

  String currentUserId;

  void initState() {
    super.initState();

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final User user = firebaseAuth.currentUser;
    currentUserId = user.uid.toString();
  }

  // void setCurrentUserId() async {
  //   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //   final User user = firebaseAuth.currentUser;
  //   currentUserId = user.uid.toString();
  //   print('current user id at addmember page - $currentUserId');
  // }

  // List<Widget> _pageNavigation = <Widget>[
  //   HomePage(),
  //   InputPage(),
  //   ProfilePage(
  //     currentUserId: widget.currentUserId,
  //   ),
  // ];

  void _onItemTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black45,
        // appBar: AppBar(
        //   toolbarHeight: 70,
        //   backgroundColor: Colors.pink,
        //   title: Center(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Padding(
        //           padding: EdgeInsets.only(bottom: 5),
        //           child: Text(
        //             'Heir',
        //             style: TextStyle(
        //                 fontSize: 35,
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.yellow),
        //           ),
        //         ),
        //         Padding(
        //           padding: EdgeInsets.only(top: 10),
        //           child: Text(
        //             'Stream',
        //             style: TextStyle(
        //               fontSize: 25,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: Center(
          child: [
            HomePage(),
            InputPage(),
            ProfilePage(
              currentUserId: currentUserId,
            ),
          ].elementAt(_currentIndex),
          // child: FlatButton(
          //   color: Colors.pink,
          //   onPressed: () {
          //     setState(() {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => InputPage()));
          //     });
          //   },
          //   child: Text(
          //     'Add member',
          //     style: TextStyle(color: Colors.white, fontSize: 20),
          //   ),
          // ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.pink,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  'Add',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTab,
        ),
      ),
    );
  }
}
