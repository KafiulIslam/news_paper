// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class FutureFetch extends StatefulWidget {
//   @override
//   _FutureFetchState createState() => _FutureFetchState();
// }
//
// class _FutureFetchState extends State<FutureFetch> {
//   Future futureData() async {
//     // var fireStore = FirebaseFirestore.instance;
//     QuerySnapshot qn =
//         await FirebaseFirestore.instance.collection("Biodata").get();
//     return qn.docs;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: futureData(),
//         builder: (_, snapshot) {
//           return ListView.builder(
//               itemCount: snapshot.data.length,
//               itemBuilder: (_, index) {
//                 DocumentSnapshot data = snapshot.data[index];
//                 return ListTile(
//                   title: Text(data["name"]),
//                 );
//               });
//         },
//       ),
//     );
//   }
// }
