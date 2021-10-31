import 'package:flutter/material.dart';
import 'package:pharmacy_app/screens/home_screen.dart';
import 'package:pharmacy_app/services/auth.dart';
import 'package:pharmacy_app/widgets/original_button.dart';

class CategoryScreen extends StatelessWidget {
  AuthBase authBase = AuthBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/categor.gif',
                ),
                fit:BoxFit.cover
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(""),
            new Container(
              margin: const EdgeInsets.only(bottom: 30.0),
              child: new Text(
                'Welcome To A-Pharma app',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey.shade800,
                ),
              ),
            ),

            Hero(
              tag: 'logoAnimation',
              child: Image.asset(
                'assets/images/patient.png',
                fit: BoxFit.cover,
                height: 88,

              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
              child: OriginalButton(
                text: 'Patient',
                color: Colors.orange.shade200,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('register', arguments: 'patient');
                },
              ),
            ),
            SizedBox(height: 10),

            Hero(
              tag: 'logoAnimation',
              child: Image.asset(
                'assets/images/pharmacist.webp',
                fit: BoxFit.cover,
                height:88,

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
              child: OriginalButton(
                text: 'Pharmacy',
                color:  Colors.orange.shade200,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('register', arguments: 'pharmacy');
                },
              ),
            ),
            SizedBox(),

            Hero(
              tag: 'logoAnimation',
              child: Image.asset(
                'assets/images/log.jpg',
                fit: BoxFit.cover,
                height: 88,

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
              child: OriginalButton(
                text: 'Delivery',
                color: Colors.orange.shade200,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('register', arguments: 'delivery');
                },
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
