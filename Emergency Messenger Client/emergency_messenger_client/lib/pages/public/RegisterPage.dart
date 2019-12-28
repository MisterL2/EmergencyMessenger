
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final String title;
  final int maxPasswordLength = 60;
  final int minPasswordLength = 8;

  RegisterPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RegisterPageState();

}

class RegisterPageState extends State<RegisterPage> {
  final passwordFieldController = TextEditingController();
  bool error = false;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: Column(
          children: [
            Center(
//              widthFactor: 0.8,
              child:
                Text(
                "Important info before you register",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24).apply(fontSizeFactor: 2.0),
              ),
            ),
//            FractionallySizedBox(
//              widthFactor: 0.8,
//              child:
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 20),
              child: RichText(
                strutStyle: StrutStyle(height: 1.5),
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  text: "1. Once you register, your account will work ",
                  children: [
                    TextSpan(
                      text: "on this device only.\n",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "2. If you already have an account and want to connect a new device to your account, go back and select ",
                    ),
                    TextSpan(
                      text: "Add new device.\n",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    TextSpan(
                      text: "3. You can have a ",
                    ),
                    TextSpan(
                      text: "maximum of 5 devices ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "for an account.\n",
                    ),
                    TextSpan(
                      text: "4. Your password grants you access on all your devices. Remember and protect it well, there is (currently) ",
                    ),
                    TextSpan(
                      text: "no way to reset or recover it.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),

//            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                    "How to register",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24).apply(fontSizeFactor: 2.0)),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                  "1. Choose a strong password (min 8 characters) and enter it into the box below.\n"
                  "2. Press submit.\n"
                  "3. Congratulations! You are registered!"),
            ),

            FractionallySizedBox(
              widthFactor: 0.5,
              child: TextField(
                obscureText: true,
                showCursor: false,
                autocorrect: false,
                enableSuggestions: false,
                maxLength: 60,
                maxLengthEnforced: true,
//                autofocus: true, //Causes a crash, see github bug report
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                  errorText: error ? errorMessage : null,
                ),
                controller: passwordFieldController,
                onSubmitted: _register,
              ),
            ),
          ],
        ),
      );
  }


  void _register(String password) {
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

    //Create personal private key

    //Make HTTP call with public key and the desired password encrypted with private key (so it can be decrypted with public key, confirming authenticity and ownership of private key)

    //Receive user_id ? and device_id is kinda unnecessary for registration, it is always 1

    //Set up local storage to save this data

    //Display success message
    _successRedirect();
  }


  void _successRedirect() {
    Navigator.of(context).pushNamedAndRemoveUntil("/Success", ModalRoute.withName("/"), arguments: "Successfully registered!");
  }
}