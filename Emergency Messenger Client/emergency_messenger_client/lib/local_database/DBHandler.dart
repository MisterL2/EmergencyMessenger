import 'package:emergency_messenger_client/dataclasses/ConversationHeader.dart';
import 'package:emergency_messenger_client/dataclasses/Message.dart';
import 'package:emergency_messenger_client/dataclasses/User.dart';
import 'package:emergency_messenger_client/local_database/SQLiteHandler.dart';
import 'package:sqflite/sqflite.dart';

abstract class DBHandler {
  static DBHandler _instance;
  static DBHandler getDBHandler() {
    if(_instance==null) {
      _instance = SQLiteHandler(); //This is the ONLY LINE that needs to be changed when changing database solutions
    }
    return _instance;
  }

  Future<Database> openDB({String databaseName});
  Future<void> addUser(String userCode);
  Future<User> getUser(int localUserID);
  Future<void> changeUserAlias(int localUserID, String newAlias, bool isBlocked); //Technically it can be done without isBlocked, but then it requires an additional sql query, due to how the update command works
  Future<void> addMessage(String otherUserCode, String content, int unixTime, bool incoming);
  Future<int> getLocalUserIDOf(String userCode);
  Future<String> getUserCodeOf(int localUserID);
  Future<void> changeBlockStatus(int localUserID, String localAlias, bool isNowBlocked); //Technically it can be done without localAlias, but then it requires an additional sql query, due to how the update command works
  Future<List<ConversationHeader>> getConversationHeaders();
  Future<List<Message>> fetchMessages(int localUserID, int amountOfMessages);
  Future<void> deleteDB({String databaseName});
}