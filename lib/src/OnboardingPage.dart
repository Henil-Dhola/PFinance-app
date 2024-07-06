import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pf_project/src/repository/LoginPage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController controller=PageController();
  bool lastpage=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: SafeArea(
          child: Stack(
            children: [
              PageView(
                onPageChanged: (v){
                  setState(() {
                    lastpage=(v==2);
                  });
                },
                controller: controller,
                children: [
                  Container(
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Center(
                            child: Container(
                              height: 300,
                                width: 300,
                                child: LottieBuilder.asset("assets/Lottie/Animation - 1712677119125.json")),
                          ),
                          SizedBox(height: 10,),
                          Text("Financial Analysis",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black87),),
                          Center(child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text("Greed is not a financial issue. It's a heart issue.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black54)),
                          ))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                              height: 300,
                              width: 300,
                              child: LottieBuilder.asset("assets/Lottie/Animation - 1712682562114.json")),
                          SizedBox(height: 10,),
                          Text("Financial Saving",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black87),),
                          Center(child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              children: [
                                Text("You can See What's your Income & What's your Expenses.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black54)),
                                Text("According to this Save your Money,",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black54)),

                              ],
                            ),

                          )),
                          Text("This is our Motive",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.lightBlueAccent)),

                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            height: 300,
                              width: 300,
                              child: Image.asset("assets/image/man_atm.png")),
                          SizedBox(height: 10,),
                          Text("Financial Understanding",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black87),),
                          Center(child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              children: [
                                Text("Using chart you can easily understand your expenses.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black54)),

                              ],
                            ),

                          )),
                          Text("Easy to Use",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.lightBlueAccent)),

                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 50,
                  left: 170,
                  child: SmoothPageIndicator(controller:controller , count: 3,effect: SwapEffect(dotWidth: 10,dotHeight: 10,dotColor: Colors.blue),)
              ),
              lastpage?
              Positioned(
                bottom: 45,
                  right: 50,
                  child: InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage())).then((value) => Navigator.pop(context));

                },
                child: Text("Done",style: TextStyle(color: Colors.deepPurple,fontSize: 17,fontWeight: FontWeight.bold),),
              )):Container()

            ],
          )),
    );
  }
}
