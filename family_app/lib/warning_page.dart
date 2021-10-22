import 'package:flutter/material.dart';

class WarningBox extends StatefulWidget {
  final String title;
  final String content;
  WarningBox({this.title, this.content});
  @override
  _WarningBoxState createState() => _WarningBoxState();
}

class _WarningBoxState extends State<WarningBox> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(25, 300, 25, 300),
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      // width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          FittedBox(
            child: Text(
              widget.content,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
