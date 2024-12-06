class BookModel {
  final String bookName;
  final String bookPrice;
  final String bookDescription;
  final String bookAuthor;

  BookModel({
    required this.bookName,
    required this.bookPrice,
    required this.bookDescription,
    required this.bookAuthor,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      bookName: json['bookName'],
      bookPrice: json['bookPrice'],
      bookDescription: json['bookDescription'],
      bookAuthor: json['bookAuthor']??"",
    );  
  }

  Map<String, dynamic> toJson() {
    return {
      'bookName': bookName,
      'bookPrice': bookPrice,
      'bookDescription': bookDescription,
      'bookAuthor': bookAuthor,
    };
  }
  BookModel copyWith({
    String? bookName,
    String? bookPrice,
    String? bookDescription,
    String? bookAuthor,
  }) {
    return BookModel(
      bookName: bookName ?? this.bookName,
      bookPrice: bookPrice ?? this.bookPrice,
      bookDescription: bookDescription ?? this.bookDescription,
      bookAuthor: bookAuthor ?? this.bookAuthor,

    );
  }

 



}