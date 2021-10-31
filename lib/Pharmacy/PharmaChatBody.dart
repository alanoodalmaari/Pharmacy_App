import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/Patient/chat2page.dart';
import 'package:pharmacy_app/models/chuser.dart';
import 'package:pharmacy_app/models/conversation.dart';
import 'package:pharmacy_app/models/user.dart';
import 'package:pharmacy_app/services/utils.dart';

class PharmaChatBody extends StatelessWidget {
  final List<UUser> uusers;
  final Conversation conv;

  const PharmaChatBody({
    @required this.uusers,
    Key key,
    this.conv,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() {
    // uusers.forEach((element) {
    //   if(element.idUser == )
    // })

    CollectionReference _convCtrl =
        FirebaseFirestore.instance.collection('conversations');

    DatabaseService _pharmaService =
        DatabaseService(path: 'users/${FirebaseAuth.instance.currentUser.uid}');

    DocumentReference _pharmacist = _pharmaService.createRef();

    print(_pharmacist);
    return StreamBuilder(
        stream: _convCtrl
            .where('pharmacist', isEqualTo: _pharmacist)
            .snapshots()
            .map((event) {
          List<Conversation> convs = event.docs
              .map((e) => Conversation.fromJson({'id': e.id, ...e.data()}))
              .toList();

          return convs;
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Conversation> conversations = snapshot.data;

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final user = uusers[index];

                return FutureBuilder(
                    future: conversations[index].client.get().then(
                          (value) => UserPharma.fromJson(
                            {'id': value.id, ...value.data()},
                          ),
                        ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserPharma user = snapshot.data;
                        return Container(
                          height: 75,
                          child: ListTile(
                            onTap: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  // user: uusers[index],
                                  user: user,
                                  conversation: conversations[index].id,
                                ),
                              ));
                            },
                            leading: CircleAvatar(
                              radius: 25,
                              // backgroundImage: NetworkImage(user.urlAvatar),
                            ),
                            title: Text(user.email),
                          ),
                        );
                      } else
                        return Container();
                    });
              },
              itemCount: conversations.length,
            );
          } else
            return CircularProgressIndicator();
        });
  }
}
