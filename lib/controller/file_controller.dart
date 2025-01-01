import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sqlite_crud/Widgets/headers_dialog.dart';


class FileController extends GetxController {


  bool ? isContainHeaders;

 
  List<dynamic> headers = [];
  List<List<dynamic>> rows = [];
  List<bool> selectedHeaders = [];
  List<dynamic> choosenHeadersFromHeaderList=[];
  List<List<dynamic>> choosenRows=[];
   File? file;
  String? fileName;
  var csvData = [];
  bool isloading = false;
  bool showTable=false;

  
   void selectHeadersAndTheirData(int index, bool value)
   {
      print(index);
      
      selectedHeaders[index]=value;
      chooseRowsWithData(index);
     
        if(headers[index]==null||headers[index]==""){
          
          choosenHeadersFromHeaderList.add("Header${index+1}");
        
        }
        else{
         
          choosenHeadersFromHeaderList.add(headers[index]);
          
        }
        
      

        if(selectedHeaders[index]==false)
        {
        choosenHeadersFromHeaderList.remove(headers[index]);
        }
     
      debugPrint("Choosen Headers are $choosenHeadersFromHeaderList");
      update();

   }
  void chooseRowsWithData(int index)
  {
 
    for(int i=0;i<rows.length;i++)
    {
      
    
        if(rows[i][index]==null||rows[i][index]=="")
        {
          choosenRows[i].add("null");
        }
        else{
          choosenRows[i].add(rows[i][index]);
        }
      
    
        if(selectedHeaders[index]==false)
        {
          print("The value which is to be removed ${rows[i][index]}");
        
        choosenRows[i].remove(rows[i][index]);
        }
      

      print("The Rows are ${choosenRows[i]} and Length is ${choosenRows[i].length}");
    }
    
    
    update();
  }

  void clearData()
  {
    headers=[];
    rows=[];
    selectedHeaders=[];
    choosenHeadersFromHeaderList=[];
    choosenRows=[];
    showTable=false;
    isContainHeaders=null;
    fileName=null;
    csvData=[];

    update();
  }


  void  checkContainHeaders(bool value)
  {
    isContainHeaders=value;
    debugPrint("Headers Value is $isContainHeaders");
    update();
  }
 void  showDataTable()
  {
    showTable=true;
    update();
  }

  void showHeadersDialog()
  {
    Get.dialog(
      Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          
        ),
        child:  HeadersDialog(),
      )
    );
  }
 
  

 

  void pickFile() async {
 

  
    try {
     

      final result = await FilePicker.platform.pickFiles(
        dialogTitle: "Pick CSV File",
        type: FileType.custom,
        allowedExtensions: [
          'csv',
        ],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile platformFile = result.files.first;
        fileName = platformFile.name;

        if (platformFile.path != null) {
          file = File(platformFile.path!);

          update();

          Get.snackbar("Success", "File picked: $fileName");
           isloading = true;

          readFile();
        } else {
          Get.snackbar("Error!", "File path is null");
        }
      } else {
        Get.snackbar("Error!", "No file selected");
      }
    } catch (e) {
      Get.snackbar("Error!", "An unexpected error occurred: $e");
      debugPrint("FilePicker Error: $e");
    }
    
  }

  void readFile() async {
    if (file != null) {
      //final input=file!.openRead();
     
      final fields = await file!.readAsString(encoding: latin1);
      final valuesOfFields=checkTheFileType( fields);

      if(valuesOfFields.isNotEmpty)
      {
        csvData = const CsvToListConverter(eol: "\r\n").convert(valuesOfFields);
      }
      else
      {
        Get.snackbar("Error!", "File is not in the correct format");
      }
      

      isloading = false;

      separateFileDataIntoHeadersAndRows();
      debugPrint("CSV Data =${csvData.runtimeType}");

      for (int i = 0; i < csvData.length; i++) {
        debugPrint(csvData[i].toString());
        debugPrint(csvData.length.toString());
      }
      if(isContainHeaders==false)
      {
      showTable=true;
      }
      update();
    } else {
      Get.snackbar("Error!", "No file selected");
    }
  }

  String checkTheFileType(String fileContent) {
    String fileValues="";
     if(fileContent.contains("\r\n"))
     {
        debugPrint("File is Ready to go ");
        fileValues=fileContent;
     }
     else if(fileContent.contains("\n"))
     {
      fileValues= fileContent.replaceAll("\n", "\r\n");
       
     }
     else if(fileContent.contains("\r"))
     {
fileValues=fileContent.replaceAll("\r", "\r\n");
     }
     else
     {
       debugPrint("File is not in the correct format ");
       fileValues="";
     }
    return fileValues;
  }




  void separateFileDataIntoHeadersAndRows()
  {
    if(isContainHeaders==true)
    {
      headers=csvData[0];
      rows=csvData.sublist(1).cast<List<dynamic>>();
      selectedHeaders=List.generate(headers.length, (index) => false);
      
     

      showHeadersDialog();
      choosenRows=List.generate(rows.length, (index) => []);

      debugPrint("Rows are the  $rows");
     
    }
    else
    {
      headers=[];
      rows=csvData.cast<List<dynamic>>();
    }
    update();
  }
}
