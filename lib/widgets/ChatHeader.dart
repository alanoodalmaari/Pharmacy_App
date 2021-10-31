import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/Patient/chat2page.dart';
import 'package:pharmacy_app/models/chuser.dart';
import 'package:pharmacy_app/models/conversation.dart';
import 'package:pharmacy_app/models/user.dart';
import 'package:pharmacy_app/services/utils.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List<UUser> uusers;
  final String phamarcyName;

  const ChatHeaderWidget({
    @required this.uusers,
    Key key,
    this.phamarcyName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      itemCount: pharmacies.length + 1,
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
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () async {
                                DatabaseService _pharmaService = DatabaseService(
                                    path: 'users/${pharmacies[index - 1].id}');

                                DocumentReference _pharmacist =
                                    _pharmaService.createRef();

                                DatabaseService _clientService = DatabaseService(
                                    path:
                                        'users/${FirebaseAuth.instance.currentUser.uid}');

                                DocumentReference _client =
                                    _clientService.createRef();

                                print(_client);
                                print(_pharmacist);

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
                                      user: pharmacies[index - 1],
                                      conversation: addedConv.id,
                                    ),
                                  ));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      user: pharmacies[index - 1],
                                      conversation: existconv.docs[0].id,
                                    ),
                                  ));
                                }
                              },
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    pharmacies[index - 1].role == 'delivery'
                                        ? Colors.red
                                        : Colors.blueAccent,
                                // backgroundImage: NetworkImage(user.urlAvatar),
                              ),
                            ),
                          );
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
