import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pf_project/src/OnboardingPage.dart';
import 'package:pf_project/src/models/user_model.dart';
import 'package:pf_project/src/authentication.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:pf_project/src/repository/Onboarding.dart';
import 'package:pf_project/src/repository/UpdateProfile.dart';

import '../models/ProfileMenu.dart';

class ProfileScreen extends StatelessWidget {
  final String email;
  ProfileScreen(this.email);

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text("Profile Page", style: Theme.of(context).textTheme.headline4),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset("assets/image/proman.png"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("Welcome to Kignsman", style: Theme.of(context).textTheme.headline4),
              Text(email, style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfileScreen(email)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text("Edit Profile", style: TextStyle(color: Colors.orange)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false, // Prevent user from dismissing dialog
                    builder: (context) => AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text("Removing data..."),
                        ],
                      ),
                    ),
                  );

                  try {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser == null) {
                      print("User is not authenticated"); // Debug statement
                      Navigator.pop(context); // Dismiss the dialog
                      return;
                    }

                    final userDataSnapshot = await FirebaseFirestore.instance
                        .collection("Users")
                        .where('Email', isEqualTo: email)
                        .limit(1)
                        .get();

                    if (userDataSnapshot.docs.isNotEmpty) {
                      final userData = user_model.fromSnapshot(userDataSnapshot.docs.first);

                      // Deleting documents from 'expense' collection
                      final expenseSnapshot = await FirebaseFirestore.instance
                          .collection('expense')
                          .where('phone', isEqualTo: userData.phone)
                          .get();

                      if (expenseSnapshot.docs.isNotEmpty) {
                        for (final doc in expenseSnapshot.docs) {
                          await doc.reference.delete();
                        }
                        // Show a SnackBar indicating successful deletion of expense data
                      } else {
                        // Show a SnackBar indicating no expense data to delete
                      }

                      // Deleting documents from 'income' collection
                      final incomeSnapshot = await FirebaseFirestore.instance
                          .collection('income')
                          .where('phone', isEqualTo: userData.phone)
                          .get();

                      if (incomeSnapshot.docs.isNotEmpty) {
                        for (final doc in incomeSnapshot.docs) {
                          await doc.reference.delete();
                        }
                        // Show a SnackBar indicating successful deletion of income data
                      } else {
                        // Show a SnackBar indicating no income data to delete
                      }

                    } else {
                      // Show a SnackBar indicating user data not found
                    }
                  } catch (e) {
                    print("Error: $e");
                    // Show a SnackBar indicating an error occurred
                  } finally {
                    Navigator.pop(context); // Dismiss the dialog
                  }
                },
                child: Text("Reset Transaction"),
              ),


              const Divider(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  AuthenticationHelper()
                      .signOut()
                      .then(
                        (_) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => OnboardingPage()),
                    ).then(
                          (_) => Navigator.pop(context),
                    ),
                  );
                },
                child: Text("Logout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
