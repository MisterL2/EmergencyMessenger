import 'package:emergency_messenger_client/dataclasses/Mappable.dart';

class Message implements Mappable {
  final String content;
  final int unixTimestamp;
  final bool isOwnMessage; //If the message is originating from the user currently seeing it (i.e. outgoing message)
  final bool hasBeenRead;

  Message(this.content, this.unixTimestamp, this.isOwnMessage, this.hasBeenRead);

  @override
  Map<String, Object> toMap() {
    return {
      "content" : content,
      "unixTimestamp" : unixTimestamp,
      "isOwnMessage" : isOwnMessage,
      "hasBeenRead" : hasBeenRead,
    };
  }
}