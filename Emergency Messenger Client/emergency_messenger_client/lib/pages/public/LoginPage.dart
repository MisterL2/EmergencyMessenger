import 'package:emergency_messenger_client/pages/private/LoggedInOverview.dart';
import 'package:emergency_messenger_client/utilities/SecureRandomiser.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final String title = "Login";
  final int maxPasswordLength = 60;
  final int minPasswordLength = 8;

  LoginPage({Key key}) : super(key: key);


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final passwordFieldController = TextEditingController();
  bool error = false;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Log in:',
                style: Theme
                    .of(context)
                    .textTheme
                    .display1,
              ),
            ),

            FractionallySizedBox(
              widthFactor: 0.5,
              child: TextField(
                focusNode: FocusNode(),
                obscureText: true,
                showCursor: false,
                autocorrect: false,
                enableSuggestions: false,
                maxLength: widget.maxPasswordLength,
                maxLengthEnforced: true,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                  errorText: error ? errorMessage : null,
                ),
                controller: passwordFieldController,
                onSubmitted: _submitPassword,
              ),
            ),
//            Container(
//              margin: EdgeInsets.only(top: error ? 30 : 0),
//              child: Text(
//                error ? errorMessage : '',
//                style: TextStyle(fontSize: 16.0, color: Colors.red),
//              )
//            )
          ],
        ),
      ),
    );
  }

  void _submitPassword(String password) {
    if (password.length < widget.minPasswordLength) {
      setState(() {
        passwordFieldController.text = '';
        error = true;
        errorMessage = "Password entered is too short (min 8 characters)";
      });
      return;
    }
    if (password.length > widget.maxPasswordLength) {
      setState(() {
        passwordFieldController.text = '';
        error = true;
        errorMessage = "Password entered is too long (max 60 characters)\nThis error should not have been thrown, please contact the developer immediately!";
      });
      return;
    }

    //If password seems valid at first glance, start communicating with backend

    //Generate a token
    String token = SecureRandomiser.generateRandomString(15);
    //Encrypt the password + token, using the private key
    String toBeEncrypted = token + password;
    print(toBeEncrypted);
    //TODO - encrypt

    //Send both the token and the encrypted (password+token) combination to the backend
    //TODO - send HTTPS request

    //Evaluate the result of the HTTPS request
    //TODO - evaluate HTTPS response

    //Set State depending on what happened and return. DO NOT delete the password in this case (terrible user experience if it resets the pw field for every connection issue)
    bool connectionIssue = false;
    if (connectionIssue) {
      setState(() {
        error = true;
        errorMessage = "Some Connection issue!";
      });
      return;
    }
    if (password == "password") { //TODO - Remove this temporary if-statement and replace it based on https response
      //Reset page state properly, in case user ever comes back to it
      int deviceID = 1; //TODO - Received from HTTPS Reponse
      setState(() {
        passwordFieldController.text = '';
        error = false;
        errorMessage = null;
      });

      //Now redirect to logged-in page
      Navigator.of(context).pushNamed("/Messages", arguments: <String,Object>{
        "password" : password,
        "deviceID" : 1,
      });
    }
  }
}