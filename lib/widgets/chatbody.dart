import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/Patient/chat2page.dart';
import 'package:pharmacy_app/models/chuser.dart';
import 'package:pharmacy_app/models/conversation.dart';
import 'package:pharmacy_app/models/user.dart';
import 'package:pharmacy_app/services/utils.dart';

class ChatBodyWidget extends StatelessWidget {
  final List<UUser> uusers;
  final String phamarcyName;
  final String type;

  const ChatBodyWidget({
    @required this.uusers,
    Key key,
    this.phamarcyName,
    this.type,
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
    CollectionReference _convCtrl =
        FirebaseFirestore.instance.collection('conversations');

    CollectionReference _userCtrl =
        FirebaseFirestore.instance.collection('users');

    print('namepharma');
    print(phamarcyName);

    return FutureBuilder(
        future: _userCtrl
            .where('pharmacy_name', isEqualTo: '${phamarcyName}')
            .get()
            .then((value) {
          return value.docs
              .map((e) => UserPharma.fromJson({'id': e.id, ...e.data()}))
              .toList();
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);

            List<UserPharma> pharmacies = snapshot.data;
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  height: 75,
                  child: ListTile(
                    onTap: () async {
                      DatabaseService _pharmaService = DatabaseService(
                          path: 'users/${pharmacies[index].id}');

                      DocumentReference _pharmacist =
                          _pharmaService.createRef();

                      DatabaseService _clientService = DatabaseService(
                          path:
                              'users/${FirebaseAuth.instance.currentUser.uid}');

                      DocumentReference _client = _clientService.createRef();

                      var existconv = await _convCtrl
                          .where('pharmacist', isEqualTo: _pharmacist)
                          .where('client', isEqualTo: _client)
                          .get();

                      print(existconv.docs.length);
                      print(existconv.docs);

                      if (existconv.docs.length == 0) {
                        Conversation newConv = Conversation(
                          client: _client,
                          pharmacist: _pharmacist,
                          lastMessage: '',
                          createdAt: DateTime.now(),
                          lastMessageTime: DateTime.now(),
                          messages: [],
                        );

                        var addedConv = await _convCtrl.add(
                          newConv.toJson(),
                        );

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatPage(
                            user: pharmacies[index],
                            conversation: addedConv.id,
                          ),
                        ));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatPage(
                            user: pharmacies[index],
                            conversation: existconv.docs[0].id,
                          ),
                        ));
                      }
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => ChatPage(user: user),
                      // ));
                    },
                    leading: CircleAvatar(
                      radius: 25,
                      // backgroundImage: NetworkImage(user.urlAvatar),
                      backgroundColor: pharmacies[index].role == 'delivery'
                          ? Colors.red
                          : Colors.blue,
                    ),
                    title: Text(pharmacies[index].email),
                    trailing: Icon(
                      pharmacies[index].role == 'delivery'
                          ? Icons.delivery_dining
                          : Icons.business,
                      color: pharmacies[index].role == 'delivery'
                          ? Colors.red
                          : Colors.blue,
                      size: 30,
                    ),
                  ),
                );
              },
              itemCount: pharmacies.length,
            );
          } else
            return CircularProgressIndicator();
        });
  }
}
