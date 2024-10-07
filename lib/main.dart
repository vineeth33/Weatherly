import 'package:flutter/material.dart';
import 'package:weather_flutter_finalapp/pages/home_page.dart'; // Assuming HomePage is in pages folder

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App', // More descriptive title
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use primarySwatch for consistent color scheme
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      // Remove the body property as you have a home property set
      home: const HomePage(),
    );
  }
}
