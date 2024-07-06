
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pf_project/firebase_options.dart';
import 'package:pf_project/src/HomePage.dart';
import 'package:pf_project/src/OnboardingPage.dart';

import 'package:pf_project/src/SplashScreen.dart';
import 'package:pf_project/src/home.dart';


import 'package:pf_project/src/repository/Onboarding.dart';
import 'package:pf_project/src/repository/SplashPage.dart';
import 'package:pf_project/test.dart';


Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registration Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
     // home:PieChartDemo(),
    );
  }
}


class UserCheck extends StatefulWidget {
  const UserCheck({super.key});

  @override
  State<UserCheck> createState() => _UserCheckState();
}

class _UserCheckState extends State<UserCheck> {


  @override
  Widget build(BuildContext context) {

      User? user = FirebaseAuth.instance.currentUser;
      String? email=user?.email;
      if (user != null) {
        // If user is not authenticated, navigate to login screen

       // return Welcome(email);
        return Welcome(email);
      } else {
        // If user is authenticated, navigate to welcome screen
        return OnboardingPage();
      }


  }
}




