import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class Categories extends StatefulWidget {
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String? phone;
  TextEditingController _controller = TextEditingController();
  int amount = 0;
   String? _selectedCategory;

  List _categories = [
    "Food & Groceries",
    "Transportation",
    "Entertainment",
    "Housing & Rent",
    "Utility Bills",
    "Children Care",
    "Loans",
    "Clothing",
    "Insurance",
    "Miscellaneous",
  ];

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
            Text(
              "Select and Enter Expense",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Amount'),
            ),
            DropdownButtonFormField(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value as String?;
                });
              },
              decoration: InputDecoration(labelText: 'Select Category'),
            ),
            ElevatedButton(
              onPressed: () async {
                amount = int.parse(_controller.text);
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  final email = currentUser.email;
                  final userDetails = await getUserDetails(email!);
                  phone = userDetails.phone;
                }

                if (phone != null) {
                  QuerySnapshot snapshot = await FirebaseFirestore.instance
                      .collection("expense")
                      .where('phone', isEqualTo: phone)
                      .get();

                  if (snapshot.docs.isNotEmpty) {
                    String docId = snapshot.docs.first.id;
                    await FirebaseFirestore.instance
                        .collection("expense")
                        .doc(docId)
                        .update({
                      _selectedCategory.toString():int.parse( _controller.text),
                      //'amount': amount,
                    }).then((_) {
                    //  _showSnackbarPass("Record updated successfully!");
                      setState(() {
                        _selectedCategory = null;
                        _controller.clear();
                        Navigator.pop(context);
                      });
                    }).catchError((error) {
                     // _showSnackbarFail("Failed to update record: $error");
                    });
                  } else {
                    CollectionReference collref =
                    FirebaseFirestore.instance.collection('expense');
                    collref.add({
                     // 'category': _selectedCategory,
                      _selectedCategory.toString():int.parse( _controller.text),
                      'phone': phone,
                     // 'amount': amount,
                    }).then((_) {
                     // _showSnackbarPass("Record inserted successfully!");
                      setState(() {
                        _selectedCategory=null;
                        _controller.clear();
                        Navigator.pop(context);
                      });
                    }).catchError((error) {
                    //  _showSnackbarFail("Failed to insert record: $error");
                    });
                  }
                } else {
                 // _showSnackbarFail("User's phone number not found!");
                }
              },
              child: Text("Save Categories"),
            ),
          ],
        ),
      ),
    );
  }
}
