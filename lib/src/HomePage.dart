import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:pf_project/src/models/Income_Form.dart';
import 'package:pf_project/src/repository/CategiryPage.dart';

import 'package:pf_project/src/models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<QuerySnapshot>? _expenseStream;

  int total = 0, income = 0, expense = 0;

  _dialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: AddIncomeForm(),
          );
        });
  }

  _dialogBuilder_expense(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Categories(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade200,
        ),
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.currency_rupee_sharp,
                          color: Colors.green[900],
                          size: 20.0,
                        ),
                        onPressed: () {
                          _dialogBuilder(context);
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .where('Email',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final userData = user_model.fromSnapshot(snapshot
                                      .data!.docs.first
                                  as DocumentSnapshot<Map<String, dynamic>>);

                              return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('income')
                                    .where('phone', isEqualTo: userData.phone)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final docs = snapshot.data!.docs;
                                    if (docs.isEmpty) {
                                      return Text('0');
                                    }

                                    return ListView(
                                      shrinkWrap: true,
                                      children:
                                          docs.map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data() as Map<String, dynamic>;
                                        income = data["user_income"];

                                        return Column(
                                          children: [
                                            Text(
                                              data["user_income"].toString() +
                                                  "/-",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    );
                                  }
                                },
                              );
                            }
                          }),
                    ],
                  ),
                ),
                Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                     Text("Total",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                      SizedBox(height: 10,),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .where('Email',
                            isEqualTo:
                            FirebaseAuth.instance.currentUser!.email)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final userData = user_model.fromSnapshot(
                                snapshot.data!.docs.first
                                as DocumentSnapshot<Map<String, dynamic>>);

                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('expense')
                                  .where('phone', isEqualTo: userData.phone)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return CircularProgressIndicator();
                                } else {
                                  final docs = snapshot.data!.docs;
                                  if (docs.isEmpty) {
                                    return Center(
                                      child: Text('0'),
                                    );
                                  }
                                  double total = 0;
                                  for (int index = 0;
                                  index < docs.length;
                                  index++) {
                                    final data = docs[index].data()
                                    as Map<String, dynamic>;
                                    List<String> keys = data.keys.toList();
                                    // Filter out keys to exclude ('phone' in this case)
                                    keys.removeWhere((key) => key == 'phone');
                                    for (var key in keys) {
                                      total += data[
                                      key]; // Summing up all the values
                                    }
                                  }
                                  return Center(
                                    child: Text(
                                      ' ${income-total}', // Displaying the total
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),

                      SizedBox(height: 5,)
                    ],
                  ),
                ),
                Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.currency_rupee_sharp,
                          size: 20,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _dialogBuilder_expense(context);
                        },
                        tooltip: 'Set Your Expenses here!',
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .where('Email',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.email)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Data is Loading...");
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final userData = user_model.fromSnapshot(
                                snapshot.data!.docs.first
                                    as DocumentSnapshot<Map<String, dynamic>>);

                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('expense')
                                  .where('phone', isEqualTo: userData.phone)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return CircularProgressIndicator();
                                } else {
                                  final docs = snapshot.data!.docs;
                                  if (docs.isEmpty) {
                                    return Center(
                                      child: Text('0'),
                                    );
                                  }
                                  double total = 0;
                                  for (int index = 0;
                                      index < docs.length;
                                      index++) {
                                    final data = docs[index].data()
                                        as Map<String, dynamic>;
                                    List<String> keys = data.keys.toList();
                                    // Filter out keys to exclude ('phone' in this case)
                                    keys.removeWhere((key) => key == 'phone');
                                    for (var key in keys) {
                                      total += data[
                                          key]; // Summing up all the values
                                    }
                                  }
                                  return Center(
                                    child: Text(
                                      ' $total/-', // Displaying the total
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        },
                      )

                      // Text("6000/-",style: TextStyle(
                      //   fontSize: 15.0,
                      //   fontWeight: FontWeight.bold,
                      // ),),
                    ],
                  ),
                ),
              ],
            ),
            // ElevatedButton(onPressed: (){
            //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegistrationPage()));
            // }, child: Text("Registration")),
            SizedBox(height: 20.0),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .where('Email',
                              isEqualTo:
                                  FirebaseAuth.instance.currentUser!.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Data is Loading...");
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final userData = user_model.fromSnapshot(snapshot
                              .data!
                              .docs
                              .first as DocumentSnapshot<Map<String, dynamic>>);

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('expense')
                                .where('phone', isEqualTo: userData.phone)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Data is Loading...");
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final docs = snapshot.data!.docs;
                                if (docs.isEmpty) {
                                  return Center(
                                    child: Text('No data Found'),
                                  );
                                }
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Transaction History",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.blue.shade400),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(),
                                    Expanded(
                                      // Wrap the ListView.builder with Expanded
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: docs.length,
                                        itemBuilder: (context, index) {
                                          final data = docs[index].data()
                                              as Map<String, dynamic>;
                                          List<String> keys =
                                              data.keys.toList();

                                          // Filter out keys to exclude ('phone' in this case)
                                          keys.removeWhere(
                                              (key) => key == 'phone');

                                          return Column(
                                            children: keys.map((key) {
                                              dynamic value = data[key];

                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.pink
                                                      .shade50, // Background color for each ListTile
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // Adjust border radius as needed
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(
                                                              0.5), // Shadow color
                                                      spreadRadius: 1,
                                                      blurRadius: 2,
                                                      offset: Offset(0,
                                                          1), // Shadow position
                                                    ),
                                                  ],
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal:
                                                        8.0), // Adjust margin as needed
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 8.0,
                                                          horizontal:
                                                              16.0), // Adjust padding as needed
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween, // Align elements to opposite ends
                                                    children: [
                                                      Text('$key'),
                                                      Expanded(
                                                        // Use Expanded widget to occupy remaining space
                                                        child: Text(
                                                          '$value',
                                                          textAlign: TextAlign
                                                              .right, // Align text to the right
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        }
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
