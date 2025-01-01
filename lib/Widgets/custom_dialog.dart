import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud/controller/book_controller.dart';
import 'package:sqlite_crud/controller/data_saving_controller.dart';

class CustomDialog extends StatelessWidget {
   CustomDialog({super.key,this.dialogfor});
 final BookController bookController = Get.put(BookController());
 final DataSavingController dataSavingController=Get.put(DataSavingController());
 String? dialogfor;

  @override
  Widget build(BuildContext context) {
   return AlertDialog(
          title: const Text("Add New Book"),
          content: SingleChildScrollView(
            child:dialogfor=="table"?createTableDialog():
             GetBuilder<BookController>(
              init: BookController(),
              builder: (controller)=>
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller.bookNameController,
                    decoration: const InputDecoration(
                      labelText: "Book Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller.bookPriceController,
                    decoration: const InputDecoration(
                      labelText: "Book Price",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                 const  SizedBox(height: 10),
                  TextField(
                    controller: controller.bookAuthorController,
                    decoration: const InputDecoration(
                      labelText: "Author Name",
                      border: OutlineInputBorder(),
                    ),
                    
                  ),
                  //  const  SizedBox(height: 10),
                  // TextField(
                  //   controller: controller.bookWriterController,
                  //   decoration: const InputDecoration(
                  //     labelText: "Writer Name",
                  //     border: OutlineInputBorder(),
                  //   ),
                    
                  // ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller.bookDescriptionController,
                    decoration: const InputDecoration(
                      labelText: "Book Description",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),

          actions: [
            ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,

          ),
             
                onPressed:dialogfor=="table"?(){
               
                  Navigator.of(context).pop();
            }: () {
                  bookController.clearController();
                  
                
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel", style: TextStyle(color: Colors.white),),
              
            ),
            bookController.booktoUpdate!=null?
             ElevatedButton(
             
                onPressed: () {
                  bookController.updateBook();
                  Navigator.of(context).pop();
                },
                child: const Text("Update"),
              
            ):const SizedBox(),
            bookController.booktoUpdate==null?
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed:dialogfor=="table"?(){
                  dataSavingController.createTable();
                  Get.back();
              }: () {
                bookController.addBook();
                Navigator.of(context).pop();

              },
              child:  Text( dialogfor=="table"?"Craete Table": "Add", style:const  TextStyle(color: Colors.white),),
            ):const SizedBox(),
          ],
        );

  }



  Widget createTableDialog(){

    return GetBuilder<DataSavingController>(
      init: DataSavingController(),
      builder: (controller)=>
       Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
      
            TextFormField(
              controller: controller.tableNameController,
              decoration: const InputDecoration(
                labelText: "Table Name",
                border: OutlineInputBorder(),
                hintText: "Enter Table Name",
                
              ),

            ),
            
      
        ],
      ),
    );
  }

  
}