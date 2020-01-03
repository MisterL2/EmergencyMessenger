import 'package:emergency_messenger_client/dataclasses/ConversationHeader.dart';
import 'package:emergency_messenger_client/local_database/CustomDatabaseException.dart';
import 'package:emergency_messenger_client/local_database/DBHandler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class SQLiteHandler extends DBHandler {
  static Future<Database> _database;

  static bool databaseExists() {
    return _database != null;
  }

  SQLiteHandler() {
    if(!databaseExists()) {
      openDB().then((val) => print("hi"));
    }
  }

  @override
  Future<void> openDB({String databaseName}) async {
    print("Creating a new database!");
    _database = openDatabase(
        join(await getDatabasesPath(), 'local_database.db'),
        onCreate: (db, version) {
          print("Creating DB tables!");
          db.execute(
            "CREATE TABLE userCodes ("
            "localUserID INTEGER PRIMARY KEY,"
            "userCode TEXT UNIQUE NOT NULL CHECK(LENGTH(userCode)=100)"
            ");"
          );
          db.execute(
            "CREATE TABLE users ("
            "localUserID INTEGER UNIQUE NOT NULL,"
            "localAlias TEXT DEFAULT 'Anonymous'," //Can be duplicated, i.e. for "Anonymous" default

            //isBlocked does not do any "blocking" client-side, it only affects the UI (Whether the option is to BLOCK or UNBLOCK) and which requests are sent out to the server as a result.
            //User blocking is managed server-side.
            "isBlocked INTEGER DEFAULT 0 CHECK(isBlocked=0 or isBlocked=1),"  //SQLite does not have a boolean type, so I am imitating it here.
            "FOREIGN KEY (localUserID) REFERENCES userCodes(localUserID)"
            ");"
          );
          db.execute(
            "CREATE TABLE incomingMessages ("
            "senderLocalUserID PRIMARY KEY,"
            "content TEXT NOT NULL,"
            "unixTime INTEGER NOT NULL CHECK(unixTime > 1577979238),"
            "hasBeenRead INTEGER DEFAULT 0 CHECK(hasBeenRead=0 or hasBeenRead=1),"
            "FOREIGN KEY (senderLocalUserID) REFERENCES userCodes(localUserID)"
            ");"
          );
          db.execute(
            "CREATE TABLE outgoingMessages ("
            "targetLocalUserID PRIMARY KEY,"
            "content TEXT NOT NULL,"
            "unixTime INTEGER NOT NULL CHECK(unixTime > 1577979238),"
            "hasBeenRead INTEGER DEFAULT 0 CHECK(hasBeenRead=0 or hasBeenRead=1),"
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
    print("Hey!");
    print(_database);
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
      int userID = result[0]["localUserID"];
      if(userID<=0) { //Is this edge case possible?
        throw CustomDatabaseException("A negative userID ($userID) was returned!");
      }
      return userID;
    }
  }

  @override
  Future<void> addMessage(String otherUserCode, String content, int unixTime, bool incoming) async {
    Database db = await _database;
    String table = incoming ? "incomingMessages" : "outgoingMessages";
    String fieldName = incoming ? "senderLocalUserID" : "targetLocalUserID";
    int localUserID = await getLocalUserIDOf(otherUserCode);
    Map<String, dynamic> message = {
      fieldName : localUserID,
      "content" : content,
      "unixTime" : unixTime,
      "hasBeenRead" : 0,
    };

    int rowsAffectedOrErrorCode = await db.insert(table, message);
    if(rowsAffectedOrErrorCode!=1) {
      throw CustomDatabaseException("Something went wrong with inserting, not sure what. Returncode of insert was '$rowsAffectedOrErrorCode'.");
    }
  }

  @override
  Future<void> addUser(String userCode) async {
    Database db = await _database;
    int rowCount = Sqflite.firstIntValue(await db.rawQuery("SELECT count(*) FROM userCodes;"));
    int localUserID = rowCount + 1;
    Map<String, dynamic> userCodesInsert = {
      "localUserID" : localUserID,
      "userCode" : userCode,
    };
    int rowsAffectedOrErrorCode = await db.insert("userCodes", userCodesInsert);
    if(rowsAffectedOrErrorCode!=1) {
      throw CustomDatabaseException("Something went wrong with inserting into userCodes, not sure what. Returncode of insert was '$rowsAffectedOrErrorCode'.");
    }

    Map<String, dynamic> userTableInsert = {
      "localUserID" : localUserID,
      "localAlias" : "Anonymous", //Used as default
      "isBlocked" : 0, //"False"
    };

    rowsAffectedOrErrorCode = await db.insert("users", userTableInsert);
    if(rowsAffectedOrErrorCode!=1) {
      throw CustomDatabaseException("Something went wrong with inserting into users, not sure what. Returncode of insert was '$rowsAffectedOrErrorCode'.");
    }

  }

  @override
  Future<void> changeBlockStatus(int localUserID, String localAlias, bool isNowBlocked) async {
    //Technically localAlias is not required for the logic, but the update-command replaces an entire row, not just a field. I would have to query the localAlias first if it wasn't supplied.
    Database db = await _database;

    Map<String, dynamic> rowToBeInserted = {
      "localUserID" : localUserID,
      "localAlias" : localAlias,
      "isBlocked" : isNowBlocked,
    };
    int rowsAffectedOrErrorCode = await db.update("users", rowToBeInserted, where: "localUserID = ?", whereArgs: [localUserID]);
    if(rowsAffectedOrErrorCode!=1) {
      throw CustomDatabaseException("Something went wrong with inserting, not sure what. Returncode of insert was '$rowsAffectedOrErrorCode'.");
    }
  }

  @override
  Future<void> changeUserAlias(int localUserID, String newAlias, bool isBlocked) async {
    //Technically isBlocked is not required for the logic, but the update-command replaces an entire row, not just a field. I would have to query the isBlocked-boolean first if it wasn't supplied.
    Database db = await _database;

    Map<String, dynamic> rowToBeInserted = {
      "localUserID" : localUserID,
      "localAlias" : newAlias,
      "isBlocked" : isBlocked,
    };


    int rowsAffectedOrErrorCode = await db.update("users", rowToBeInserted, where: "localUserID = ?", whereArgs: [localUserID]);
    if(rowsAffectedOrErrorCode!=1) {
      throw CustomDatabaseException("Something went wrong with inserting, not sure what. Returncode of insert was '$rowsAffectedOrErrorCode'.");
    }
  }

  @override
  Future<List<ConversationHeader>> getConversationHeaders() async {
    Database db = await _database;

    //Get the newest messages
    List<Map<String, dynamic>> result = await db.query("incomingMessages", groupBy: "localUserID", having: "unixTime = max(unixTime)"); //Get the message with the highest unixtime for each user

    //Query the users table so we can map localUserID to localAlias, and determine if they are blocked
    Map<int, String> aliasMap = await _getLocalAliasMap();


    //Combine the two into conversation headers
    List<ConversationHeader> conversationHeaders = [];

    for(Map<String, dynamic> map in result) {
      int localUserID = map["localUserID"];
      String localAlias = aliasMap[map['localUserID']];
      String content = map["content"];
      bool hasBeenRead = map["hasBeenRead"] == 1 ? true : false; //Converting from int to bool. Database constraints check that it is either 0 or 1
      ConversationHeader current = ConversationHeader(localUserID, localAlias, content, hasBeenRead);
      conversationHeaders.add(current);
    }

    return conversationHeaders;
  }

  Future<Map<int, String>> _getLocalAliasMap() async {
    Database db = await _database;
    List<Map<String, dynamic>> users = await db.query("users");
    Map<int, String> result = {};
    for(Map<String, dynamic> map in users) {
      result[map['localUserID']] = map['localAlias'];
    }
    return result;
  }


}