import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_app/models/chuser.dart';
import 'package:pharmacy_app/models/data.dart';
import 'package:pharmacy_app/models/message.dart';
import 'package:pharmacy_app/services/utils.dart';

class FirebaseApi {
  static Stream<List<UUser>> getUUsers() => FirebaseFirestore.instance
      .collection('uusers')
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(UUser.fromJson));

  static Future uploadMessage(String idUser, String message) async {
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$idUser/messages');
    DatabaseService _pharmaService =
        DatabaseService(path: 'users/${FirebaseAuth.instance.currentUser.uid}');

    DocumentReference _pharmacist = _pharmaService.createRef();
    final newMessage = Message(
      idUser: FirebaseAuth.instance.currentUser.uid,
      //urlAvatar: myUrlAvatar,
      username: myUsername,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('user');
    await refUsers
        .doc(idUser)
        .update({UserField.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Message>> getMessages(String conversationID) =>
      FirebaseFirestore.instance
          .collection('conversations/$conversationID/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(
            Utils.transformer(
              Message.fromJson,
            ),
          );

  static Future addRandomUsers(List<UUser> uusers) async {
    final refUsers = FirebaseFirestore.instance.collection('uusers');

    final allUsers = await refUsers.get();
    if (allUsers.size != 0) {
      return;
    } else {
      for (final user in uusers) {
        final userDoc = refUsers.doc();
        final newUser = user.copyWith(idUser: userDoc.id);

        await userDoc.set(newUser.toJson());
      }
    }
  }

  static Future sendMessages(String conversationID, String message) async {
    final refMessages = FirebaseFirestore.instance
        .collection('conversations/${conversationID}/messages');

    DatabaseService _pharmaService =
        DatabaseService(path: 'users/${FirebaseAuth.instance.currentUser.uid}');

    DocumentReference _pharmacist = _pharmaService.createRef();

    final newMessage = Message(
      idUser: FirebaseAuth.instance.currentUser.uid,
     // urlAvatar: myUrlAvatar,
      username: FirebaseAuth.instance.currentUser.email,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(
      newMessage.toJson(),
    );

    final refUsers = FirebaseFirestore.instance.collection('conversations');
    await refUsers.doc(conversationID).update(
      {
        'lastMessage': message,
        'lastMessageTime': DateTime.now(),
      },
    );
  }
}
