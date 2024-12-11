import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FileController extends GetxController {
  // List<String> list=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o",];

  File? file;
  String? fileName;
  var fileData;
  var csvData = [];

  List<dynamic> rowValuesData = [];
  bool isloading = false;

  List<String> nonReadableValues = [];

  List<dynamic> nonReadableCharacters = [];

  void pickFile() async {
    try {
      // fileData = await rootBundle.loadString('assets/cost.csv');
//   fileData = await rootBundle.loadString('assets/output-data.csv');
//   //  fileData = await rootBundle.loadString('assets/out_data.txt');
//   checkTheFileType(fileData);
//  csvData = const CsvToListConverter(eol: "\n").convert(fileData);
//   print(csvData);

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
      isloading = true;
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

      for (int i = 0; i < csvData.length; i++) {
        debugPrint(csvData[i].toString());
        print(csvData[i].length);
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
}
