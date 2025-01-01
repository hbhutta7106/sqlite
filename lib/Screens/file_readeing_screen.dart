
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud/Screens/data_saving_screen.dart';
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

        bottomNavigationBar:
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetBuilder<FileController>(
            builder: (controller)=>
            SizedBox(
            height: 110,
              child:controller.showTable? Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.black
                    ),
                    onPressed: (){
                    _fileController.clearData();
                  }, child: const Center(
                    child: Text("Clear Screen", style:TextStyle(
                      color: Colors.white,
                    ),),
                  )),

                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.black
                    ),
                    onPressed: (){
                   Get.to(()=>const DataSavingSreen());
                    
                  }, child:const Padding(
                    padding:  EdgeInsets.all(10.0),
                    child:  Center(
                      child: Text("Are You want to Save Data ?", style:TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                  )),
                ],
              ):
              const SizedBox(),
            ),
          ),
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
                _fileController.csvData.isEmpty?Column(
                  children: [
                    const SizedBox(
                      child: Text("No file is Selcted "),
                    ),
                   const  SizedBox(height: 20,),
                    
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              const Text("File Contain Headers?"),
                                const  SizedBox(width: 30,),
                              const Text("Yes"),
                              Radio<bool>(
                                value: true,
                                groupValue: _fileController.isContainHeaders,
                                onChanged: (value) {
                                  _fileController.checkContainHeaders(value!);
                                                 
                                },
                              ),
                              const Text("No"),
                              Radio<bool>(
                                value: false,
                                groupValue: _fileController.isContainHeaders,
                                onChanged: (value) {
                                  _fileController.checkContainHeaders(value!);
                                 
                                },
                              ),
                            ],
                          ),
                        ),
                         ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:  Colors.black
              ),
              onPressed: (){
              _fileController.pickFile();
            }, child: const Center(
              child: Text("Pick File ", style:TextStyle(
                color: Colors.white,
              ),),
            )),
                      
                  ],
                ):
                _fileController.showTable?

                
                 SizedBox(
                  width: MediaQuery.of(context).size.width,
                   child: FittedBox(
                    fit: BoxFit.scaleDown,
                     child: DataTable( columns:_fileController.choosenHeadersFromHeaderList.isEmpty? List.generate(_fileController.rows[0].length, (index)
                     {
                        return DataColumn(label: Text("Column ${index+1}"));
                     }):List.generate(_fileController.choosenHeadersFromHeaderList.length, (index){
                       return DataColumn(label: Text(_fileController.choosenHeadersFromHeaderList[index].toString()));
                     }),rows:
                     fileController.choosenRows.every((subList)=>subList.isEmpty)?_fileController.rows.map((element){
                       return DataRow(cells: List.generate(element.length, (index){
                         return DataCell(Text(element[index].toString()));
                       }));
                     }).toList():
                     _fileController.choosenRows.map((element){
                       return DataRow(cells: List.generate(element.length, (index){
                         return DataCell(Text(element[index].toString()));
                       }));
                     }).toList()),
                   ),
                 ): const Text("Waiting for Data to Load"),
              
                ],
              ),
            ),
          )),
        ),
      );
    }
  }

 