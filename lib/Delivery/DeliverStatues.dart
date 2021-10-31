import 'package:flutter/material.dart';

class DeliverySut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            SizedBox(height: 10),
                        Center(

                          child: Column(

                           children: <Widget>[
                                Text(
                              'Delivery Confirmed!',
                            style: TextStyle(
                               color: Colors.blueGrey,
                                      fontSize: 32,
                                 fontWeight: FontWeight.w600,
                             letterSpacing: 1.2),
                                ),

                                 Hero(
                                   tag: 'logoAnimation',
                                    child: Image.asset(
                                   'assets/images/ontheway.gif',
                                      fit: BoxFit.cover,
                                          height: 290,

                                        ),
                                      ),
                            // SizedBox(height: 20),
          ],
        ),
      ),
    ]
    )
      )
    );
  }
}
