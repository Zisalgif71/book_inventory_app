import 'package:books/books_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  //Setup Supabase
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://iwtskqzmnktzyisvhcpm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml3dHNrcXptbmt0enlpc3ZoY3BtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY2NTA3NTgsImV4cCI6MjA1MjIyNjc1OH0.gWtiQrO9BFWU-yrIln52oCE4jISbzOM9k9QDYP7jIIA',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BooksPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
