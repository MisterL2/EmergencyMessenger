import 'package:emergency_messenger_client/dataclasses/ConversationHeader.dart';
import 'package:emergency_messenger_client/dataclasses/Message.dart';
import 'package:sqflite/sqflite.dart';

abstract class DBHandler {
  Future<Database> openDB({String databaseName});
  Future<void> addUser(String userCode);
  Future<void> changeUserAlias(int localUserID, String newAlias, bool isBlocked); //Technically it can be done without isBlocked, but then it requires an additional sql query, due to how the update command works
  Future<void> addMessage(String otherUserCode, String content, int unixTime, bool incoming);
  Future<int> getLocalUserIDOf(String userCode);
  Future<String> getUserCodeOf(int localUserID);
  Future<void> changeBlockStatus(int localUserID, String localAlias, bool isNowBlocked); //Technically it can be done without localAlias, but then it requires an additional sql query, due to how the update command works
  Future<List<ConversationHeader>> getConversationHeaders();
  Future<List<Message>> fetchMessages(int localUserID, int amountOfMessages);
  Future<void> deleteDB({String databaseName});
}