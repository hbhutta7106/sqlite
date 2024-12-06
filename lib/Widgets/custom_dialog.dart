import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud/controller/book_controller.dart';

class CustomDialog extends StatelessWidget {
   CustomDialog({super.key});
 final BookController controller = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
   return AlertDialog(
          title: const Text("Add New Book"),
          content: SingleChildScrollView(
            child: GetBuilder<BookController>(
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
             
                onPressed: () {
                  controller.clearController();
                  
                
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              
            ),
            controller.booktoUpdate!=null?
             ElevatedButton(
             
                onPressed: () {
                  controller.updateBook();
                  Navigator.of(context).pop();
                },
                child: const Text("Update"),
              
            ):const SizedBox(),
            controller.booktoUpdate==null?
            ElevatedButton(
              onPressed: () {
                controller.addBook();
                Navigator.of(context).pop();

              },
              child: const Text("Add"),
            ):const SizedBox(),
          ],
        );

  }
}