import 'package:emergency_messenger_client/local_database/DBHandler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class SQLiteHandler extends DBHandler {
  @override
  addMessage(String otherUserCode, String content, bool incoming) {
    // TODO: implement addMessage
    return null;
  }

  @override
  addUser(String userCode) {
    // TODO: implement addUser
    return null;
  }

  @override
  changeBlockStatus(String userCode, bool isNowBlocked) {
    // TODO: implement changeBlockStatus
    return null;
  }

  @override
  changeUserAlias(String userCode, String newAlias) {
    // TODO: implement changeUserAlias
    return null;
  }

  @override
  int getLocalUserIDOf(String userCode) {
    // TODO: implement getLocalUserIDOf
    return null;
  }

  @override
  String getUserCodeOf(int localUserID) {
    // TODO: implement getUserCodeOf
    return null;
  }

  @override
  Future<Database> openDB({String databaseName}) async {
    return openDatabase(
        join(await getDatabasesPath(), 'local_database.db'),
        onCreate: (db, version) {
          db.execute(
            "CREATE TABLE userCodes ("
            "localUserID INTEGER PRIMARY KEY," //This apparently autoincrements by default?
            "userCode TEXT UNIQUE NOT NULL CHECK(LENGTH(userCode)=100)"
            ");"
          );
          db.execute(
            "CREATE TABLE users ("
            "localUserID INTEGER UNIQUE NOT NULL,"
            "localAlias TEXT DEFAULT 'ANONYMOUS'," //Can be duplicated, i.e. for "Anonymous" default
            "isBlocked INTEGER DEFAULT 0 CHECK(isBlocked=0 or isBlocked=1),"  //SQLite does not have a boolean type, so I am imitating it here.
            "FOREIGN KEY (localUserID) REFERENCES userCodes(localUserID)"
            ");"
          );
          db.execute(
            "CREATE TABLE incomingMessages ("
            "senderLocalUserID PRIMARY KEY,"
            "content TEXT NOT NULL,"
            "FOREIGN KEY (senderLocalUserID) REFERENCES userCodes(localUserID)"
            ");"
          );
          db.execute(
            "CREATE TABLE outgoingMessages ("
            "targetLocalUserID PRIMARY KEY,"
            "content TEXT NOT NULL,"
            "FOREIGN KEY (targetLocalUserID) REFERENES userCodes(targetLocalUserID)"
            ");"
          );

          //SHARED_PREFERENCES library cannot guarantee data persists (LOL) so using an SQLite table to cache the local userID
          db.execute(
            "CREATE TABLE preferences ("
            "ownUserID TEXT PRIMARY KEY CHECK(LENGTH(ownUserID)=2000)"
            ");"
          );
      },
      version: 1,
    );
  }

}