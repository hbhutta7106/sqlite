import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_crud/Models/book_model.dart';
class BookDataBaseService {

  static final BookDataBaseService _dataBaseService=BookDataBaseService._bookDataBaseService();

  static  Database? _database;
  BookDataBaseService._bookDataBaseService();
   
  

  factory BookDataBaseService()
  {
    return _dataBaseService;
  }
  Future<Database> get database async{
    if(_database!=null)
    {
    await    addColumnIfNotExists(_database!, 'books', 'bookAuthor', 'TEXT');
    return _database!;
    }
    else{
      _database= await initDatabase();
      return _database!;
    }



  }

  Future<Database> initDatabase() async{
    String dbPath=await getDatabasesPath();
    String path=join(dbPath,'dooks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookName TEXT NOT NULL,
        bookPrice TEXT NOT NULL,
        bookDescription TEXT NOT NULL
      )
    ''');
  }
  Future<void> addColumnIfNotExists(Database db, String tableName, String columnName, String columnDefinition) async {
  // Query the table schema
    final result = await db.rawQuery('PRAGMA table_info($tableName)');
    
    // Extract column names
    final columnNames = result.map((row) => row['name'] as String).toList();
    
    // Check if the column exists
    if (!columnNames.contains(columnName)) {
      // Add the column if it doesn't exist
      await db.execute('ALTER TABLE $tableName ADD COLUMN $columnName $columnDefinition');
    }
  }



   Future<void> addAuthorToBooks(Database db, int version) async {
    await db.execute('ALTER TABLE books ADD COLUMN bookAuthor TEXT IF NOT EXISTS');
  }

  Future<int> insertBook(BookModel bookModel)async
  {
    final db= await database;

    int id= await db.insert('books', bookModel.toJson());
    return id;

    
  }

  Future<int>deleteBook(String bookName)async
  {
    try {

      final db=await database;
    return await db.delete(
      'books',where: 'bookName=?',
      whereArgs: [bookName],

    );
    } catch (e) {
       Get.snackbar("Error", "Error Found which is ${e.toString()}");
      return 0;
    }
    

  }
  Future<List<BookModel>> getAllBooksFromDb()async
  {
    try {
         final db=await database;
    final List<Map<String,dynamic>> listOfMapOfBooks=await db.query('books');
     return listOfMapOfBooks.map((map)=>BookModel.fromJson(map)).toList();
    } catch (e) {
    Get.snackbar("Error", "Error Found which in fetching the value ${e.toString()}");
    return <BookModel>[];
    }
 
  } 

  Future<int> updateBook(BookModel book) async
  {

try {
  final db = await database;
    return await db.update(
      'books',
      book.toJson(),
      where: 'bookName = ?',
      whereArgs: [book.bookName],
    );
} catch (e) {
   Get.snackbar("Error", "Error Found which is ${e.toString()}");
  return 0;
  
}
  }



}
