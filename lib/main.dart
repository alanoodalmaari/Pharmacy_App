
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/Delivery/SeeOrder.dart';
import 'package:pharmacy_app/Patient/SearchforMedicine.dart';
import 'package:pharmacy_app/screens/auth_screen.dart';
import 'package:pharmacy_app/screens/cartiteam.dart';
import 'package:pharmacy_app/screens/category_screen.dart';
import 'package:pharmacy_app/screens/delivery_home.dart';
import 'package:pharmacy_app/screens/home_screen.dart';
import 'package:pharmacy_app/screens/intro_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_app/screens/patient_home.dart';
import 'package:pharmacy_app/screens/pharmacy.dart';
import 'package:pharmacy_app/screens/productinfo.dart';
import 'package:pharmacy_app/services/Uusers.dart';
import 'package:pharmacy_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:pharmacy_app/models/user_model.dart';
import 'Delivery/DeliverStatues.dart';
import 'Patient/CartScreen.dart';
import 'Patient/Chat.dart';
import 'Patient/DeliveryOrder.dart';
import 'Patient/chat2page.dart';
import 'Pharmacy/OrderScreen.dart';
import 'Pharmacy/editProduct.dart';
import 'Pharmacy/order_details.dart';
import 'api/firebase.dart';


void main() async {
  //async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi.addRandomUsers(UUsers.initUsers);
  //await FirebaseApp.configure();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserModel()),
      ChangeNotifierProvider<CartItem>(
        create: (context) => CartItem(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // all the textfiled in the app will take the same shape
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xfff2f9fe),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]),
            borderRadius: BorderRadius.circular(25),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      home: IntroScreen(),
      routes: {
        'DeliverySut': (context) => DeliverySut(),
        'intro': (context) => IntroScreen(),
        'home': (context) => HomeScreen(),
        'category': (context) => CategoryScreen(),
        'login': (context) => AuthScreen(authType: AuthType.login),
        'register': (context) => AuthScreen(authType: AuthType.register),
        'register2': (context) => AuthScreen(authType: AuthType.register2),
        'patient': (context) => PatientHomePage(),
        'pharmacy': (context) => PharmacyHomePage(),
        'delivery': (context) => DeliveryHomePage(),
        'AddProduct': (context) => PharmacyHomePage(),
        'ChatsPage': (context) => ChatsPage(),
        'ChatPage': (context) => ChatPage(),
        'DeliverySut': (context) => DeliverySut(),
        'DeliveryOrder': (context) => DeliveryOrder(),
        'patientSearch': (context) => PatientSearch(),
        seeOrdes.id: (context) => seeOrdes(),
        EditProduct.id: (context) => EditProduct(),
        ProductInfo.id: (context) => ProductInfo(),
        CartScreen.id: (context) => CartScreen(),
        OrdersScreen.id: (context) => OrdersScreen(),
        OrderDetails.id: (context) => OrderDetails(),
      },
    );
  }
}



class MainScreen extends StatelessWidget {
  bool getAccess;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        //builder: (context,AsyncSnapshot<User> snapshot) {
        builder: (context, snapshot) {
          // if(snapshot.connectionState == ConnectionState.waiting)
          if (snapshot.hasData && snapshot.data != null) {
            UserHelper.saveUser(snapshot.data);
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(snapshot.data.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                FirebaseFirestore.instance
                    .collection('users')
                    .where('email',
                    isEqualTo: FirebaseAuth.instance.currentUser.email)
                    .get()
                    .then((docs) {
                  if (docs.docs[0].exists) {
                    if (docs.docs[0].data()['role'] == 'patient') {
                      print(FirebaseAuth.instance.currentUser.email.toString());
                      return PatientHomePage();
                    } else if (docs.docs[0].data()['role'] == 'pharmacy') {
                      print(FirebaseAuth.instance.currentUser.email.toString());
                      print('khra ss ${docs.docs[0].data()['pharmacy_name']}');
                      return PharmacyHomePage(
                        pharmacyName: docs.docs[0].data()['pharmacy_name'],
                      );
                    } else if (docs.docs[0].data()['role'] == 'delivery') {
                      print(FirebaseAuth.instance.currentUser.email.toString());
                      return DeliveryHomePage(
                        pharmacyName: docs.docs[0].data()['pharmacy_name'],
                      );
                    } else {
                      return PatientHomePage();
                    }
                  }
                });

                return Material(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          }
          return AuthScreen();
        });
  }
}