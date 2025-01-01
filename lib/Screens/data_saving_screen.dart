
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sqlite_crud/Widgets/custom_dialog.dart';
import 'package:sqlite_crud/Widgets/headers_dialog.dart';
import 'package:sqlite_crud/controller/data_saving_controller.dart';

class DataSavingSreen extends StatelessWidget {
  const DataSavingSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tables and Data"),
        centerTitle: true,
      ),
      body: SafeArea(child:
      SingleChildScrollView(
        child: GetBuilder<DataSavingController>(
          init: DataSavingController(),
          builder: (controller)
          => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children:[
        
           const Padding(
              padding:  EdgeInsets.all(8.0),
              child:  Text("Tap to use Existing Tables",style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),),
            ),
              ...List.generate(controller.tables.length, (index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.backup_table_rounded),
                  contentPadding:const  EdgeInsets.all(10.0),
                  title: Text(controller.tables[index].toUpperCase()),
                  splashColor: Colors.redAccent[100],
                  shape: Border.all(color: Colors.black,width: 1),
                  onTap: (){
                    controller.getAllExistingHeaders();
                    controller.getNewHeaders();
                    
                    Get.dialog(
                      barrierDismissible: false,
                      HeadersDialog(dialogFor: controller.tables[index]));
                  },
                ),
              );
            }),
             const Padding(
              padding:  EdgeInsets.all(8.0),
              child:  Text("OR",style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),),
            ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
        
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: (){
                Get.dialog( CustomDialog(dialogfor: "table"));
                          }, child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("Create New Table", style:TextStyle(
                  color: Colors.white,
                ),),
              ),
            ),
          ),
        ),
            ]
          ),
        ),
      ) ),

     
    );
  }
}