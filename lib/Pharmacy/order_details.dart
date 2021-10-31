import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/conversation.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/models/producat.dart';
import 'package:pharmacy_app/services/store.dart';
import 'package:pharmacy_app/services/utils.dart';


import '../constants.dart';

class OrderDetails extends StatelessWidget {
  static String id = 'OrderDetails';
  String value;
  //String address;
  Store store = Store();
  @override
  Widget build(BuildContext context) {
    Order order = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade600,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Orders Details"),
      ),
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<QuerySnapshot>(
          stream: store.loadOrderDetails(order.documentId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> products = [];
              for (var doc in snapshot.data.docs) {
                products.add(Product(
                  pName: doc.data()[kProductName],
                  pQQuantity: doc.data()[kProductQQuantity],
                  pCategory: doc.data()[kProductCategory],
                ));
              }
              List<Order> orders = [];
              for (var doc in snapshot.data.docs) {
                orders.add(Order(
                  //order.documentId: doc.id,
                  address: doc.data()[kAddress],
                ));
              }

              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .2,
                          color: kSecondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('product name : ${products[index].pName}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Quantity : ${products[index].pQQuantity}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'product Category : ${products[index].pCategory}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      itemCount: products.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        order.status != null? order.status
                            ? Expanded(
                          child: ButtonTheme(
                            buttonColor: kMainColor,
                            child: RaisedButton(
                              onPressed: () async {
                                // Store _store = Store();

                              },
                              child: Text('UnConfirm Order'),
                            ),
                          ),
                        )
                            : Expanded(
                          child: ButtonTheme(
                            buttonColor: kMainColor,
                            child: RaisedButton(
                              onPressed: () {
                                showCustomDialog(order, context);
                              },
                              child: Text('Confirm'),
                            ),
                          ),
                        ) : Container(),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text('Loading Order Details'),
              );
            }
          }),
    );
  }

  confirmOrder(time, order, context) async {
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(order.documentId)
        .update(
      {'confirmed': true, 'deliveryTime': time},
    );

    QuerySnapshot delivery = await FirebaseFirestore.instance
        .collection('users')
        .where('pharmacy_name', isEqualTo: order.pharmacy)
        .where('role', isEqualTo: 'delivery')
        .get();

    DatabaseService _deliverService = DatabaseService(
      path: 'users/${delivery.docs[0].id}',
    );

    DocumentReference _deliveryBoy = _deliverService.createRef();

    DatabaseService _userService = DatabaseService(
      path: 'users/${order.user}',
    );

    DocumentReference _user = _userService.createRef();

    var existconv = await FirebaseFirestore.instance
        .collection('conversations')
        .where('pharmacist', isEqualTo: _deliveryBoy)
        .where('client', isEqualTo: _user)
        .get();

    if (existconv.docs.length == 0) {
      Conversation newConv = Conversation(
        client: _user,
        pharmacist: _deliveryBoy,
        lastMessage: '',
        createdAt: DateTime.now(),
        lastMessageTime: DateTime.now(),
        messages: [],
        type: 'Delivery',
      );

      await FirebaseFirestore.instance.collection('conversations').add(
        newConv.toJson(),
      );
    }

    Navigator.pop(context);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order confirmed!")));
  }

  void showCustomDialog(order, context) async {
    String time = "";

    AlertDialog alertDialog = AlertDialog(
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            if (time.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please provide delivery time!")));
              return;
            }

            confirmOrder(time, order, context);
          },
          child: Text('Confirm'),
        )
      ],
      content: TextField(
        onChanged: (value) {
          time = value;
        },
        decoration:
        InputDecoration(hintText: 'Please provide time of delivery'),
      ),
      title: Text('Confirm Order'),
    );

    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }
}
