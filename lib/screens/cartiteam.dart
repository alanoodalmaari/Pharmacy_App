import 'package:flutter/cupertino.dart';
import 'package:pharmacy_app/models/producat.dart';

class CartItem extends ChangeNotifier {
  List<Product> products = [];

  addProduct(Product product) {
    products.add(product);
    notifyListeners();
  }

  deleteProduct(Product product) {
    products.remove(product);
    notifyListeners();
  }
}
