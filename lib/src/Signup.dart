import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pf_project/src/repository/LoginPage.dart';

import 'authentication.dart';
import 'models/user_model.dart';

class SignupForm extends StatefulWidget {
  SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? fullname;
  String? phone;
  bool _obscureText = false;

  final pass = TextEditingController();

  final _db = FirebaseFirestore.instance;

  // Store data in firestore
  createUser(user_model usermodel) async {
    await _db.collection("Users").add(usermodel.toJson()).whenComplete(() =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Your Account has been Created Successfully..!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ))).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Something went wrong ,Please Try again..!",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var space = SizedBox(height: 10);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.shade100,
          image: DecorationImage(
            image: const AssetImage("assets/image/resturant.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.deepPurpleAccent.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            SizedBox(height: 50),
            // logo
            Column(
              children: [
                SizedBox(
                  child: Image.asset("assets/image/pficon.ico"),
                  height: 120,
                  width: 120,
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'PFinance Registration',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Email
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        email = val;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  space,

                  // Password
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: pass,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      onSaved: (val) {
                        password = val;
                      },
                      obscureText: !_obscureText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  space,

                  // Confirm Password
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != pass.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  space,

                  // Full Name
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Full name',
                        prefixIcon: Icon(Icons.account_circle),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                      onSaved: (val) {
                        fullname = val;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some name';
                        }
                        return null;
                      },
                    ),
                  ),
                  space,

                  // Phone Number
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: Icon(Icons.phone),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                      onSaved: (val) {
                        phone = val;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // Sign Up button
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          final user =
                          user_model(fullname, email, password, phone);
                          createUser(user);
                          AuthenticationHelper()
                              .signUp(email: email!, password: password!)
                              .then((result) {
                            if (result == null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            } else {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text(
                              //       result,
                              //       style: TextStyle(fontSize: 16),
                              //     ),
                              //   ),
                              // );
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(24.0)))),
                      child: Text('Sign Up'),
                    ),
                  ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text(
                  'Already have an account? Login now!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold
                  ),
                )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
