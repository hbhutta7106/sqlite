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

  void getAllExistingHeaders() async {
    var setOfExistingColumns = await _fileService.getExistingColumns();
    existingColumns = setOfExistingColumns.toList();
    update();
  }

  void getNewHeaders() {
    for (int i = 0;
        i < _fileController.choosenHeadersFromHeaderList.length;
        i++) {
      if (!existingColumns
              .contains(_fileController.choosenHeadersFromHeaderList[i]) &&
          !newHeaders
              .contains(_fileController.choosenHeadersFromHeaderList[i])) {
        newHeaders.add(_fileController.choosenHeadersFromHeaderList[i]);
      }
    }
    update();
  }

  void testingFunction(
      String tableName, List<dynamic> columns, List<List<dynamic>> rows) async {
    await _fileService.insertDataIntoSqlite(tableName, columns, rows);
    // List<List<String>> rows = [
    //   ["a", "b", "c", "d"],
    //   ["a", "b", "c", "d"],
    //   ["a", "b", "c", "d"]
    // ];
    // List<String> columns = ["Hanan", "Arshman", "Subhan"];

    // for (int i = 0; i < columns.length; i++) {

    //   for (int j = 0; j < rows.length; j++) {

    //     debugPrint(
    //         "The Column is ${columns[i]} and the Row value is ${rows[j][i]}");
    //   }
    //   debugPrint("Next Columns Data Start");
    // }
  }
}

//0EBB-CEA2