import 'package:flutter/material.dart';

abstract class UnregisteredState<T extends StatefulWidget> extends State<T> {

  @override
  Widget build(BuildContext context) {

    //TODO - Check if there already is an account / local database. Then display an error page

    bool alreadyRegistered = false;

    if(alreadyRegistered) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Already registered"),
        ),
        body: Center(
          child: Text(
            "You are already registered on this device!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 40),
          ),
        ),
      );
    }
    return buildImpl(context);
  }

  Widget buildImpl(BuildContext context); //Only run when a valid password has been entered
}
