import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud/controller/file_controller.dart';
import 'package:sqlite_crud/services/file_service.dart';

class DataSavingController  extends GetxController{

final FileService _fileService=FileService();
List<String> tables=[];
final TextEditingController tableNameController=TextEditingController();
List<String> existingColumns=[];
List<String> newHeaders=[];
final FileController _fileController=Get.put(FileController());


  @override
  void onInit() async{

    super.onInit();
    tables=await _fileService.getTables();
    update();

  }
  void createTable()async{

    if(tableNameController.text.contains(' '))
    {
      tableNameController.text=tableNameController.text.replaceAll(' ', '_');
    }
    await _fileService.createTable(tableNameController.text);
    tables=await _fileService.getTables();
    tableNameController.clear();
    update();

  }
  void deleteDatabase() async
  {
  await _fileService.deleteDatabaseFile( 'tailors.db');
  }

  void getAllExistingHeaders() async
  {
    var setOfExistingColumns=await _fileService.getExistingColumns();
   existingColumns= setOfExistingColumns.toList();
    update();
  }


  void getNewHeaders()
  {
    for(int i =0;i<_fileController.choosenHeadersFromHeaderList.length;i++)
    {
      if(!existingColumns.contains(_fileController.choosenHeadersFromHeaderList[i])&& !newHeaders.contains(_fileController.choosenHeadersFromHeaderList[i]))
      {
        newHeaders.add(_fileController.choosenHeadersFromHeaderList[i]);
      }
    }
    update();
  }


}