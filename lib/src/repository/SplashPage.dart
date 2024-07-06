import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:pf_project/main.dart';
import 'package:pf_project/src/repository/LoginPage.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset("assets/Lottie/Animation.json"),
          ],
        ),
        nextScreen: UserCheck(),
      splashIconSize: 400,
      backgroundColor: Colors.blueAccent.shade100,
    );
  }
}
