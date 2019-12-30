import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String title = "Error";

  ErrorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String errorMessage = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          errorMessage ?? "Error!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontSize: 40),
        ),
      ),
    );
  }

}
