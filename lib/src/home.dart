import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pf_project/src/Chart_Page.dart';
import 'package:pf_project/src/HomePage.dart';

import 'package:pf_project/src/models/user_model.dart';
import 'package:pf_project/src/repository/ChartPage.dart';
import 'package:pf_project/src/repository/Income.dart';
import 'package:pf_project/src/repository/ProfilePage.dart';
import 'package:pf_project/src/repository/SeetingsPage.dart';

class Welcome extends StatefulWidget {
  String? email;
  Welcome(this.email);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  int currentIndex = 0;

  final _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("PFinance",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: SizedBox(
              height: 35,
              child:  IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  final email = FirebaseAuth.instance.currentUser?.email;
                  if (email != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(email)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Login to Continue..!",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(currentIndex),
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.blueGrey[900],
//         child: Container(
//           height: 80.0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.home,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   // Navigator.push(context, MaterialPageRoute(builder: (context) => Income()));
//                   Chart_app();
//                 },
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.analytics,
//                   color: Colors.white,
//                 ),
//                 onPressed: (){
//                   //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Chart_app()));
//                 },
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.settings,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
// // Add functionality for settings button
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
    bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Colors.blueGrey[900],
      currentIndex: currentIndex,
      onTap: (value) {
        setState(() {
          currentIndex = value;
        });
      },
      selectedItemColor: Colors.blueGrey.shade50,
      unselectedItemColor: Colors.blueGrey,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Chart",
          icon: Icon(Icons.bar_chart),
        ),
        BottomNavigationBarItem(
          label: "settings",
          icon: Icon(Icons.settings),
        ),
      ],
    ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.transparent,
    //     title: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         SizedBox(width: 30),
    //         Text("Welcome Page"),
    //         SizedBox(width: 40),
    //
    //         IconButton(
    //           onPressed: () {
    //             final email = FirebaseAuth.instance.currentUser?.email;
    //             if (email != null) {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(builder: (context) => ProfileScreen(email)),
    //               );
    //             } else {
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 SnackBar(
    //                   content: Text(
    //                     "Login to Continue..!",
    //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //                   ),
    //                   backgroundColor: Colors.green,
    //                   behavior: SnackBarBehavior.floating,
    //                 ),
    //               );
    //             }
    //           },
    //           icon: Image.asset("assets/image/man.png"),
    //         ),
    //       ],
    //     ),
    //   ),
    //   body: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Center(
    //         child: Column(
    //           children: [
    //             StreamBuilder<QuerySnapshot>(
    //               stream: FirebaseFirestore.instance
    //                   .collection("Users")
    //                   .where('Email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
    //                   .snapshots(),
    //               builder: (context, snapshot) {
    //                 if (snapshot.connectionState == ConnectionState.waiting) {
    //                   return CircularProgressIndicator();
    //                 } else if (snapshot.hasError) {
    //                   return Text('Error: ${snapshot.error}');
    //                 } else {
    //                   final userData = user_model.fromSnapshot(snapshot.data!.docs.first as DocumentSnapshot<Map<String, dynamic>>);
    //                   // Use userData here
    //
    //                   return Column(
    //                     children: [
    //                       StreamBuilder<QuerySnapshot>(
    //                         stream: FirebaseFirestore.instance.collection('income').where('phone',isEqualTo: userData.phone).snapshots(),
    //                         builder: (context, snapshot) {
    //                           if (snapshot.connectionState == ConnectionState.waiting) {
    //                             return CircularProgressIndicator();
    //                           } else if (snapshot.hasError) {
    //                             return Text('Error: ${snapshot.error}');
    //                           } else {
    //                             final docs = snapshot.data!.docs;
    //                             if (docs.isEmpty) {
    //                               return Text('No data available');
    //                             }
    //                             return ListView(
    //                               shrinkWrap: true,
    //                               children: docs.map((DocumentSnapshot document) {
    //                                 Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //                                 // return ListTile(
    //                                 //   title: Column(
    //                                 //     children: [
    //                                 //
    //                                 //     ],
    //                                 //   ), // Convert to String
    //                                 // );
    //                                 return   Column(
    //                                   children: [
    //                                     //Text("Expenses: "+data["income_category"].toString()),
    //
    //                                     Text("Total Income: "+data["user_income"].toString()),
    //                                   ],
    //                                 );
    //
    //                               }).toList(),
    //                             );
    //                           }
    //                         },
    //                       ),
    //                       StreamBuilder<QuerySnapshot>(
    //                         stream: FirebaseFirestore.instance.collection('category').where('phone',isEqualTo: userData.phone).snapshots(),
    //                         builder: (context, snapshot) {
    //                           if (snapshot.connectionState == ConnectionState.waiting) {
    //                             return CircularProgressIndicator();
    //                           } else if (snapshot.hasError) {
    //                             return Text('Error: ${snapshot.error}');
    //                           } else {
    //                             final docs = snapshot.data!.docs;
    //                             if (docs.isEmpty) {
    //                               return Text('No data available');
    //                             }
    //                             return ListView(
    //                               shrinkWrap: true,
    //                               children: docs.map((DocumentSnapshot document) {
    //                                 Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //                                 // return ListTile(
    //                                 //   title: Column(
    //                                 //     children: [
    //                                 //
    //                                 //     ],
    //                                 //   ), // Convert to String
    //                                 // );
    //                                 return   Column(
    //                                   children: [
    //                                     Text("Expenses: "+data["expense_category"].toString()),
    //
    //                                    // Text("Total Income: "+data["user_income"].toString()),
    //                                   ],
    //                                 );
    //
    //                               }).toList(),
    //                             );
    //                           }
    //                         },
    //                       ),
    //                     ],
    //                   );
    //                 }
    //               },
    //             ),
    //
    //           ],
    //         ),
    //       ),
    //       SizedBox(height: 50),
    //       ElevatedButton(
    //         onPressed: () {
    //           Navigator.push(context, MaterialPageRoute(builder: (context) => Income()));
    //         },
    //         child: Text("Add Income"),
    //       )
    //     ],
    //   ),
    // );

  }
}
Widget _buildBody(int index) {
  switch (index) {
    case 0:
      return HomePage();
    case 1:
      return ChartPage();
    case 2:
     // final email = FirebaseAuth.instance.currentUser?.email;
      return SettingPage();
    default:
      return SizedBox.shrink();
  }
}
