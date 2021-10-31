import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_app/api/firebase.dart';
import 'package:pharmacy_app/models/conversation.dart';

class NewMessageWidget extends StatefulWidget {
  final String idUser;
  final Conversation conversation;

  const NewMessageWidget({
    @required this.idUser,
    Key key,
    this.conversation,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';

  void sendMessage() async {
    FocusScope.of(context).unfocus();

    await FirebaseApi.uploadMessage(widget.idUser, message);

    _controller.clear();
  }

  void sendNewMessage() async {
    FocusScope.of(context).unfocus();

    await FirebaseApi.sendMessages(widget.conversation.id, message);

    _controller.clear();
  }

  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    PickedFile selected =
        await ImagePicker().getImage(source: source, imageQuality: 70);

    setState(() {
      if (selected != null) {
        _imageFile = File(selected.path);
      } else {
        print('No image selected.');
      }
    });
  }

  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'gs://pharmacyapp-90709.appspot.com');

  UploadTask _uploadTask;

  Future<String> _startUpload() async {
    String filePath = 'images/${DateTime.now()}.png';
    _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);

    final snapshot = (await _uploadTask);
    String url = await snapshot.ref.getDownloadURL(); // await
    return url;
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: 'Type your message',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value) => setState(() {
                  message = value;
                }),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: message.trim().isEmpty ? null : sendNewMessage,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () async {
                await _pickImage(ImageSource.gallery);
                message = await _startUpload();
                setState(() {});
                sendNewMessage();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Icon(Icons.photo, color: Colors.white),
              ),
            ),
          ],
        ),
      );
}
