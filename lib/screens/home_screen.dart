import 'package:flutter/material.dart';
import 'package:pharmacy_app/screens/intro_screen.dart';
import 'package:pharmacy_app/services/auth.dart';

class HomeScreen extends StatelessWidget {
  AuthBase authBase = AuthBase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('Sign out'),
          onPressed: () async {
            await authBase.logout();
            //Navigator.of(context).pushReplacementNamed('login');
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>IntroScreen(),));
          },
        ),
      ),
    );
  }
}