class Book {
  final String title;
  final String author;
  final String isbn;
  final String link;
  final String cover;

  const Book({
    required this.title,
    required this.author,
    required this.isbn,
    required this.link,
    required this.cover,
  });


  static Book fromJson(dynamic json) {


    if (json is! Map) {
      return const Book(
        title: 'Database Formatting Error',
        author: 'Unknown',
        isbn: 'N/A',
        link: '',
        cover: '',
      );
    }


    return Book(
      title: json['title']?.toString() ?? 'Unknown Title',
      author: json['author']?.toString() ?? 'Unknown Author',
      isbn: json['isbn']?.toString() ?? 'Unknown ISBN',
      link: json['link']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
    );
  }
}