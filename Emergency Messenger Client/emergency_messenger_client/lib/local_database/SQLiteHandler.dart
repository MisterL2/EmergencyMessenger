import 'package:emergency_messenger_client/dataclasses/ConversationHeader.dart';
import 'package:emergency_messenger_client/dataclasses/Message.dart';
import 'package:emergency_messenger_client/dataclasses/User.dart';
import 'package:emergency_messenger_client/dataclasses/UserCode.dart';
import 'package:emergency_messenger_client/local_database/CustomDatabaseException.dart';
import 'package:emergency_messenger_client/local_database/DBHandler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class SQLiteHandler extends DBHandler {
  @override
  Future<Database> openDB({String databaseName}) async {
    String databasePath = databaseName == null ? 'local_database.db' : databaseName;
    return openDatabase(
        join(await getDatabasesPath(), databasePath),
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
            //User blocking is managed server-side in order to avoid issues with client-side blocking, such as silent ddos.
            "isBlocked INTEGER DEFAULT 0 CHECK(isBlocked=0 or isBlocked=1),"  //SQLite does not have a boolean type, so I am imitating it here.
            "FOREIGN KEY (localUserID) REFERENCES userCodes(localUserID)"
            ");"
          );
          db.execute(
            "CREATE TABLE messages ("
            "localUserID PRIMARY KEY," //Of the conversation partner
            "content TEXT NOT NULL,"
            "unixTime INTEGER NOT NULL CHECK(unixTime > 1577979238),"
            "hasBeenRead INTEGER DEFAULT 0 CHECK(hasBeenRead=0 or hasBeenRead=1),"
            "isOwnMessage INTEGER DEFAULT 0 CHECK(isOwnMessage=0 or isOwnMessage=1),"
            "FOREIGN KEY (localUserID) REFERENCES userCodes(localUserID)"
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
  Future<User> getUser(int localUserID) async {
    Database db = await openDB();
    List<Map<String,dynamic>> result = await db.query("users", where: "localUserID = ?", whereArgs: [localUserID]);
    if(result.length==0) {
      throw CustomDatabaseException("The localUserID '$localUserID' does not exist!");
    } else if(result.length!=1) {
      throw CustomDatabaseException("There are multiple entries for the localUserID '$localUserID'!");
    } else {
      Map<String, dynamic> map = result[0];
      String localAlias = map["localAlias"];
      bool isBlocked = map["isBlocked"] == 1 ? true : false;
      return User(localAlias, localUserID, isBlocked);
    }
  }

  @override
  Future<String> getUserCodeOf(int localUserID) async {
    Database db = await openDB();
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
  Future<int> getLocalUserIDOf(UserCode userCode) async {
    Database db = await openDB();
    List<Map<String, dynamic>> result = await db.query("userCodes", where: "userCode = ?", whereArgs: [userCode.userCode]);

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
  Future<void> addMessage(int localUserID, String content, int unixTime, bool incoming) async {
    Map<String, dynamic> message = {
      "localUserID" : localUserID,
      "content" : content,
      "unixTime" : unixTime,
      "hasBeenRead" : incoming ? 0 : 1, //If it is an incoming message, it has not been read yet. If it was sent by the user, it naturally has been read already.
      "isOwnMessage" : incoming ? 1 : 0, //Convert to integer, not sure if completely necessary
    };

    Database db = await openDB();
    int indexInsertedAt = await db.insert("messages", message);

  }

  @override
  Future<void> addUser(UserCode userCode) async {
    Database db = await openDB();
    int rowCount = Sqflite.firstIntValue(await db.rawQuery("SELECT count(*) FROM userCodes;"));
    int localUserID = rowCount + 1;
    Map<String, dynamic> userCodesInsert = {
      "localUserID" : localUserID,
      "userCode" : userCode.userCode,
    };
    int indexInsertedAt = await db.insert("userCodes", userCodesInsert);

    Map<String, dynamic> userTableInsert = {
      "localUserID" : localUserID,
      "localAlias" : "Anonymous", //Used as default
      "isBlocked" : 0, //"False"
    };

    indexInsertedAt = await db.insert("users", userTableInsert);
  }

  @override
  Future<void> changeBlockStatus(int localUserID, String localAlias, bool isNowBlocked) async {
    //Technically localAlias is not required for the logic, but the update-command replaces an entire row, not just a field. I would have to query the localAlias first if it wasn't supplied.
    Database db = await openDB();

    Map<String, dynamic> rowToBeInserted = {
      "localUserID" : localUserID,
      "localAlias" : localAlias,
      "isBlocked" : isNowBlocked,
    };
    int indexInsertedAt = await db.update("users", rowToBeInserted, where: "localUserID = ?", whereArgs: [localUserID]);
  }

  @override
  Future<void> changeUserAlias(int localUserID, String newAlias, bool isBlocked) async {
    //Technically isBlocked is not required for the logic, but the update-command replaces an entire row, not just a field. I would have to query the isBlocked-boolean first if it wasn't supplied.
    Database db = await openDB();

    Map<String, dynamic> rowToBeInserted = {
      "localUserID" : localUserID,
      "localAlias" : newAlias,
      "isBlocked" : isBlocked,
    };


    int indexInsertedAt = await db.update("users", rowToBeInserted, where: "localUserID = ?", whereArgs: [localUserID]);
  }

  @override
  Future<List<ConversationHeader>> getConversationHeaders() async {
    Database db = await openDB();
    print(db);

    //Get the newest messages
    List<Map<String, dynamic>> result = await db.query("messages", groupBy: "localUserID", having: "unixTime = max(unixTime)"); //Get the message with the highest unixtime for each user

    //Query the users table so we can map localUserID to localAlias, and determine if they are blocked
    Map<int, String> aliasMap = await _getLocalAliasMap();
    print(aliasMap);

    //Combine the two into conversation headers
    List<ConversationHeader> conversationHeaders = [];

    for(Map<String, dynamic> map in result) {
      int localUserID = map["localUserID"];
      String localAlias = aliasMap[map['localUserID']];
      String content = map["content"];
      bool hasUnreadMessages = map["hasBeenRead"] == 1 ? false : true; //Converting from int to bool and inverting (hasBeenRead to hasUnreadMessages). Database constraints check that it is either 0 or 1
      bool isOwnMessage = map["isOwnMessage"] == 1 ? true : false; //Converting from int to bool. Database constraints check that it is either 0 or 1
      ConversationHeader current = ConversationHeader(localUserID, localAlias, content, hasUnreadMessages, isOwnMessage);
      conversationHeaders.add(current);
    }

    return conversationHeaders;
  }

  Future<Map<int, String>> _getLocalAliasMap() async {
    Database db = await openDB();
    List<Map<String, dynamic>> users = await db.query("users");
    Map<int, String> result = {};
    for(Map<String, dynamic> map in users) {
      result[map['localUserID']] = map['localAlias'];
    }
    return result;
  }

  @override
  Future<List<Message>> fetchMessages(int localUserID, int amountOfMessages) async {
    Database db = await openDB();
    //Get the top {amountOfMessages} from both outgoing and incoming based on unixtime
    List<Map<String, dynamic>> messages = await db.query("messages", where: "localUserID = ?", whereArgs: [localUserID], orderBy: "unixTime desc", limit: amountOfMessages);

    //Convert into a combined List<Message>
    List<Message> result = [];
    for(Map<String, dynamic> map in messages) {
      bool isOwnMessage = map["isOwnMessage"]==1 ? true : false;
      bool hasBeenRead = map["hasBeenRead"]==1 ? true : false;
      Message message = Message(map["content"], map["unixTime"], isOwnMessage, hasBeenRead); //the value "isOwnMessage" is always false for incoming messages
      result.add(message);
    }

    return result;
  }

  @override
  Future<void> deleteDB({String databaseName}) async {
    await deleteDatabase('local_database.db');
  }




}