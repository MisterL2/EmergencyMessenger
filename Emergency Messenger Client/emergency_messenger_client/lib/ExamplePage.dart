import 'package:flutter/material.dart';

class ExamplePage extends StatefulWidget {
  final String title = "Example Page";

  ExamplePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ExamplePageState();

}

class ExamplePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text("Hello World"),
      ),
    );
  }

}