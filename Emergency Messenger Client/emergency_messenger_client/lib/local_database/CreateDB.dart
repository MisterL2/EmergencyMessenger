import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CreateDB {
  createDB() async {
    final Future<Database> database = openDatabase(
        join(await getDatabasesPath(), 'local_database.db'),
    );
  }
}