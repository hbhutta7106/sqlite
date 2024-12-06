import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud/Models/book_model.dart';
import 'package:sqlite_crud/Widgets/custom_dialog.dart';
import 'package:sqlite_crud/controller/book_controller.dart';

class BookCard extends StatelessWidget {
   BookCard({super.key, required this.bookModel, required this.index});
  final BookModel bookModel;
  final int index;
  final BookController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
    
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical:  8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [ 
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(bookModel.bookName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
               Text("${bookModel.bookPrice} Rs", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),),
            ],
          ),
          const SizedBox(height: 10,),
          
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width*0.6,
                child: Text(bookModel.bookDescription, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),)),
               Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                 IconButton(onPressed: (){
                  controller.deleteBook(index);

                 }, icon:const Icon( Icons.delete),
                 iconSize: 35,
                 color: Colors.red,
                 ),
                 IconButton(onPressed:(){
                  showDialog(context: context, builder: (context)
                  {
                    return CustomDialog();
                  });
                  controller.editBook(bookModel,index);
                 }, icon:const Icon( Icons.edit,),iconSize: 35,color: Colors.black,)
               ],)
            ],
          ),
        ],

      ),


    );
  }
}