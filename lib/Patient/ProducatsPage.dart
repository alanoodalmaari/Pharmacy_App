import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/producat.dart';
import 'package:pharmacy_app/screens/auth_screen.dart';
import 'package:pharmacy_app/screens/intro_screen.dart';
import 'package:pharmacy_app/screens/productinfo.dart';
import 'package:pharmacy_app/services/auth.dart';
import 'package:pharmacy_app/services/store.dart';
import 'package:pharmacy_app/widgets/producatView.dart';
import '../constants.dart';
import '../funcations.dart';
import 'CartScreen.dart';
import 'DeliveryOrder.dart';

class ProductsPage extends StatefulWidget {
  static String id = 'ProductsPage';
  final String pharmacyName;

  const ProductsPage({Key key, this.pharmacyName}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  AuthBase authBase = AuthBase();
  final AuthType authType = AuthType.login;
  int _tabBarIndex = 0;
  int _bottomBarIndex = 0;
  final _store = Store();
  List<Product> _products;

  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: kUnActiveColor,
          currentIndex: _bottomBarIndex,
          fixedColor: kMainColor,
          onTap: (value) async {
            if (value == 2) {
            }
            setState(() {
              _bottomBarIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                title: Text('Discover'), icon: Icon(Icons.card_travel)),
            BottomNavigationBarItem(
                title: Text('My Order'), icon: Icon(Icons.person)),
            //BottomNavigationBarItem(
            //title: Text('Test'), icon: Icon(Icons.person)),
            BottomNavigationBarItem(
                title: Text('Sign Out'), icon: Icon(Icons.close)),
          ],
        ),
        body: widgets[_bottomBarIndex]);
  }

  @override
  void initState() {
    widgets = [
      DiscoverPage(
        pharmacyName: widget.pharmacyName,
      ),
      DeliveryOrder(
          pharmacyName: widget.pharmacyName
      ),
      IntroScreen(),
    ];
    getCurrenUser();
  }

  getCurrenUser() async {
    //_loggedUser = await _auth.getUser();
  }

  Widget healthcareView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProducts(widget.pharmacyName),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data.docs) {
            var data = doc.data;
            products.add(Product(
                pId: doc.id,
                pQuantity: data()[kProductQuantity],
                pPrice: data()[kProductPrice],
                pName: data()[kProductName],
                pDescription: data()[kProductDescription],
                pLocation: data()[kProductLocation],
                pCategory: data()[kProductCategory],
                pharmacy_name: data()['pharmacy_name']));
          }
          _products = [...products];
          products.clear();
          products = getProductByCategory(kHealthcare, _products);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .8,
            ),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProductInfo.id,
                      arguments: products[index]);
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('\MRY ${products[index].pPrice}')
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
          return Center(child: Text('Loading...'));
        }
      },
    );
  }
}

class DiscoverPage extends StatefulWidget {
  final String pharmacyName;

  const DiscoverPage({Key key, this.pharmacyName}) : super(key: key);
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  AuthBase authBase = AuthBase();
  final AuthType authType = AuthType.login;
  int _tabBarIndex = 0;
  int _bottomBarIndex = 0;
  final _store = Store();
  List<Product> _products;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: kMainColor,
                onTap: (value) {
                  setState(() {
                    _tabBarIndex = value;
                  });
                },
                tabs: <Widget>[
                  Text(

                    'FirstAid',
                    style: TextStyle(
                      color: _tabBarIndex == 0 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 0 ? 16 : null,
                    ),
                  ),
                  Text(

                    'EarCare',
                    style: TextStyle(
                      color: _tabBarIndex == 1 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 1 ? 16 : null,
                    ),
                  ),
                  Text(

                    'EyeCare',
                    style: TextStyle(
                      color: _tabBarIndex == 2 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 2 ? 16 : null,
                    ),
                  ),
                  Text(

                    'Vitamins',
                    style: TextStyle(
                      color: _tabBarIndex == 3 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarIndex == 3 ? 16 : null,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                healthcareView(),
                ProductsView(kEyecare, _products),
                ProductsView(kEarcare, _products),
                ProductsView(kVitamin, _products),
              ],
            ),
          ),
        ),
        Material(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Discover'.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, CartScreen.id);
                      },
                      child: Icon(Icons.shopping_cart))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  getCurrenUser() async {
    //_loggedUser = await _auth.getUser();
  }

// here can change
  //Widget jacketView()
  Widget healthcareView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProducts(widget.pharmacyName),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data.docs) {
            var data = doc.data;
            products.add(Product(
                pId: doc.id,
                pQuantity: data()[kProductQuantity],
                pPrice: data()[kProductPrice],
                pName: data()[kProductName],
                pDescription: data()[kProductDescription],
                pLocation: data()[kProductLocation],
                pCategory: data()[kProductCategory],
                pharmacy_name: data()['pharmacy_name']));
          }
          _products = [...products];
          products.clear();

          products = getProductByCategory(kHealthcare, _products);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .8,
            ),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProductInfo.id,
                      arguments: products[index]);
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('\MRY ${products[index].pPrice}')
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
          return Center(child: Text('Loading...'));
        }
      },
    );
  }
}
