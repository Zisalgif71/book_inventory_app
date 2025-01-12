import 'package:books/book.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookDatabase {
  // Instantiate a new Database object
  final database = Supabase.instance.client.from('books');

  // Insert a book into the database
  Future<void> insertBook(Book book) async {
    try {
      await database.insert(book.toJson());
    } catch (e) {
      throw Exception("Failed to insert book: $e");
    }
  }

  // Get a stream of books from the database
  Stream<List<Book>> getBooksStream() {
    try {
      return database.stream(primaryKey: ['id']).map(
          (data) => data.map((json) => Book.fromJson(json)).toList());
    } catch (e) {
      throw Exception("Failed to fetch books stream: $e");
    }
  }

  // Update a book in the database
  Future<void> updateBook(Book book) async {
    if (book.id == null) {
      throw Exception("Book ID cannot be null for update operation.");
    }
    try {
      await database.update(book.toJson()).eq('id', book.id as Object);
    } catch (e) {
      throw Exception("Failed to update book: $e");
    }
  }

  // Update the availability status of a book
  Future<void> updateBookAvailability(int bookId, bool isAvailable) async {
    try {
      await database.update({'is_available': isAvailable}).eq('id', bookId);
    } catch (e) {
      throw Exception("Failed to update book availability: $e");
    }
  }

  // Delete a book from the database
  Future<void> deleteBook(int bookId) async {
    try {
      await database.delete().eq('id', bookId);
    } catch (e) {
      throw Exception("Failed to delete book: $e");
    }
  }
}
