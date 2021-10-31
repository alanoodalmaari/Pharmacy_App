import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/producat.dart';
import 'package:pharmacy_app/screens/pharmacy.dart';
import 'package:pharmacy_app/widgets/custom_textFiled.dart';
import 'package:pharmacy_app/services/store.dart';

class AddProduct extends StatelessWidget {
  static String id = 'AddProduct';
  String _name, _price, _description, _category, _imageLocation, _quantity;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  final String pharmacyName;

  AddProduct({Key key, this.pharmacyName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leadingWidth: 8,
        backgroundColor: Colors.brown.shade600,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {

            Navigator.pop(context);
          },
        ),
        title: Text("Add Medicine"),
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _globalKey,
        child: Column(
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
                  // can i add reset to delet the data

                  _store.addProduct(
                    Product(
                      pharmacy_name: pharmacyName,
                      pQuantity: _quantity,
                      pName: _name,
                      pPrice: _price,
                      pDescription: _description,
                      pLocation: _imageLocation,
                      pCategory: _category,
                    ),
                  );
                }
                addmed(context);
              },
              child: Text('Add Product'),
            )
          ],
        ),
      ),
    );
  }
 void addmed(BuildContext context){
    var alertDialog = AlertDialog(
      title: Text("Medicine added successfully",style: TextStyle(fontFamily:'italic'),),
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
