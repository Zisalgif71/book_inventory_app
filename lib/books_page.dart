import 'package:flutter/material.dart';
import 'package:books/book.dart';
import 'package:books/book_database.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final textController = TextEditingController();
  final authorController = TextEditingController();
  final dateController = TextEditingController();
  final _bookDatabase = BookDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Inventory'),
      ),
      body: StreamBuilder(
        stream: _bookDatabase.getBooksStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!;

          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('No books found'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: addNewBook,
                    child: const Text('Add New Book'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: books.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, indent: 10),
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text(
                    "Author: ${book.author}\nPublished: ${book.publishedDate?.toIso8601String() ?? "N/A"}"),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => editBook(book),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => deleteBook(book),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
                leading: GestureDetector(
                  onTap: () => toggleAvailability(book),
                  child: Icon(
                    book.isAvailable ? Icons.check_circle : Icons.cancel,
                    color: book.isAvailable ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBook,
        child: const Icon(Icons.add),
      ),
    );
  }

  void addNewBook() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Book'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                  labelText: 'Published Date (YYYY-MM-DD)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final book = Book(
                title: textController.text,
                author: authorController.text,
                publishedDate: DateTime.tryParse(dateController.text),
                isAvailable: true,
              );

              _bookDatabase.insertBook(book);

              Navigator.pop(context);
              textController.clear();
              authorController.clear();
              dateController.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void editBook(Book book) {
    textController.text = book.title;
    authorController.text = book.author;
    dateController.text = book.publishedDate?.toIso8601String() ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Book'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                  labelText: 'Published Date (YYYY-MM-DD)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              book.title = textController.text;
              book.author = authorController.text;
              book.publishedDate = DateTime.tryParse(dateController.text);

              _bookDatabase.updateBook(book);

              Navigator.pop(context);
              textController.clear();
              authorController.clear();
              dateController.clear();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
              authorController.clear();
              dateController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void deleteBook(Book book) {
    if (book.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Book ID is null.')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Book"),
        content: Text("Title: \"${book.title}\""),
        actions: [
          TextButton(
            onPressed: () {
              _bookDatabase.deleteBook(book.id!);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void toggleAvailability(Book book) {
    if (book.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Book ID is null.')),
      );
      return;
    }
    _bookDatabase.updateBookAvailability(book.id!, !book.isAvailable);
  }
}
