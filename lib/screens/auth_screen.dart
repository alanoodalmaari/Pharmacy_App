import 'package:flutter/material.dart';
import 'package:pharmacy_app/widgets/auth_form.dart';

enum AuthType { login, register,register2,catergory }

class AuthScreen extends StatelessWidget {
  final AuthType authType;

  const AuthScreen({Key key, this.authType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    //color: Colors.orangeAccent.shade200,
                    color: Colors.orange.shade200,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 65),
                      Text(
                        'Hello!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2),
                      ),
                      Hero(
                        tag: 'logoAnimation',
                        child: Image.asset(
                          //'assets/images/newlogo.png',
                          'assets/images/flogo2.png',
                          height: 260,
                        ),
                      ),
                    ],
                  ),
                ),


              ],
            ),
            AuthForm(authType: authType),
          ],
        ),
      ),
    );
  }
}
