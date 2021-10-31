import 'package:meta/meta.dart';
import 'package:pharmacy_app/services/utils.dart';


class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class UUser {
  final String idUser;
  final String name;
  //final String urlAvatar;
  final DateTime lastMessageTime;

  const UUser({
    this.idUser,
    @required this.name,
   // @required this.urlAvatar,
    @required this.lastMessageTime,
  });

  UUser copyWith({
    String idUser,
    String name,
    String urlAvatar,
    String lastMessageTime,
  }) =>
      UUser(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
       // urlAvatar: urlAvatar ?? this.urlAvatar,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static UUser fromJson(Map<String, dynamic> json) => UUser(
    idUser: json['idUser'],
    name: json['name'],
    //urlAvatar: json['urlAvatar'],
    lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
  );

  Map<String, dynamic> toJson() => {
    'idUser': idUser,
    'name': name,
    //'urlAvatar': urlAvatar,
    'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
  };
}
