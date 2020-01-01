import 'package:sqflite/sqflite.dart';

abstract class DBHandler {
  Future<Database> openDB({String databaseName});
  addUser(String userCode);
  changeUserAlias(String userCode, String newAlias);
  addMessage(String otherUserCode, String content, bool incoming);
  int getLocalUserIDOf(String userCode);
  String getUserCodeOf(int localUserID);
  changeBlockStatus(String userCode, bool isNowBlocked);
}