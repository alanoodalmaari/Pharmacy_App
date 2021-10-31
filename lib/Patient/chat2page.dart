import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/chuser.dart';
import 'package:pharmacy_app/models/conversation.dart';
import 'package:pharmacy_app/models/user.dart';
import 'package:pharmacy_app/widgets/ChPatrofile.dart';
import 'package:pharmacy_app/widgets/messages_wigest.dart';
import 'package:pharmacy_app/widgets/new_message.dart';

class ChatPage extends StatefulWidget {
  final UserPharma user;
  //final UserDeliver uuser;
  final String conversation;

  const ChatPage({
    @required this.user,
    // @required this.uuser,
    Key key,
    this.conversation,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference _convCtrl =
        FirebaseFirestore.instance.collection('conversations');
    print(widget.conversation);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue,
      body: SafeArea(
          child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('conversations')
            .doc('${widget.conversation}')
            .get()
            .then(
              (value) => Conversation.fromJson(
                {'id': value.id, ...value.data()},
              ),
            ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Conversation conv = snapshot.data;
            print(conv.pharmacist);

            return Column(
              children: [
                ProfileHeaderWidget(name: widget.user.email),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: MessagesWidget(
                      idUser: widget.user.id,
                      conv: conv,
                    ),
                  ),
                ),
                NewMessageWidget(
                  idUser: widget.user.id,
                  conversation: conv,
                ),
              ],
            );
          } else
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            );
        },
      )),
    );
  }
}
