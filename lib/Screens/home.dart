import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sqlite_crud/Widgets/book_card.dart';
import 'package:sqlite_crud/Widgets/custom_dialog.dart';
import 'package:sqlite_crud/controller/book_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

final  BookController controller = Get.put(BookController());
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
      ),
      body: GetBuilder<BookController>(
        builder: (controller)=>
       controller.listOfBooks.isEmpty?const Center( child: Text("No Item Found"),): SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: List.generate(controller.listOfBooks.length, (index) {
                  return BookCard(bookModel:controller.listOfBooks[index], index: index,);
                }),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>  CustomDialog(),
          );
        },
        child: const Center(
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
