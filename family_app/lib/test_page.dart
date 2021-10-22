import 'package:family_app/home_page.dart';
import 'package:family_app/input_page.dart';
import 'package:family_app/output_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HogeApp extends StatefulWidget {
  @override
  _HogeAppState createState() => _HogeAppState();
}

class _HogeAppState extends State<HogeApp> {
  int _currentIndex = 0;

  List<Widget> _pageNavigation = <Widget>[
    OutputPage(),
    HomePage(),
    InputPage()
  ];

  void _onItemTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // <1> Use StreamBuilder
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _pageNavigation.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink,
        items: const <BottomNavigationBarItem>[
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
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTab,
      ),
    );
  }
}
