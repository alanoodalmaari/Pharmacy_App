import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Carousel(
        showIndicator: false,
        animationDuration: Duration(milliseconds: 600),
        images: [
          Image.asset('assets/images/neelogoW.jpg'),
          Image.asset('assets/images/del22.png'),
          Image.asset('assets/images/pharmacistgi.jpg'),
        ],

      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          showDialog(context: context,
              barrierDismissible:false,
              builder:(BuildContext context){
                return Center(
                  child: Opacity(opacity: 1.0,
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.orangeAccent),
                    ),),
                );
              });
          Timer(Duration(seconds: 5),()=>Navigator.of(context).pushNamed('login'));
          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>newPage(),));
        },
        label: Text('Start'),
        icon: Icon(Icons.arrow_right),
        backgroundColor: Colors.orange.shade300,
        elevation: 10,),

    );
  }
}