// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
// class GoogleFetch extends StatefulWidget {
//   @override
//   _GoogleFetchState createState() => _GoogleFetchState();
// }
//
// class _GoogleFetchState extends State<GoogleFetch> {
//   final int length = 1;
//   Future<List<DocumentSnapshot>> googleData() async {
//     var firestore = FirebaseFirestore.instance;
//     QuerySnapshot qn = await firestore.collection("Biodata").get();
//     return qn.docs;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: googleData(),
//         builder: (_, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Padding(
//               padding: const EdgeInsets.only(
//                 top: 50,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Center(
//                     child: SpinKitCircle(
//                       color: Color.fromRGBO(91, 74, 127, 10),
//                       size: 50.0,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return ListView.builder(
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (_, index) {
//                   return SingleChildScrollView(
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           margin: EdgeInsets.all(10),
//                           height: 185,
//                           width: double.infinity,
//                           child: Stack(
//                             children: <Widget>[
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(10),
//                                       topRight: Radius.circular(10)),
//                                   color: Colors.blueGrey.shade800,
//                                 ),
//                                 height: 150,
//                                 width: double.infinity,
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: <Widget>[
//                                     SizedBox(
//                                       height: 6,
//                                     ),
//                                     Expanded(
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         children: <Widget>[
//                                           Column(
//                                             children: <Widget>[
//                                               SizedBox(
//                                                 height: 5,
//                                               ),
//                                               Text("Name",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 25,
//                                                   )),
//                                               Text(snapshot.data[index]["name"],
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 25,
//                                                   )),
//                                             ],
//                                           ),
//                                           Column(
//                                             children: <Widget>[
//                                               SizedBox(
//                                                 height: 5,
//                                               ),
//                                               Text("Age",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 25,
//                                                   )),
//                                               Text(snapshot.data[index]["age"],
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 25,
//                                                   )),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 });
//           }
//         },
//       ),
//     );
//   }
// }
