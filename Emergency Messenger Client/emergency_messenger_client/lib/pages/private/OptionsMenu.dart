import 'package:flutter/material.dart';

class OptionsMenu extends StatefulWidget {
  final String title = "Options";

  OptionsMenu({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OptionsMenuState();

}

class OptionsMenuState extends State<OptionsMenu> {
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