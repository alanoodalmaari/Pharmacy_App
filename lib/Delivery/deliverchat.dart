import 'package:flutter/material.dart';
import 'package:pharmacy_app/api/firebase.dart';
import 'package:pharmacy_app/models/chuser.dart';
import 'Deliverchatbody.dart';
import 'deliverchatheader.dart';

class DeliverChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.blue,
    body: SafeArea(
      child: StreamBuilder<List<UUser>>(
        stream: FirebaseApi.getUUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print(snapshot.error);
                return buildText('Something Went Wrong Try later');
              } else {
                final users = snapshot.data;

                if (users.isEmpty) {
                  return buildText('No Users Found');
                } else
                  return Column(
                    children: [
                      DeliverChatHeader(uusers: users),
                      DeliveryChatBody(uusers: users)
                    ],
                  );
              }
          }
        },
      ),
    ),
  );

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 24, color: Colors.white),
    ),
  );
}