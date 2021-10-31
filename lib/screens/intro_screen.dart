import 'dart:async';
import 'package:flutter/material.dart';
import 'LandingPage.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(primaryColor:Colors.black),
  // home:IntroScreen(),
));

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), ()=> Navigator.push(
        context, MaterialPageRoute(builder: (context) =>
        LandingScreen())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width:double.infinity,
        child: Container(
            child: Padding(padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: new CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 200,
                        child: Image.asset('assets/images/intrologo.jpg'),
                      )
                  ),
                  SizedBox(height: 40,),
                  Container(
                      child: new CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 30,
                        child: Image.asset('assets/images/ani.gif'),
                      )
                  ),
                ],
              ),)
        ),
      ),

    );
  }
}






