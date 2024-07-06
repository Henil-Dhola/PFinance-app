
import 'package:flutter/material.dart';

import 'package:pf_project/src/models/content.dart';
import 'package:pf_project/src/repository/LoginPage.dart';

class Onbording extends StatefulWidget {

  @override
  _OnbordingState createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  int currentIndex = 0;
  late PageController _controller;


  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index)
              {
                setState(() {
                  currentIndex=index;
                });
              },
              itemBuilder: (_,i){
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Image.asset(contents[i].images, height: 400),

                      Text(contents[i].title,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(contents[i].discription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),)
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  contents.length,
                      (index) => buildDot(index,context)),
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.purpleAccent,
              border: Border.all(
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),

            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)
                        ),),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow,
                  ),
                ),
                child:Text(currentIndex == contents.length -1 ? "Continue" : "Next"),
                onPressed:(){
                  if(currentIndex==contents.length -1){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage())).then((value) => Navigator.pop(context));
                    //Navigator.pop(context);
                  }
                  _controller.nextPage(duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
                },

              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index,BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex==index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.purpleAccent,
      ),
    );
  }

}