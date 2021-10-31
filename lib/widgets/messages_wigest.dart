import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/api/firebase.dart';
import 'package:pharmacy_app/models/conversation.dart';
import 'package:pharmacy_app/models/data.dart';
import 'package:pharmacy_app/models/message.dart';

import 'message_widget.dart';

class MessagesWidget extends StatefulWidget {
  final Conversation conv;
  final String idUser;

  const MessagesWidget({
    @required this.idUser,
    Key key,
    this.conv,
  }) : super(key: key);

  @override
  _MessagesWidgetState createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget.conv.id);
    return StreamBuilder<List<Message>>(
      stream: FirebaseApi.getMessages(
        widget.conv.id,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return buildText('Something Went Wrong Try later');
            } else {
              final messages = snapshot.data;

              print('mesmessages');
              print(snapshot.data);

              return messages.isEmpty
                  ? buildText('Say Hi..')
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        return MessageWidget(
                          message: message,
                          isMe: message.idUser ==
                              FirebaseAuth.instance.currentUser.uid,
                        );
                      },
                    );
            }
        }
      },
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
