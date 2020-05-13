import 'package:flutter/material.dart';
import 'package:uvindex/screen/home_page.dart';

void main() => runApp(UVIndexApp());

class UVIndexApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
