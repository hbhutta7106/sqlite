import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud/Models/book_model.dart';

import 'package:sqlite_crud/services/book_service.dart';

class BookController  extends GetxController{


  @override
  void onInit()async {
    super.onInit();
    listOfBooks=await _dataBaseService.getAllBooksFromDb();
    update();

  }

  final  BookDataBaseService _dataBaseService=BookDataBaseService();
  BookModel? booktoUpdate;
  int indexToupdate=-1;
 List<BookModel> listOfBooks = [

  ];

  TextEditingController bookNameController = TextEditingController();
  TextEditingController bookPriceController = TextEditingController();
  TextEditingController bookDescriptionController = TextEditingController();
  TextEditingController bookAuthorController = TextEditingController();

clearController(){
  bookNameController.clear();
  bookPriceController.clear();
  bookDescriptionController.clear();
  bookAuthorController.clear();
  booktoUpdate=null;
  update();
}
 

void addBook() async
{
  try {
    if(bookNameController.text=="" || bookPriceController.text=="" || bookDescriptionController.text=="")
  {
    Get.snackbar("Empty Fields", "Fields Cannot be Empty");
    return;
  }
  else{
    BookModel bookModel = BookModel(
      bookName: bookNameController.text,
      bookPrice: bookPriceController.text,
      bookDescription: bookDescriptionController.text,
      bookAuthor: bookAuthorController.text
    );
    int id= await _dataBaseService.insertBook(bookModel);
    if(id!=0)
    {
    listOfBooks.add(bookModel);
    }

    update();
  }
  clearController();
  } catch (e) {
    Get.snackbar("Error","Error inserting in the Database$e.toString()");
  }

  
  
  
}

void editBook(BookModel model,int index)
{
  indexToupdate=index;
  bookNameController.text = model.bookName;
  bookPriceController.text = model.bookPrice;
  bookDescriptionController.text= model.bookDescription;
  bookAuthorController.text=model.bookAuthor;
  booktoUpdate=model;
  update();

}
void updateBook()
{
 
  if(booktoUpdate!=null)
  {
  if(bookNameController.text.isNotEmpty||bookPriceController.text.isNotEmpty||bookAuthorController.text.isNotEmpty)
  {
   var updatedBook= booktoUpdate!.copyWith(bookName: bookNameController.text,bookPrice: bookPriceController.text,bookDescription: bookDescriptionController.text,bookAuthor: bookAuthorController.text);
    listOfBooks[indexToupdate]=updatedBook;

    update();
    _dataBaseService.updateBook(updatedBook);

    Get.snackbar("Book Updation", "Book Has been Updated with new values");
  }
  else{
   booktoUpdate!.copyWith(bookName: booktoUpdate!.bookName,bookPrice: booktoUpdate!.bookPrice,bookDescription: booktoUpdate!.bookDescription,bookAuthor: booktoUpdate!.bookAuthor);
   _dataBaseService.updateBook(booktoUpdate!);
    Get.snackbar("Book Updation", "Book is stored with the same values");

  }

  booktoUpdate=null;
  update();
  }

}
void deleteBook(int index) async
{

  await _dataBaseService.deleteBook(listOfBooks[index].bookName);
  listOfBooks.removeAt(index);
  Get.snackbar("Deleted!", " Book has been removed");
  update();
}


}