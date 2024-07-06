import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pf_project/src/models/user_model.dart';

class AddIncomeForm extends StatefulWidget {

  @override
  State<AddIncomeForm> createState() => _AddIncomeFormState();
}

class _AddIncomeFormState extends State<AddIncomeForm> {
  int income=0;
  String? phone;

  TextEditingController _controller = TextEditingController();
  Future<user_model> getUserDetails(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("Email", isEqualTo: email)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final userData = user_model.fromSnapshot(snapshot.docs.first);
      return userData;
    } else {
      throw Exception('User not found');
    }
  }
  void _showSnackbarPass(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }
  void _showSnackbarFail(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            Text("Set Your Income"),
            TextFormField(
              controller:_controller ,
              decoration: InputDecoration(
                  hintText: 'Amount'
              ),
            ),

            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                income = int.parse(_controller.text);
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  final email = currentUser.email;
                  final userDetails = await getUserDetails(email!);
                  phone = userDetails.phone;
                }

                if (phone != null) {
                  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("income").where('phone', isEqualTo: phone).get();

                  if (snapshot.docs.isNotEmpty) {
                    // User's data found, update income field
                    String docId = snapshot.docs.first.id;
                    await FirebaseFirestore.instance.collection("income").doc(docId).update({
                      'user_income': income,
                    }).then((_) {
                     // _showSnackbarPass("Record updated successfully!");
                      setState(() {
                        _controller.clear();
                        Navigator.of(context).pop();

                      });
                    }).catchError((error) {
                     // _showSnackbarFail("Failed to update record: $error");
                    });
                  } else {
                    // No user's data found, add new record
                    CollectionReference collref = FirebaseFirestore.instance.collection('income');
                    collref.add({
                      'user_income': income,
                      'phone': phone,
                    }).then((_) {
                     // _showSnackbarPass("Record inserted successfully!");
                      setState(() {

                        _controller.clear();
                        Navigator.of(context).pop();

                      });
                    }).catchError((error) {
                     // _showSnackbarFail("Failed to insert record: $error");
                    });
                  }
                } else {
                  //_showSnackbarFail("User's phone number not found!");
                }
              },
              child: Text("Add"),

            ),

          ],
        ),
      ),
    );
  }
}



