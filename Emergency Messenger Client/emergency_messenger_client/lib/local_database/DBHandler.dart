import 'package:sqflite/sqflite.dart';

abstract class DBHandler {
  Future<Database> openDB({String databaseName});
  Future<void> addUser(String userCode);
  Future<void> changeUserAlias(String userCode, String newAlias);
  Future<void> addMessage(String otherUserCode, String content, bool incoming);
  Future<int> getLocalUserIDOf(String userCode);
  Future<String> getUserCodeOf(int localUserID);
  Future<void> changeBlockStatus(String userCode, bool isNowBlocked);
}