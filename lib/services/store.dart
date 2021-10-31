import 'package:flutter/cupertino.dart';
import 'package:pharmacy_app/constants.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/models/producat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Store {
  // final Firestore _firestore = Firestore.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addProduct(Product product) async {
    await _firestore.collection(kProductsCollection).add({
      kProductName: product.pName,
      kProductDescription: product.pDescription,
      kProductLocation: product.pLocation,
      kProductCategory: product.pCategory,
      kProductPrice: product.pPrice,
      kProductQuantity: product.pQuantity,
      'pharmacy_name': product.pharmacy_name
    });
  }

  Stream<QuerySnapshot> loadProducts(String pharmacyName) {
    return _firestore
        .collection(kProductsCollection)
        .where('pharmacy_name', isEqualTo: pharmacyName)
        .snapshots();
  }

  Stream<QuerySnapshot> loadOrders(String pharmacyName) {
    return _firestore
        .collection(kOrders)
        .where('pharmacy', isEqualTo: pharmacyName)
        .snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(documentId) {
    return _firestore
        .collection(kOrders)
        .doc(documentId)
        .collection(kOrderDetails)
        .snapshots();
  }

  deleteProduct(documentId) {
    _firestore.collection(kProductsCollection).doc(documentId).delete();
  }

  editProduct(data, documentId) {
    _firestore.collection(kProductsCollection).doc(documentId).update(data);
  }

  deleteOrder(documentId) {
    _firestore.collection(kOrders).doc(documentId).delete();
  }

  editOrder(data, documentId) {
    _firestore.collection(kOrders).doc(documentId).update(data);
  }
  // new one
  storeProducts(data, List<Order> orders) {
    var documentRefe = _firestore.collection(kDeliverPro).doc();
    documentRefe.set(data);
    for (var product in orders) {
      documentRefe
          .collection(kDeliverProDet)
          .doc()
          .set({kAddress: product.address});
    }
  }

  storeOrders(data, List<Product> products) {
    var documentRef = _firestore.collection(kOrders).doc();
    documentRef.set(data);
    for (var product in products) {
      documentRef.collection(kOrderDetails).doc().set({
        kProductName: product.pName,
        kProductPrice: product.pPrice,
        kProductQQuantity: product.pQQuantity,
        kProductLocation: product.pLocation,
        kProductCategory: product.pCategory
      });
    }
  }
}
