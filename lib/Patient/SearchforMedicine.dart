import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pharmacy_app/Patient/CartScreen.dart';
import 'package:pharmacy_app/constant/map_key.dart';
import 'package:pharmacy_app/screens/patient_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:pharmacy_app/models/producat.dart';
import 'package:pharmacy_app/screens/productinfo.dart';
import '../constants.dart';
import 'SearchServise.dart';
import 'package:location/location.dart' as LocationManager;

class SearchMidPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SearchMidPage> {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: MapKey.apiKey);
  bool isLoading = true;
  List<PlacesSearchResult> pharmacies = [];
  final LatLng _center = const LatLng(45.521563, -122.677433);

  @override
  void initState() {
    super.initState();
    loadNearByPharmacies();
  }

  loadNearByPharmacies() async {
    try {
      final center = await getUserLocation();
      //final center = LatLng(3.0704353, 101.7072921);
      final searchedPharmacies = await getNearbyPharmacies(center);
      setState(() {
        pharmacies = searchedPharmacies;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Something went wrong! please make sure your gps is on and you have allowed location permissions.")));
      print('something went wrong' + e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation;
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200.0,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: [
          Image.asset('assets/images/Guardianligo.jpg'),
          AssetImage('assets/images/wa.png'),
          AssetImage('assets/images/BigPharmacy.jpg'),
          AssetImage('assets/Medicines/flavettes.jpg'),
          AssetImage('assets/Medicines/blackmores.jpg'),
        ],

        autoplay: false,
        dotSize: 5.0,
        indicatorBgPadding: 5.0,
      ),
    );
    return Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientHomePage(),
                ),
              );
            },
          ),
          elevation: 0.1,
          backgroundColor: Colors.blueGrey,
          title: Text('A-Pharma'),
          actions: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.id);
                })
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              image_carousel,
              if (isLoading)
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: CircularProgressIndicator()))
              else
                MyHomePage(pharmacies),
            ],
          ),
        ));
  }

  Future<List<PlacesSearchResult>> getNearbyPharmacies(LatLng center) async {
    final location = Location(lat: center.latitude, lng: center.longitude);
    final result =
    await _places.searchNearbyWithRadius(location, 2500, type: 'pharmacy');
    return result.results;
  }
}

void getSearch() async {
  // FIREBASE INTIALIZAITON
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(
    (new PatientSearch()),
  );
}

class PatientSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: new MyHomePage([]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  List<PlacesSearchResult> pharmacies;

  MyHomePage(this.pharmacies);

  @override
  _MyHomePageState createState() => new _MyHomePageState(pharmacies);
}

class _MyHomePageState extends State<MyHomePage> {
  final allowedPharmacyList = ["Guardian","Watson","Health Lane Family","CARiNG","Big","AA"];
  List<String> pharmacies;

  _MyHomePageState(List<PlacesSearchResult> pharmacies){
    this.pharmacies = [];
    pharmacies.forEach((element) {
      final pharmacyName = shouldAdd(element);
      print("pharmacy names found------");
      print(pharmacyName);
      if(pharmacyName != null) {
        this.pharmacies.add(pharmacyName.toLowerCase());
      }
    });
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  String shouldAdd(PlacesSearchResult pharmacy) {
    for(String name in allowedPharmacyList){
      if(pharmacy.name.toLowerCase().contains(name.toLowerCase())){
        return name;
      }
    }
    return null;
  }

  initiateSearch(String value) {
    if (value.length != 0) {
      var capitalizedValue =
          value.substring(0, 1).toUpperCase() + value.substring(1);
      SearchService()
          .searchByProductName(capitalizedValue, pharmacyNames: pharmacies)
          .then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; i++) {
          print(docs.docs[i].data()['productName']);
          setState(() {
            queryResultSet
                .add({'pName': docs.docs[i].id, ...docs.docs[i].data()});
            queryResultSet.forEach((element) {
              if (element['productName']
                  .toString()
                  .startsWith(capitalizedValue)) {
                setState(() {
                  if (tempSearchStore.indexWhere(
                          (Product) => Product['pName'] == element['pName']) <
                      0) {
                    tempSearchStore.add(element);
                  }
                });
              }
            });
          });
        }
      });
    } else {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

  }

  String searchName = '';
  List<QueryDocumentSnapshot> _players = [];

  bool _isUpper = false;

  bool isUpperCase(String string) {
    if (string == null) {
      return false;
    }
    if (string.isEmpty) {
      return false;
    }
    if (string.trimLeft().isEmpty) {
      return false;
    }
    String firstLetter = string.trimLeft().substring(0, 1);
    if (double.tryParse(firstLetter) != null) {
      return false;
    }
    return firstLetter.toUpperCase() == string.substring(0, 1);
  }

  _getMedecine(String name) async {
    if (name != '') {
      setState(() {
        searchName = name;
      });
      if (!isUpperCase(name)) {
        name = name.replaceRange(0, 1, name[0].toUpperCase());
        print(name);
        Query q = FirebaseFirestore.instance
            .collection('Products')
            .orderBy('productName')
            .startAt([name]).endAt(
          [name + "\uf8ff"],
        );

        QuerySnapshot querySnapshot = await q.get();
        _players = querySnapshot.docs;
      } else {
        print(name);
        Query q = FirebaseFirestore.instance
            .collection('Products')
            .orderBy('productName')
            .startAt([name]).endAt(
          [name + "\uf8ff"],
        );


        QuerySnapshot querySnapshot = await q.get();
        _players = querySnapshot.docs;
      }
    } else {
      setState(() {
        _players = [];
      });
    }

    setState(() {});
    print(_players);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          onChanged: (val) {
            _getMedecine(val);
          },
          decoration: InputDecoration(
              prefixIcon: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                iconSize: 20.0,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              contentPadding: EdgeInsets.only(left: 25.0),
              hintText: 'Search ',
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Column(
        children: _players.map((element) {
          return pharmacies.contains(element['pharmacy_name'].toLowerCase())? buildResultCard(context, element, searchName): SizedBox();
        }).toList(),
      )
    ]);
  }
}

Widget buildResultCard(context, data, String searchName) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    elevation: 2.0,
    child: InkWell(
      onTap: () {
        var product = Product(
            pId: data.id,
            pQuantity: data[kProductQuantity],
            pPrice: data[kProductPrice],
            pName: data[kProductName],
            pDescription: data[kProductDescription],
            pLocation: data[kProductLocation],
            pCategory: data[kProductCategory],
            pharmacy_name: data['pharmacy_name']);

        Navigator.pushNamed(context, ProductInfo.id, arguments: product);
      },
      child: Container(
        height: 200,
        child: Center(
          child: Row(
            children: [
              Container(
                width: 100,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Container(
                  color: Colors.black12,
                  //child: Align(child: Text('IMAGE')),

                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        data['pharmacy_name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text((data['productName'] as String).length > 40
                              ? (data['productName'] as String).substring(0, 30)
                              : (data['productName'] as String)),
                          Image.asset(
                            data['productLocation'],
                            height: 30,
                            width: 30,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
