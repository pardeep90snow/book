import 'package:book_system/app_binding/app_binding.dart';
import 'package:book_system/screen/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BookFinderApp());
}

class BookFinderApp extends StatelessWidget {
  const BookFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BookFinder',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      home: const MainPage(),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
    );
  }
}
