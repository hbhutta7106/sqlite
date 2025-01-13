import 'dart:async';
import 'dart:convert';

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
    
  }

  Future<void> createTable(String tableName) async {
    final db = await database;
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT
      )
    ''');
  }

  Future<Set<String>> getExistingColumns(String tableName) async {
    final db = await database;
    List<Map<String, dynamic>> columns =
        await db.rawQuery("PRAGMA table_info($tableName)");
    final existingColumns = columns.map((row) => row['name'] as String).toSet();
    return existingColumns;
  }

  Future<bool> checkColumnExist(String columnName, String tableName) async {
    Set<String> existingColumns = await getExistingColumns(tableName);

    if (existingColumns.contains(columnName)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> insertColumns(
      List<dynamic> columnsToAdd, String tableName) async {
    try {
      final db = await database;

      for (int i = 0; i < columnsToAdd.length; i++) {
        if (await checkColumnExist(columnsToAdd[i], tableName) == false) {
          await db.execute(
              'ALTER TABLE $tableName ADD COLUMN ${columnsToAdd[i].toString()} TEXT');
        } else {
          debugPrint("Column Already Exist in the Table ${columnsToAdd[i]}");
        }
      }
    } catch (e) {
      debugPrint("Error is this  $e");
    }
  }

  void printPretty(Map<String, dynamic> map) {
    // String prettyJson = jsonEncode(map);
    String prettyString = const JsonEncoder.withIndent('  ')
        .convert(map); // 2 spaces for indentation
    debugPrint(prettyString); // Print the formatted map
  }

  Future<void> insertDataIntoSqlite(
      String tableName, List<dynamic> columns, List<List<dynamic>> rows) async {
   // final db = await database;

    try {
      for (int i = 0; i < columns.length; i++) {
        for (int j = 0; j < rows.length; j++) {
         await insertIntoTable(tableName, columns[i], rows[j][i].toString());
        }
      }
    } catch (e) {
      debugPrint("Error is this not $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAllDataFromTable(
      String tableName) async {
    final db = await database; // Make sure the database instance is initialized

    try {
      // Retrieve all rows from the table
      List<Map<String, dynamic>> result =
          await db.rawQuery('SELECT * FROM tailors');

      // You can return the result to the caller or process it as needed
      for (int i = 0; i < result.length; i++) {
        debugPrint("The value at the index$i is ${result[i]}");
      }
      return result;
    } catch (e) {
      debugPrint("Error retrieving data: $e");
      return [];
    }
  }

  Future<void> deleteDatabaseFile(String dbName) async {
    try {
      // Get the database directory
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, dbName);

      // Delete the database
      await deleteDatabase(path);
      debugPrint("Database $dbName deleted successfully.");
    } catch (e) {
      debugPrint("Error deleting database: $e");
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

  Future<void> insertIntoTable(
      String tableName, String columnName, String rowValue) async {
    final db = await database;
    String query = 'INSERT INTO $tableName ($columnName) VALUES ("$rowValue")';
    await db.rawInsert(query);
  }
}
