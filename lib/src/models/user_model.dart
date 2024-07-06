import 'package:cloud_firestore/cloud_firestore.dart';

class user_model{
  String? fullname;
  String? email;
  String? password;
  String? phone;

  user_model(this.fullname, this.email, this.password,this.phone);


  toJson(){
    return{
      "Fullname":fullname,
      "Email":email,
      "Password":password,
      "Phone":phone,
    };
  }

  factory user_model.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    final data=document.data()!;
    return user_model(data["Fullname"], data["Email"], data["Password"], data["Phone"]);
  }
}