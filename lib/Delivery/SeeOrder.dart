import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/widgets/original_button.dart';

class seeOrdes extends StatelessWidget {
  static String id = 'seeOrdes';
  final String pharmacyName;

  const seeOrdes({Key key, this.pharmacyName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(pharmacyName);
    return Scaffold(
      appBar: AppBar(
        //leadingWidth: 8,
        backgroundColor: Colors.teal.shade600,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Order"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('pharmacy', isEqualTo: '${pharmacyName}')
            .where('confirmed', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> orders = snapshot.data.docs;

            return orders.length == 0
                ? Center(
                    child: Text('No orders..'),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: orders
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.teal.shade200,
                                    child: Align(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Order N : ${e.id}'),
                                        Text('Address : ${e['Address']}'),
                                        Text('Email : ${e['email']}'),
                                      ],
                                    )),
                                  ),

                                ),

                              )
                              .toList(),
                        ),
                      ),
                         Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 75),
                            child: OriginalButton(
                          text: 'Approve',
                          color: Colors.teal.shade500,
                          textColor: Colors.white,
                          onPressed: () {
                            Timer(Duration(seconds: 5),()=>Navigator.of(context).pushNamed('DeliverySut'));
                          },
                        ),
                      ),
                    ],
                  );

          } else
            return Center(
              child: Text('Loading orders...'),
            );


        },

      ),

    );
  }
}
