import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmacy_app/constants.dart';
import 'package:pharmacy_app/models/producat.dart';
import 'package:pharmacy_app/screens/pharmacy.dart';
import 'package:pharmacy_app/services/store.dart';
import 'package:pharmacy_app/widgets/custom_menu.dart';
import 'package:pharmacy_app/widgets/custom_textFiled.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/Pharmacy/editProduct.dart';

class MangeProducts extends StatefulWidget {
  static String id = 'MangeProducts';
  final String pharmacyName;

  const MangeProducts({Key key, this.pharmacyName}) : super(key: key);

  @override
  _MangeProductsState createState() => _MangeProductsState();
}

class _MangeProductsState extends State<MangeProducts> {
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    print('pharacystore ${widget.pharmacyName}');
    return Scaffold(
      appBar: AppBar(
        //leadingWidth: 8,
        backgroundColor: Colors.brown.shade600,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>PharmacyHomePage(),));
            Navigator.pop(context);
          },
        ),
        title: Text("Edit Medicine"),
      ),
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadProducts(
          widget.pharmacyName,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = [];
            for (var doc in snapshot.data.docs) {
              var data = doc.data;
              products.add(Product(
                  pId: doc.id,
                  pPrice: data()[kProductPrice],
                  pName: data()[kProductName],
                  pDescription: data()[kProductDescription],
                  pCategory: data()[kProductCategory],
                  pLocation: data()[kProductLocation],
                  pQuantity: data()[kProductQuantity]));
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .8,
              ),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: GestureDetector(
                  onTapUp: (details) async {
                    double dx = details.globalPosition.dx;
                    double dy = details.globalPosition.dy;
                    double dx2 = MediaQuery.of(context).size.width - dx;
                    double dy2 = MediaQuery.of(context).size.width - dy;
                    await showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                        items: [
                          MyPopupMenuItem(
                            onClick: () {
                              Navigator.pushNamed(context, EditProduct.id,
                                  arguments: products[index]);
                            },
                            child: Text('Edit'),
                          ),
                          MyPopupMenuItem(
                            onClick: () {
                              _store.deleteProduct(products[index].pId);
                              Navigator.pop(context);
                            },
                            child: Text('Delete'),
                          ),
                        ]);
                  },
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage(products[index].pLocation),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Opacity(
                          opacity: .6,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    products[index].pName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('\MYR ${products[index].pPrice}')
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              itemCount: products.length,
            );
          } else {
            return Center(child: Text('loading....'));
          }
        },
      ),
    );
  }
}
