import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/Patient/Guardian.dart';
import 'package:pharmacy_app/Pharmacy/order_details.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/services/store.dart';
import 'package:pharmacy_app/widgets/original_button.dart';

import '../constants.dart';

class DeliveryOrder extends StatefulWidget {
  final String pharmacyName;
  const DeliveryOrder({Key key, this.pharmacyName}) : super(key: key);

  @override
  _DeliveryOrderState createState() => _DeliveryOrderState(pharmacyName);
}

class _DeliveryOrderState extends State<DeliveryOrder> {
  final String pharmacyName;
  final String email = FirebaseAuth.instance.currentUser.email;

  _DeliveryOrderState(this.pharmacyName);
  final _store = Store();

  @override
  Widget myOrderView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadOrders(pharmacyName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('there is no orders'),

          );
        } else {
          List<Order> orders = [];
          for (var doc in snapshot.data.docs) {
            if (doc.data()['email'] == email) {
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
                    deliveryTime: doc.data()['deliveryTime']),
              );
            }
          }
          return ListView.builder(
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: MediaQuery.of(context).size.height * .35,
                color: kSecondaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Totall Price = \MRY${orders[index].totallPrice}',
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
                      if (orders[index].deliveryTime != null)
                        Text(
                          'Delivery Time: ${orders[index].deliveryTime}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (orders[index].deliveryTime != null)
                        SizedBox(
                          height: 15,
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
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: (){
                          //_store.deleteOrder(orders[index].documentId);
                          _store.editOrder({
                            kTotallPrice: orders[index].totallPrice,
                            kAddress: orders[index].address,
                            'confirmed': null,
                            'user': orders[index].user,
                            'email': FirebaseAuth.instance.currentUser.email,
                            'pharmacy': orders[index].pharmacy,
                          }, orders[index].documentId);
                          ScaffoldMessenger.of(context)
                            ..showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Order cancelled successfully!")),
                            );
                        },
                        child: Container(
                          height: 50,
                          width: 120,
                          alignment: Alignment.center,
                          child: Text("Cancel Order", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white
                          ),),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(25.0)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            itemCount: orders.length,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return myOrderView();
  }
}
