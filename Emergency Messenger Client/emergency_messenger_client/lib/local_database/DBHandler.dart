import 'package:sqflite/sqflite.dart';

abstract class DBHandler {
  Future<Database> openDB({String databaseName});
  Future<void> addUser(String userCode);
  Future<void> changeUserAlias(String userCode, String newAlias, bool isBlocked); //Technically it can be done without isBlocked, but then it requires an additional sql query, due to how the update command works
  Future<void> addMessage(String otherUserCode, String content, bool incoming);
  Future<int> getLocalUserIDOf(String userCode);
  Future<String> getUserCodeOf(int localUserID);
  Future<void> changeBlockStatus(String userCode, String localAlias, bool isNowBlocked); //Technically it can be done without localAlias, but then it requires an additional sql query, due to how the update command works
}