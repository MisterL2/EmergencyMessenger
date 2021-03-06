class ConversationHeader {
  final int localUserID;
  final String name; //Either the entered name (if such an entry exists in the local storage) or "Anonymous"
  final String mostRecentMessage;
  final bool hasUnreadMessage; //A "mostRecentMessageReadUnixTime" is saved in the local storage. If the newest message is of that time, it has been read already. Otherwise, hasUnreadMessage = true
  final bool isOwnMessage;

  ConversationHeader(this.localUserID, this.name, this.mostRecentMessage, this.hasUnreadMessage, this.isOwnMessage);
}