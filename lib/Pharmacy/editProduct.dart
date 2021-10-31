import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/producat.dart';
import 'package:pharmacy_app/services/store.dart';
import 'package:pharmacy_app/widgets/custom_textFiled.dart';

import '../constants.dart';

class EditProduct extends StatelessWidget {
  static String id = 'EditProduct';
  String _name, _price, _description, _category, _imageLocation,_quantity;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
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
      body: Form(
        key: _globalKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomTextField(
                  hint: 'Medicine Name',
                  onClick: (value) {
                    _name = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  onClick: (value) {
                    _price = value;
                  },
                  hint: 'Medicine Price',
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  onClick: (value) {
                    _description = value;
                  },
                  hint: 'Product Description',
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  onClick: (value) {
                    _category = value;
                  },
                  hint: 'Product Category',
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  onClick: (value) {
                    _quantity = value;
                  },
                  hint: 'Quantity',
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  onClick: (value) {
                    _imageLocation = value;
                  },
                  hint: 'Product Image',
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    if (_globalKey.currentState.validate()) {
                      _globalKey.currentState.save();
                      _store.editProduct({
                        kProductQuantity:_quantity,
                        kProductName: _name,
                        kProductLocation: _imageLocation,
                        kProductCategory: _category,
                        kProductDescription: _description,
                        kProductPrice: _price
                      }, product.pId);
                    }
                    editmed(context);
                  },
                  child: Text('Edit Product'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  void editmed(BuildContext context){
    var alertDialog = AlertDialog(
      title: Text("Medicine edited successfully",style: TextStyle(fontFamily:'italic'),),
      elevation: 24,
      backgroundColor: Colors.brown.shade200,

    );
    showDialog(context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }
}
