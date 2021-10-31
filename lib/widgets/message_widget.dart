import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/message.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageWidget({
    @required this.message,
    @required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          CircleAvatar(
              radius: 16, ),
        !message.message.contains(new RegExp(r'/images', caseSensitive: false))
            ? Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),
                constraints: BoxConstraints(maxWidth: 140),
                decoration: BoxDecoration(
                  color:
                      isMe ? Colors.grey[100] : Theme.of(context).accentColor,
                  borderRadius: isMe
                      ? borderRadius.subtract(
                          BorderRadius.only(bottomRight: radius),
                        )
                      : borderRadius.subtract(
                          BorderRadius.only(bottomLeft: radius),
                        ),
                ),
                child: buildMessage(),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullImage(imageUrl: message.message),
                    ),
                  );
                },
                child: Container(
                  height: 150,
                  width: 170,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(16),
                  constraints: BoxConstraints(maxWidth: 140),
                  decoration: BoxDecoration(
                      color: isMe
                          ? Colors.grey[100]
                          : Theme.of(context).accentColor,
                      borderRadius: isMe
                          ? borderRadius.subtract(
                              BorderRadius.only(bottomRight: radius),
                            )
                          : borderRadius.subtract(
                              BorderRadius.only(bottomLeft: radius),
                            ),
                      image: DecorationImage(
                        image: NetworkImage(message.message),
                        fit: BoxFit.fill,
                      )),
                  // child: buildMessage(),
                ),
              ),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ],
      );
}

class FullImage extends StatelessWidget {
  final String imageUrl;

  const FullImage({Key key, this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Center(
              child: Image.network(
                imageUrl,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.close,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
