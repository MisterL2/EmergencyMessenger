import 'package:emergency_messenger_client/local_database/CustomDatabaseException.dart';
import 'package:emergency_messenger_client/local_database/DBHandler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class SQLiteHandler extends DBHandler {
  static Future<Database> _database;

  SQLiteHandler() {
    if(_database==null) {
      openDB();
    }
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

  @override
  Future<String> getUserCodeOf(int localUserID) async {
    Database db = await _database;
    List<Map<String,String>> result = await db.query("userCodes", where: "localUserID = ?", whereArgs: [localUserID]);
    if(result.length==0) {
      throw CustomDatabaseException("The localUserID '$localUserID' does not exist!");
    } else if(result.length!=1) {
      throw CustomDatabaseException("There are multiple entries for the localUserID '$localUserID'!");
    } else {
      return result[0]["userCode"];
    }
  }

  @override
  Future<int> getLocalUserIDOf(String userCode) async {
    Database db = await _database;
    List<Map<String,int>> result = await db.query("userCodes", where: "userCode = ?", whereArgs: [userCode]);
    if(result.length==0) {
      throw CustomDatabaseException("There is no localUserID entry for this userCode!");
    } else if(result.length!=1) {
      throw CustomDatabaseException("There are multiple localUserID entries for this userCode!");
    } else {
      return result[0]["localUserID"];
    }
  }

  @override
  Future<void> addMessage(String otherUserCode, String content, bool incoming) async {
    // TODO: implement addMessage
    return null;
  }

  @override
  Future<void> addUser(String userCode) async {
    // TODO: implement addUser
    return null;
  }

  @override
  Future<void> changeBlockStatus(String userCode, bool isNowBlocked) async {
    // TODO: implement changeBlockStatus
    return null;
  }

  @override
  Future<void> changeUserAlias(String userCode, String newAlias) async {
    // TODO: implement changeUserAlias
    return null;
  }



}