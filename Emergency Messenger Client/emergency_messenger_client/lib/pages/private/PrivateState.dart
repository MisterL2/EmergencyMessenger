import 'package:flutter/material.dart';

//PrivateState is used for all pages that are private/internal (require password to access)
abstract class PrivateState<T extends StatefulWidget> extends State<T> {

  @override
  Widget build(BuildContext context) {
    Map<String,String> arguments = ModalRoute.of(context).settings.arguments;
    if(arguments==null || !arguments.containsKey("password") || arguments['password']==null) {
      return denyPageAccess(context);
    }
    String password = arguments['password'];

    return buildImpl(context, password); //Only run when a valid password has been entered
  }

  Widget denyPageAccess(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forbidden"),
      ),
      body: Center(
        child: Text(
          "You need to log in to view this page!",
          style: TextStyle(color: Colors.red, fontSize: 40),
        ),
      ),
    );
  }

  Widget buildImpl(BuildContext context, String password);
  
}