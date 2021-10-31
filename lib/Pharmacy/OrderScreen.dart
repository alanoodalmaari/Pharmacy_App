import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/services/store.dart';

import '../constants.dart';
import 'order_details.dart';

class PharmacyInfo {
  String pharma_name;

  PharmacyInfo({this.pharma_name});
}

class OrdersScreen extends StatelessWidget {
  static String id = 'OrdersScreen';
  final Store _store = Store();
  @override
  Widget build(BuildContext context) {
    PharmacyInfo pharmaa = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade600,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Orders"),
      ),
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrders(pharmaa.pharma_name),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('there is no orders'),
            );
          } else {
            List<Order> orders = [];
            for (var doc in snapshot.data.docs) {
              orders.add(
                Order(
                  documentId: doc.id,
                  address: doc.data()[kAddress],
                  totallPrice: doc.data()[kTotallPrice],
                  // status: doc.data()['confirmed'] == null
                  //     ? false
                  //     : doc.data()['confirmed'],
                  status: doc.data()['confirmed'],
                  user: doc.data()['user'],
                  pharmacy: doc.data()['pharmacy'],
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      OrderDetails.id,
                      arguments: orders[index],
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .3,
                    color: kSecondaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              'Total Price = \MRY${orders[index].totallPrice}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Address is ${orders[index].address}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Payment Method: Cash',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Status: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: orders[index].status == null? 'Cancelled'
                                      : '${orders[index].status ? 'Confirmed' : 'Pending'}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: orders[index].status == null? Colors.red
                                          : orders[index].status
                                          ? Colors.green
                                          : Colors.amber),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: orders.length,
            );
          }
        },
      ),
    );
  }

  }

