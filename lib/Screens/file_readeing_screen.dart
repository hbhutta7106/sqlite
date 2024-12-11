
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud/controller/file_controller.dart';

  class FileDisplay extends StatelessWidget {
     FileDisplay({super.key});
   final  FileController _fileController=Get.put(FileController());

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title:const  Text("File and its Data "),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _fileController.pickFile();
          },
          child: const Center(child: Text("Pick File"),),
        ),
        body: GetBuilder<FileController>(
          builder: (fileController)=>
   SafeArea(child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ 
                     const  Text("Picked File:",
                      ),
                      
          
                      SizedBox(
                        width: 100,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          _fileController.fileName??"No File Selected Yet"),
                      ),
                  
                      
                    ],
                    
                  ),
          
                const  SizedBox(height: 20,),

                _fileController.isloading?const Center(child: CircularProgressIndicator(),):
                _fileController.csvData.isEmpty?const SizedBox(
                  child: Text("No file is Selcted "),
                ):
                 SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable( columns: List.generate(_fileController.csvData[0].length, (index)
                  {
                     return DataColumn(label: Text(_fileController.csvData[0][index].toString()));
                  }) ,rows:_fileController.csvData.skip(1).map((element){
                    return DataRow(cells: List.generate(element.length, (index){
                      return DataCell(Text(element[index].toString()));
                    }));
                  }).toList()),
                ),
              
                ],
              ),
            ),
          )),
        ),
      );
    }
  }