
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
            _buildTitle(),
            _buildInfo(),
            _buildSubTitle(),
            _buildInstructions(),
            _buildPasswordField(),
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


  Widget _buildTitle() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: FittedBox(fit: BoxFit.scaleDown,
          child: Text(
            "Important info before you register",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 999999999),
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: FittedBox(fit: BoxFit.contain,
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
            children: [
              _buildText("1. Once you register, your account will work "),
              _buildText("on this device only.", fontWeight: FontWeight.bold),
            ]
          ),
            Row(
                children: [
                  _buildText("2. If you already have an account and want to connect a new device to your account, go back and select "),
                  _buildText("Add new device.", fontStyle: FontStyle.italic),
                ]
            ),
            Row(
                children: [
                  _buildText("3. You can have a "),
                  _buildText("maximum of 5 devices ", fontWeight: FontWeight.bold),
                  _buildText("for an account."),
                ]
            ),
            Row(
                children: [
                  _buildText("4. Your password grants you access on all your devices."),

                ]
            ),
            Row(
              children: <Widget>[
                _buildText("Remember and protect it well, there is (currently) "),
                _buildText("no way to reset or recover it.", fontWeight: FontWeight.bold),
              ],
            )
      ],
        ),
      ),
    ),
    );

  }

  Widget _buildSubTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Text(
          "How to register",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24).apply(fontSizeFactor: 2.0)),
    );
  }

  Widget _buildInstructions() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Text(
          "1. Choose a strong password (min 8 characters) and enter it into the box below.\n"
              "2. Press submit.\n"
              "3. Congratulations! You are registered!"),
    );
  }

  Widget _buildPasswordField() {
    return FractionallySizedBox(
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
    );
  }

  Text _buildText(String data, {fontWeight, fontStyle}) {
    return Text(
      data,
      style: TextStyle(color: Colors.black, fontWeight: fontWeight ?? FontWeight.normal, fontStyle: fontStyle ?? FontStyle.normal, fontSize: 20),
      textAlign: TextAlign.left,
    );
  }
}