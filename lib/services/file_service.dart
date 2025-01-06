import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FileService {
  static Database? _database;

  static final FileService _fileDatabaseService = FileService._fileService();

  FileService._fileService();

  factory FileService() {
    return _fileDatabaseService;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDatabase();
      return _database!;
    }
  }

  Future<Database> initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'tailors.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tailors (
        id INTEGER PRIMARY KEY AUTOINCREMENT
      )
    ''');
  }

  Future<void> createTable(String tableName) async {
    final db = await database;
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT
      )
    ''');
  }

  Future<Set<String>> getExistingColumns() async {
    final db = await database;
    List<Map<String, dynamic>> columns =
        await db.rawQuery("PRAGMA table_info(tailors)");
    final existingColumns = columns.map((row) => row['name'] as String).toSet();
    return existingColumns;
  }

  Future<bool> checkColumnExist(String columnName) async {
    Set<String> existingColumns = await getExistingColumns();

    if (existingColumns.contains(columnName)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> insertColumns(List<dynamic> columnsToAdd) async {
    final db = await database;
    for (int i = 0; i < columnsToAdd.length; i++) {
      if (await checkColumnExist(columnsToAdd[i]) == false) {
        await db
            .execute('ALTER TABLE tailors ADD COLUMN ${columnsToAdd[i]} TEXT');
      } else {
        debugPrint("Column Already Exist in the Table ${columnsToAdd[i]}");
      }
    }
  }

  Future<void> insertDataIntoSqlite(
      String tableName, List<dynamic> columns, List<List<dynamic>> rows) async {
    final db = await database;

    try {
      for (int i = 0; i < columns.length; i++) {
        for (int j = 0; j < rows.length; j++) {
          // await db.rawInsert(
          //     "INSERT INTO $tableName (${columns[i]}) VALUES (${rows[j][i]})");

          debugPrint(
              "The Column is ${columns[i]} and the Row value is ${rows[j][i]}");
        }
      }
    } catch (e) {
      debugPrint("Error is $e");
    }
  }

  Future<void> deleteDatabaseFile(String dbName) async {
    try {
      // Get the database directory
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, dbName);

      // Delete the database
      await deleteDatabase(path);
      print("Database $dbName deleted successfully.");
    } catch (e) {
      print("Error deleting database: $e");
    }
  }

  Future<void> insertDataIntoTable(
      List<dynamic> keys, List<dynamic> values) async {}

  Future<List<String>> getTables() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT name 
    FROM sqlite_master 
    WHERE type = "table" 
      AND name NOT LIKE "sqlite_%"
      AND name != "android_metadata"
  ''');
    List<String> tableNames = result.map((e) => e['name'].toString()).toList();
    return tableNames;
  }
}
