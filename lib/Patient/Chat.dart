import 'package:flutter/material.dart';
import 'package:pharmacy_app/api/firebase.dart';
import 'package:pharmacy_app/models/chuser.dart';
import 'package:pharmacy_app/widgets/ChatHeader.dart';
import 'package:pharmacy_app/widgets/chatbody.dart';

class ChatsPage extends StatelessWidget {
  final String pharmacy;

  const ChatsPage({
    Key key,
    this.pharmacy,
  }) : super(key: key);
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
                          ChatHeaderWidget(
                            uusers: users,
                            phamarcyName: pharmacy,
                          ),
                          ChatBodyWidget(
                            uusers: users,
                            phamarcyName: pharmacy,
                          )
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
