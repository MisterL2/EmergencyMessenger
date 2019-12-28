import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final String title = "Success";

  SuccessPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String successMessage = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          successMessage ?? "Success!",
          style: TextStyle(color: Colors.green, fontSize: 40),
        ),
      ),
    );
  }

}
