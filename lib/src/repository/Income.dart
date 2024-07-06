import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  int income=0;
  List<String> income_categories = [
    "Shopping",
    "Grocery",
    "Entertainment",
    "Transportation",
  ];
  List<String> selectedCategories = [];
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Income Page"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Center(
            child: Text("Set income"),
          ),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Set Your income",
              hintText: "Enter Income",
              border: OutlineInputBorder(),
            ),

          ),
          SizedBox(height: 16.0),
          ElevatedButton(onPressed: () async {
             income = int.parse(_controller.text);
             final currentUser = FirebaseAuth.instance.currentUser;
             if (currentUser != null) {
               final email = currentUser.email;
               final userDetails = await getUserDetails(email!);
               phone = userDetails.phone;
             }
              DocumentSnapshot snapshot=await FirebaseFirestore.instance.collection("income").doc(income.toString()).get();
              print(income);
             if(snapshot.exists){
               await FirebaseFirestore.instance.collection("income").doc(income.toString()).update({
                 'user_income': income,
               });
             }else{
               CollectionReference collref =
               FirebaseFirestore.instance.collection('income');

               collref.add({
                 'user_income': income,
                 'phone': phone,
               }).then((_) {
                 _showSnackbarPass("Record inserted successfully!");

                 setState(() {
                   _controller.clear();
                   // selectedCategories.clear();

                 });
               }).catchError((error) {
                 _showSnackbarFail("Failed to insert record: $error");
               });
             }


          },
              child: Text("Add Income")
          ),
          SizedBox(height: 20,),
          Center(child: Text("Select categories")),
          ListView.builder(
            shrinkWrap: true,
            itemCount: income_categories.length,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                title: Text(income_categories[index]),
                value: selectedCategories.contains(income_categories[index]),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null ) {
                      selectedCategories.add(income_categories[index]);

                    } else {
                      selectedCategories.remove(income_categories[index]);
                    }
                  });
                },
              );
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null) {
                final email = currentUser.email;
                final userDetails = await getUserDetails(email!);
                phone = userDetails.phone;
              }

              CollectionReference collref =
              FirebaseFirestore.instance.collection('category');
              collref.add({
                //'user_income': income,
                 'expense_category': selectedCategories,
                'phone': phone,
              }).then((_) {
                _showSnackbarPass("Record inserted successfully!");

                setState(() {
                //  _controller.clear();
                  selectedCategories.clear();

                });
              }).catchError((error) {
                _showSnackbarFail("Failed to insert record: $error");
              });
            },
            child: Text(
              "Save",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
