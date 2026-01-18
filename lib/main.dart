import 'package:flutter/material.dart';
import 'dart:ui';                        // Rect, TextDirection, Locale
import 'package:flutter/foundation.dart'; // VoidCallback
import 'package:flutter/semantics.dart';  // SemanticsRole, SemanticsAction, SemanticsFlag, SemanticsValidationResult, SemanticsInputType
import 'package:flutter/services.dart';   // TextSelection


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text("Recipe App")),
        body: Center(child: Text("Hello, Flutter!")),
      ), 
    );}
}
