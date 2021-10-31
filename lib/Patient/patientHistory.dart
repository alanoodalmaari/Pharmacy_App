import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController wightInputController;
  TextEditingController heightInputController;
  TextEditingController curentDisInputController;
  TextEditingController preDisInputController;
  TextEditingController curentMidInputController;
  TextEditingController emailInputController;
  TextEditingController ageInputController;

  void getAge() async {
    String myID = FirebaseAuth.instance.currentUser.uid;
    var historyList =
        await FirebaseFirestore.instance.collection('History').doc(myID).get();
    if (historyList != null) {
      String currentAge = historyList.data()['age'].toString();
      ageInputController = TextEditingController(text: currentAge);
      setState(() {});
    }
  }

  //
  void getemail() async {
    String myID = FirebaseAuth.instance.currentUser.uid;
    var historyList =
        await FirebaseFirestore.instance.collection('History').doc(myID).get();
    if (historyList != null) {
      String currentemail = historyList.data()['email'].toString();
      emailInputController = TextEditingController(text: currentemail);
      setState(() {});
    }
  }

  void getpreviosDis() async {
    String myID = FirebaseAuth.instance.currentUser.uid;
    var historyList =
        await FirebaseFirestore.instance.collection('History').doc(myID).get();
    if (historyList != null) {
      String previousdis = historyList.data()['predis'].toString();
      preDisInputController = TextEditingController(text: previousdis);
      setState(() {});
    }
  }

  void getcurrentMid() async {
    String myID = FirebaseAuth.instance.currentUser.uid;
    var historyList =
        await FirebaseFirestore.instance.collection('History').doc(myID).get();
    if (historyList != null) {
      String currentMid = historyList.data()['cureent mis'].toString();
      curentMidInputController = TextEditingController(text: currentMid);
      setState(() {});
    }
  }

  void getcurentDis() async {
    String myID = FirebaseAuth.instance.currentUser.uid;
    var historyList =
        await FirebaseFirestore.instance.collection('History').doc(myID).get();

    if (historyList != null) {
      String currentDis = historyList.data()['curenntdis'].toString();
      curentDisInputController = TextEditingController(text: currentDis);
      setState(() {});
    }
  }

  void getheight() async {
    String myID = FirebaseAuth.instance.currentUser.uid;
    var historyList =
        await FirebaseFirestore.instance.collection('History').doc(myID).get();
    if (historyList != null) {
      String height = historyList.data()['height'].toString();
      heightInputController = TextEditingController(text: height);
      setState(() {});
    }
  }

  //
  void getweight() async {
    String myID = FirebaseAuth.instance.currentUser.uid;
    var historyList =
        await FirebaseFirestore.instance.collection('History').doc(myID).get();
    if (historyList != null) {
      String weight = historyList.data()['weigh'].toString();
      wightInputController = TextEditingController(text: weight);
      setState(() {});
    }
  }

  @override
  void initState() {
    // name = new TextEditingController();
    // licenseInputController = new TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAge();
      getemail();
      getpreviosDis();
      getcurentDis();
      getheight();
      getweight();
      getcurrentMid();
    });
    wightInputController = TextEditingController(text: "");
    heightInputController = TextEditingController(text: "");
    curentDisInputController = TextEditingController(text: "");
    preDisInputController = TextEditingController(text: "");
    curentMidInputController = TextEditingController(text: "");
    emailInputController = TextEditingController(text: "");
    ageInputController = TextEditingController(text: "");
    //phoneInputController = new TextEditingController();
    super.initState();
  }

  Widget textfield({@required hintText, TextEditingController controller}) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueGrey,
        title: Text('History'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,

          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 580,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textfield(
                        controller: emailInputController,
                        hintText: 'Email',
                      ),
                      textfield(
                        controller: ageInputController,
                        hintText: 'Age',
                      ),
                      // add
                      textfield(
                        controller: heightInputController,
                        hintText: 'Height',
                      ),
                      textfield(
                        controller: wightInputController,
                        hintText: 'Weight',
                      ),

                      textfield(
                        controller: curentDisInputController,
                        hintText: 'Current Disease',
                      ),
                      textfield(
                        controller: preDisInputController,
                        hintText: 'Previous Disease',
                      ),

                      Container(
                        height: 55,
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () async {
                            String myID = FirebaseAuth.instance.currentUser.uid;

                            Map<String, dynamic> data = {
                              "email": emailInputController.text,
                              "age": ageInputController.text,
                              "weigh": wightInputController.text,
                              "height": heightInputController.text,
                              "curenntdis": curentDisInputController.text,
                              "predis": preDisInputController.text,
                              "cureent mis": curentMidInputController.text
                            };

                            DocumentSnapshot history = await FirebaseFirestore
                                .instance
                                .collection("History")
                                .doc(myID)
                                .get();
                            if (history.data() != null) {
                              await FirebaseFirestore.instance
                                  .collection("History")
                                  .doc(myID)
                                  .update(data);
                            } else {
                              await FirebaseFirestore.instance
                                  .collection("History")
                                  .doc(myID)
                                  .set(data);
                            }


                            addhis(context);
                           },


                          color: Colors.blueGrey,
                          child: Center(
                            child: Text(
                              "Update",
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blueGrey;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 80, size.width, 130)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
void addhis(BuildContext context){
  var alertDialog = AlertDialog(
    title: Text("History updated successfully ",style: TextStyle(fontFamily:'italic')),
  elevation: 24,
  backgroundColor: Colors.blueGrey.shade100,

  );
  showDialog(context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
  );
}

