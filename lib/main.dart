import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'NGO',
      home: Scaffold(
        appBar: AppBar(
          title: Text('GO NGO'),
        ),
        body: Center(
          child: Text('This is dollar good'),
        ),
      ),
    );
  }
}
