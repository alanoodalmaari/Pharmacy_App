import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/message.dart';
import 'package:pharmacy_app/services/utils.dart';

class Conversation {
  String id;
  DocumentReference client;
  DocumentReference pharmacist;
  // DocumentReference deliveryBoy;
  String lastMessage;
  List<Message> messages;
  DateTime createdAt;
  DateTime lastMessageTime;
  String type;

  Conversation({
    @required this.id,
    @required this.client,
    @required this.pharmacist,
    @required this.lastMessage,
    // @required this.deliveryBoy,
    @required this.createdAt,
    @required this.messages,
    @required this.lastMessageTime,
    @required this.type,
  });

  static Conversation fromJson(Map<String, dynamic> json) => Conversation(
    id: json['id'],
    pharmacist: json['pharmacist'],
    // deliveryBoy: json['deliveryBoy'],
    client: json['client'],
    lastMessage: json['lastMessage'],
    createdAt: Utils.toDateTime(json['createdAt']),
    lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
    messages: List<Message>.from(
      json["messages"].map((x) => Message.fromJson(x)),
    ),
    type: json['type'],
  );

  Map<String, dynamic> toJson() => {
    'client': client,
    // 'deliveryBoy': deliveryBoy,
    'lastMessage': lastMessage,
    'pharmacist': pharmacist,
    'createdAt': Utils.fromDateTimeToJson(createdAt),
    'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
    'messages': messages,
    'type': type,
  };
}
