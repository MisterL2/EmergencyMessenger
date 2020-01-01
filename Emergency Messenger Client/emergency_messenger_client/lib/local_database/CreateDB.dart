import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CreateDB {
  createDB() async {
    final Future<Database> database = openDatabase(
        join(await getDatabasesPath(), 'local_database.db'),
      onCreate: (db, version) {
          db.execute("CREATE TABLE userCodes ("
              "localUserID INTEGER PRIMARY KEY," //This apparently autoincrements by default?
              "userCode TEXT UNIQUE NOT NULL CHECK(LENGTH(userCode)=100)"
              ");"
          );
          db.execute("CREATE TABLE users ("
              "localUserID INTEGER UNIQUE NOT NULL,"
              "localAlias TEXT," //Can be null
              "isBlocked INTEGER DEFAULT 0 CHECK(isBlocked=0 or isBlocked=1),"  //SQLite does not have a boolean type, so I am imitating it here.
              "FOREIGN KEY (localUserID) REFERENCES userCodes(localUserID)"
              ");"
          );
          db.execute("CREATE TABLE incomingMessages ("
              "senderLocalUserID PRIMARY KEY,"
              "content TEXT NOT NULL,"
              "FOREIGN KEY (senderLocalUserID) REFERENCES userCodes(localUserID)"
              ");"
          );
          db.execute("CREATE TABLE outgoingMessages ("
              "targetLocalUserID PRIMARY KEY,"
              "content TEXT NOT NULL,"
              "FOREIGN KEY (targetLocalUserID) REFERENES userCodes(targetLocalUserID)"
              ");"
          );
      }
    );
  }
}