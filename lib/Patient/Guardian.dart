import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pharmacy_app/services/auth.dart';
import 'package:pharmacy_app/widgets/original_button.dart';

import 'Chat.dart';
import 'ProducatsPage.dart';

// ignore: must_be_immutable
class PatientPharmacyHomePage extends StatelessWidget {
  final String userName;
  final PlacesSearchResult pharmacy;
  PatientPharmacyHomePage({Key key, this.userName, this.pharmacy})
      : super(key: key);
  AuthBase authBase = AuthBase();

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 350.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/D5.jpg'),
          AssetImage('assets/Medicines/flavettes.jpg'),
          AssetImage('assets/Medicines/cough.png'),
          AssetImage('assets/Medicines/ear1.jpg'),
          AssetImage('assets/Medicines/eye.jpg'),
        ],
        autoplay: false,
//      animationCurve: Curves.fastOutSlowIn,
//      animationDuration: Duration(milliseconds: 1000),
        dotSize: 5.0,
        indicatorBgPadding: 10.0,
      ),
    );
    return Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.1,
          backgroundColor: Colors.blueGrey,
          title: Text('A-Pharma'),
        ),
        body: new ListView(
          children: <Widget>[
            image_carousel,
            new Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: new Text(
                '          Welcome to'
                     ' ${pharmacy.name} Pharmacy',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: OriginalButton(
                text: 'See The Medicine',
                color: Colors.blueGrey,
                textColor: Colors.grey.shade200,
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ProductsPage(
                      pharmacyName: pharmacy.name,
                    ),
                  ));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: OriginalButton(
                text: 'Chat Pharmacist ',
                color: Colors.blueGrey,
                textColor: Colors.grey.shade200,
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ChatsPage(
                      pharmacy: pharmacy.name,
                    ),
                  ));
                },
              ),
            ),
          ],
        ));
  }
}
