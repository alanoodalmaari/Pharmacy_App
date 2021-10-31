import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  static const List<String> names = [];
  searchByProductName(String searchFiled, {List<String> pharmacyNames: names}) {
    print("nearby->");
    print(names);
    var query = FirebaseFirestore.instance.collection('Products').where(
        'productName',
        isEqualTo: searchFiled.substring(0, 1).toUpperCase());

    if (names.isNotEmpty) {
      query.where('pharmacy_name', whereIn: names);
    }

    return query.get();
  }
}
