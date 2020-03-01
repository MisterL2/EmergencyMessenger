import 'package:flutter/material.dart';

//PrivateState is used for all pages that are private/internal (require password to access)
abstract class PrivateState<T extends StatefulWidget> extends State<T> {
  String password;

  @override
  Widget build(BuildContext context) {
    if(!passwordValidate(context) || !preValidate(context)) { //No password supplied / Invalid preValidate
      return denyPageAccess(context);
    }

    return buildImpl(context); //Only run when a valid password has been entered. When this method is called, the field 'password' is always set (never null)
  }

  bool passwordValidate(BuildContext context) {
    Map<String,Object> arguments = ModalRoute.of(context).settings.arguments;
    if(arguments==null || !arguments.containsKey("password") || arguments['password']==null) {
      return false;
    }
    password = arguments['password'];

    //    if(!arguments.containsKey("deviceID")) {
    //      return denyPageAccess(context, alternateText: "Debug: No device ID!");
    //    }
    //    int deviceID = arguments['deviceID'];

    return true;
  }

  Widget denyPageAccess(BuildContext context, {alternateText}) { //Builds an error page instead of the real page. Redirecting is NOT POSSIBLE while building a widget!
    return Scaffold(
      appBar: AppBar(
        title: Text("Forbidden"),
      ),
      body: Center(
        child: Text(
          alternateText ?? "You need to log in to view this page!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontSize: 40),
          ),
      ),
    );
  }

  Widget buildImpl(BuildContext context);

  bool preValidate(BuildContext context);


  
}