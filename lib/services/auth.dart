import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info/package_info.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
// like here
class UserData {

  final String uid;

  //user id
  // for registration part if i want to add more must write
  // final string phone and so on

  UserData({@required this.uid,});
}
final FirebaseAuth _auth = FirebaseAuth.instance;

//user object based on firebase

// resopnsable about authntcation register , login and logout
class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(User user,{ String role: 'user'}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);



    Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      "phonenumber": user.phoneNumber,
      "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime.millisecondsSinceEpoch,
      "role": role,
      "build_number": buildNumber,
      "pharmacy_name": user.displayName,
    };
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
        "build_number": buildNumber,
      });
    } else {
      await _db.collection("users").doc(user.uid).set(userData);
    }
  }
}
// here you go, FirebaseUser is deprectaed it shoul be User now like here, so i renamed custom User to UserData



class AuthBase {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  UserData _userFromFirebase(User user) {
    return user != null ? UserData(uid: user.uid) : null;

  }
  Future<User> getUser() async {
    return await _auth.currentUser;
  }
  Future<void> registerWithEmailAndPassword(
      String email, String password,String name, String phone) async {
    try {
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await UserHelper.saveUser(authResult.user);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future register2WithEmailAndPassword(
      String email, String password,String pharmacy_name, String phone, String license, {String role:'user'}) async {
    try {
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await UserHelper.saveUser(authResult.user, role: role);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  static loginWithEmailAndPassword( {String email, String password}) async {
    try {
      final res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = res.user;
      return user;
      // await means wait for data
      //final authResult = await FirebaseAuth.instance
      // .signInWithEmailAndPassword(email: email, password: password);
      // return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
Future<void> category() async {
}
Future<void> pharmacy() async {
}


//Future<void> HistoryPage() async {
//}

