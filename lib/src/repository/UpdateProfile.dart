import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:pf_project/src/models/user_model.dart';


class UpdateProfileScreen extends StatelessWidget{

  String email;
  UpdateProfileScreen(this.email);
  TextEditingController name=TextEditingController();
  //TextEditingController email=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController pwd=TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => {
          Navigator.pop(context)
        }, icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text("Edit Profile", style: Theme.of(context).textTheme.headline4),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset("assets/image/proman.png")),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.orangeAccent),
                      child: const Icon(LineAwesomeIcons.camera, color: Colors.black, size: 20),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                   // Text(email),
                    _user_name(),
                    // TextFormField(
                    //   controller: name,
                    //   decoration: const InputDecoration(
                    //
                    //       label: Text("Full Name"), prefixIcon: Icon(LineAwesomeIcons.user)),
                    // ),
                    const SizedBox(height:  20),
                    TextFormField(
                    readOnly: true, // Make the phone number field read-only
                    decoration: InputDecoration(
                      hintText: email,
                      prefixIcon: Icon(LineAwesomeIcons.phone),
                    ),
                  ),
                    const SizedBox(height:  20),
                    _user_phone(),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: pwd,
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon:
                        IconButton(icon: const Icon(LineAwesomeIcons.eye_slash), onPressed: () {}),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => {
                          _updateData(name.text,email,phone.text,pwd.text)

                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Edit Profile", style: TextStyle(color: Colors.blueGrey)),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Future<void> _updateData(String name,String email,String phone,String pwd) async {
  // Get a reference to the document you want to update
  final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
      .collection("Users")
      .where('Email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .get();

  // Check if the query returned any documents
  if (querySnapshot.docs.isNotEmpty) {
    // Get the first document in the query result
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = querySnapshot.docs.first;

    // Get a reference to the document and update its data
    final DocumentReference documentReference = FirebaseFirestore.instance.doc(documentSnapshot.reference.path);
    await documentReference.update({
      'Email':email,
      'Fullname':name,
      'Password':pwd,

    });

    print('Document updated successfully');
  } else {
    print('Document not found');
  }
}
Widget _user_phone() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .limit(1) // Limit the number of documents retrieved to 1
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      }
      if (snapshot.data!.docs.isEmpty) {
        return Text('No phone number found');
      }
      DocumentSnapshot document = snapshot.data!.docs.first;
      //return Text("Phone"+document['Phone']);
      return  TextFormField(
        readOnly: true, // Make the phone number field read-only
        decoration: InputDecoration(
          hintText: document['Phone'],
          prefixIcon: Icon(LineAwesomeIcons.phone),
        ),
      );
    },
  );
}

Widget _user_name() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .limit(1) // Limit the number of documents retrieved to 1
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      }
      if (snapshot.data!.docs.isEmpty) {
        return Text('No phone number found');
      }
      DocumentSnapshot document = snapshot.data!.docs.first;
      //return Text("Phone"+document['Phone']);
      return  TextFormField(

        decoration: InputDecoration(
          hintText: document['Fullname'],
          prefixIcon: Icon(LineAwesomeIcons.user),
        ),
      );
    },
  );
}


