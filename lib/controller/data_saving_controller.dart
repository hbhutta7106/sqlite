import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud/controller/file_controller.dart';
import 'package:sqlite_crud/services/file_service.dart';

class DataSavingController extends GetxController {
  final FileService _fileService = FileService();
  List<String> tables = [];
  String selectedTableName = '';
  final TextEditingController tableNameController = TextEditingController();
  List<String> existingColumns = [];
  List<String> newHeaders = [];
  final FileController _fileController = Get.put(FileController());
  List<Map<String, dynamic>> _dataWithOutHeaders = [];

  @override
  void onInit() async {
    super.onInit();
    tables = await _fileService.getTables();
    update();
  }

  void selecTable(String tableName) {
    selectedTableName = tableName;
    update();
  }

  void createTable() async {
    if (tableNameController.text.contains(' ')) {
      tableNameController.text = tableNameController.text.replaceAll(' ', '_');
    }
    await _fileService.createTable(tableNameController.text);
    tables = await _fileService.getTables();
    tableNameController.clear();
    update();
  }

  void deleteDatabase() async {
    await _fileService.deleteDatabaseFile('tailors.db');
  }

  Future<void> getAllExistingColumns(String tableName) async {
    var setOfExistingColumns = await _fileService.getExistingColumns(tableName);

    existingColumns = setOfExistingColumns
        .where((column) => column != "id") // Exclude "id" column
        .toList();
    update();
  }

  void getNewHeaders() {
    debugPrint("existing headers are $existingColumns");
    for (int i = 0;
        i < _fileController.choosenHeadersFromHeaderList.length;
        i++) {
      if (!existingColumns
          .contains(_fileController.choosenHeadersFromHeaderList[i])) {
        newHeaders.add(_fileController.choosenHeadersFromHeaderList[i]);
      }
    }
    update();
  }

  Future<void> insertColumns(
      List<dynamic> columnsToAdd, String tableName) async {
    await _fileService.insertColumns(
      columnsToAdd,
      tableName,
    );
    debugPrint("Columns has been added ");
  }

  void insertDataIntoTable(
      String tableName, List<dynamic> columns, List<List<dynamic>> rows) async {
    await _fileService.insertDataIntoSqlite(tableName, columns, rows);
  }

  void clearController() {
    newHeaders = [];
    existingColumns = [];
    update();
  }

  Future<void> getAllDataFromTable(String tableName) async {
    var list = await _fileService.getAllDataFromTable(tableName);
    debugPrint("$list");
  }

  Future<void> insertIntoTableWithOutNewHeaders(
    List<dynamic> columns,
    List<List<dynamic>> rows,
    String tableName,
  ) async {
    debugPrint(
        "The Length of Row is ${rows.length}  and $rows columns are ${columns.length} and $columns");
    for (var row in rows) {
      Map<String, dynamic> rowData = {};
      // debugPrint(
      //"Existing COlumns are $existingColumns and columns are $columns");
      for (int i = 0; i < columns.length; i++) {
        if (existingColumns.contains(columns[i])) {
          rowData[columns[i]] = row[i];
        } else {
          debugPrint("New Header Exist in the Table ${columns[i]}");
        }
      }
      _dataWithOutHeaders.add(rowData);
    }

    debugPrint("The Whole data is $_dataWithOutHeaders");
    for (var map in _dataWithOutHeaders) {
      await _fileService.insertIntoTable(tableName, map);
    }
  }
}


//0EBB-CEA2