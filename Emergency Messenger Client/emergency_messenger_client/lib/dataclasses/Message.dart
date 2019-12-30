class Message {
  final String content;
  final int unixTimestamp;
  final bool isOwnMessage; //If the message is originating from the user currently seeing it (i.e. outgoing message)

  Message(this.content, this.unixTimestamp, this.isOwnMessage);
}