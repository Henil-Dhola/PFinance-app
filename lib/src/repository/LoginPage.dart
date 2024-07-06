

import 'package:flutter/material.dart';
import 'package:pf_project/src/HomePage.dart';
import 'package:pf_project/src/Signup.dart';

import 'package:pf_project/src/authentication.dart';
import 'package:pf_project/src/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  String? email;
  String? password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/image/resturant.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0,child: _buildButtom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Image.asset("assets/image/pficon.ico",height: 90),
          Text(
            "PFinance",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 35,
                letterSpacing: 2),
          )
        ],
      ),
    );
  }

  Widget _buildButtom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }


  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome",style: TextStyle(
          color: myColor, fontSize: 32, fontWeight: FontWeight.w500,),
        ),
        _buildGreyText("Plases login with your information"),
        const SizedBox(height: 30),
        _buildGreyText("Email address"),
        _buildInputField(emailController),
        const SizedBox(height: 40,),
        _buildGreyText("Password"),
        _buildInputField(passwordController,isPassword:true),
        const SizedBox(height: 20,),
       // _buildRememberForgot(),
        const SizedBox(height: 20,),
        _buildLoginButton(),
        const SizedBox(height: 20,),
        _buildOtherLogin(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style:const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye): Icon(Icons.done),
      ),
      obscureText: isPassword,
    );
  }

  // Widget _buildRememberForgot(){
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       TextButton(
  //           onPressed: () {}, child: _buildGreyText("I Forget my password"))
  //     ],
  //   );
  // }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed:() {
        // if (_formKey.currentState!.validate()) {
        //   _formKey.currentState!.save();
          email = emailController.text;
          password = passwordController.text;
          AuthenticationHelper()
              .signIn(email: email!, password: password!)
              .then((result) {
            if (result == null) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Welcome(email))).then((value) => Navigator.pop(context));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Invalid Credentials....",
                  style: TextStyle(fontSize: 16),
                ),
              ));
            }
          });
       // }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text("LOGIN"),
    );

  }

  Widget _buildOtherLogin(){
    return Center(
      child: Column(
          children: [
         // _buildGreyText("Or Login With "),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupForm()));
            }, child: Text("Sign Up")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Tab(icon: Image.asset(("assets/image/social.png")),height: 60,
                )
                  ]
                )
        ],
      ),
    );
  }
}

