class Book {
  // Book properties
  final int? id; // Nullable as it is auto-incremented by Supabase
  String title;
  String author;
  DateTime? publishedDate;
  bool isAvailable;

  // Constructor with named parameters
  Book({
    this.id,
    required this.title,
    required this.author,
    this.publishedDate,
    this.isAvailable = false,
  });

  // Factory constructor to create a Book object from a map of values
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int?, // Accepts nullable id
      title: json['title'] as String,
      author: json['author'] as String,
      publishedDate: json['published_date'] != null
          ? DateTime.tryParse(json['published_date'] as String)
          : null, // Handles null or invalid date format
      isAvailable: (json['is_available'] as bool?) ?? false, // Default to false
    );
  }

  // Method to convert Book to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'published_date':
          publishedDate?.toIso8601String(), // Converts to ISO 8601
      'is_available': isAvailable,
    };
  }
}
