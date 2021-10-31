import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/Patient/chat2page.dart';
import 'package:pharmacy_app/models/chuser.dart';
import 'package:pharmacy_app/models/conversation.dart';
import 'package:pharmacy_app/models/user.dart';
import 'package:pharmacy_app/services/utils.dart';

class DeliverChatHeader extends StatelessWidget {
  final List<UUser> uusers;
  final String deliveyName;

  const DeliverChatHeader({
    @required this.uusers,
    Key key,
    this.deliveyName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference _convCtrl =
        FirebaseFirestore.instance.collection('conversations');

    CollectionReference _userCtrl =
        FirebaseFirestore.instance.collection('users');

    print('namedeliver');
    print(deliveyName);

    DatabaseService _deliverService =
        DatabaseService(path: 'users/${FirebaseAuth.instance.currentUser.uid}');

    DocumentReference _deliveryBoy = _deliverService.createRef();

    return StreamBuilder(
        stream: _convCtrl
            .where('pharmacist', isEqualTo: _deliveryBoy)
            .snapshots()
            .map((event) {
          List<Conversation> convs = event.docs
              .map((e) => Conversation.fromJson({'id': e.id, ...e.data()}))
              .toList();

          return convs;
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);

            List<Conversation> conversations = snapshot.data;

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      'Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: conversations.length + 1,
                      itemBuilder: (context, index) {
                        final user = uusers[index];
                        if (index == 0) {
                          return Container(
                            margin: EdgeInsets.only(right: 12),
                            child: CircleAvatar(
                              radius: 24,
                              child: Icon(Icons.search),
                            ),
                          );
                        } else {
                          return FutureBuilder(
                              future:
                                  conversations[index - 1].client.get().then(
                                        (value) => UserPharma.fromJson(
                                          {'id': value.id, ...value.data()},
                                        ),
                                      ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  UserPharma user = snapshot.data;
                                  return Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    child: GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            user: user,
                                            conversation:
                                                conversations[index - 1].id,
                                          ),
                                        ));
                                      },
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            // backgroundImage: NetworkImage(user.urlAvatar),
                                          ),
                                          Text('${user.email}')
                                        ],
                                      ),
                                    ),
                                  );
                                } else
                                  return Container();
                              });
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          } else
            return CircularProgressIndicator();
        });
  }
}
