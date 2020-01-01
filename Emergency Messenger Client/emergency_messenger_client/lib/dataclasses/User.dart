import 'package:emergency_messenger_client/dataclasses/Mappable.dart';

class User implements Mappable { //Any other user that the app-owner may be communicating with
  //All fields are final because this is a dataclass. To change the fields, change the value in the database and retrieve a new User object
  final String localAlias; //The locally saved alias of this user
  final String userCode;
  final bool isBlocked;

  User(this.localAlias, this.userCode, this.isBlocked);

  @override
  Map<String, Object> toMap() {
    return {
      "localAlias" : localAlias,
      "userCode" : userCode,
      "isBlocked" : isBlocked,
    };
  }

}