import 'dart:async';

import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:emergency_messenger_client/utilities/SecureRandomiser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddUserPage extends StatefulWidget {
  final String title = "Add another user";

  AddUserPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddUserPageState();
}

class AddUserPageState extends PrivateState<AddUserPage> {
  String _numberCode; //Only contains numbers, but is not an int as it needs leading 0s
  TextEditingController _generatedNumberController = TextEditingController();
  TextEditingController _timerFieldController = TextEditingController();
  TextEditingController _addUserFieldController = TextEditingController();
  int _codeValidForSeconds;

  bool addUserError = false;
  String addUserErrorMessage;


  @override
  Widget buildImpl(BuildContext context, String password) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
            "Add another user using their connection code",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
          Padding(
            padding: EdgeInsets.all(5),
            child: _buildAddUserRow(),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: _buildGenerateCodeRow(),
          ),
        ],
      ),
    );
  }

  String _generateNumberCodeAndInformServer() {
    _numberCode = SecureRandomiser.generateRandomString(9, alphabet: "0123456789");
    _generatedNumberController.text = _numberCode;
    _codeValidForSeconds = 60;
    _timerFieldController.text = _codeValidForSeconds.toString(); //Set the initial value before the timer starts
    Timer.periodic(Duration(seconds: 1), (timer) {
      _codeValidForSeconds-=1;
      _timerFieldController.text = _codeValidForSeconds.toString();
      if(_codeValidForSeconds<=0) {
        timer.cancel();
        _generatedNumberController.text = '';
        _timerFieldController.text = '';
        _numberCode = null; //Reset the generated number code (as it is now invalid). This will also enable the "Generate Code" button again
        setState(() {}); //Update UI, so that the button actually enables again
      }
    });

    //TODO - inform server

    setState(() {}); //Update UI
    return _numberCode;
  }

  void _addUser() {
    if(_addUserFieldController.text.length!=9) { //UserCode of incorrect length
      setState(() {
        addUserError = true;
        addUserErrorMessage = "Invalid code! (Should be 9 numbers long)";
        //Does not clear field
      }); //Update UI
      return;
    } else {
      print("Attempting to add user!");

      //TODO - Connect to server and retrieve values for that code

      bool unableToConnect = false;

      if(unableToConnect) {
        setState(() {
          addUserError = true;
          addUserErrorMessage = 'Unable to connect to server...';
        });
        return;
      }

      bool serverConfirmsCodeIsCorrect = true;

      if(serverConfirmsCodeIsCorrect) {
        final SnackBar snackBar = SnackBar(
          content: Text("User was successfully added!"),
        );

        print("Successfully added user!");
        Scaffold.of(context).showSnackBar(snackBar);
        setState(() {

          addUserError = false;
          addUserErrorMessage = '';
          _addUserFieldController.text = ''; //Reset field after successful add
        });
      } else {
        setState(() {
          addUserError = true;
          addUserErrorMessage = 'Invalid code! (Code expired or never existed)';
        });
      }
    }

  }

  Widget _buildAddUserRow() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: TextField(
            decoration: InputDecoration(
                errorText: addUserError ? addUserErrorMessage : null,
                hintText: "Enter code",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                )
            ),
            controller: _addUserFieldController,
            keyboardType: TextInputType.number,
            maxLength: 9,
            maxLengthEnforced: true,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
          ),
        ),
        Expanded(
          child: FloatingActionButton(
            elevation: 0,
            onPressed: _addUser,
            child: Text(
              "Add",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateCodeRow() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 3),
              child: _buildGenerateCodeButton(),
            )
        ),
        Expanded(
          flex: 6,
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: _buildGenerateCodeDisplayField(),
          ),
        ),
        Expanded(
          child: _buildGenerateCodeTimer(),
        ),
      ],
    );
  }

  Widget _buildGenerateCodeButton() {
    return FlatButton(
      child: Text(
        "Generate code",
        style: TextStyle(color: Colors.white),
      ),
      disabledColor: Colors.grey,
      color: Colors.blue,
      onPressed: _numberCode == null
          ? _generateNumberCodeAndInformServer
          : null, //If a code has already been generated, disable the button
    );
  }

  Widget _buildGenerateCodeDisplayField() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        fillColor: Colors.grey,
      ),
      readOnly: true,
      controller: _generatedNumberController,
    );
  }



  Widget _buildGenerateCodeTimer() {
    return TextField(
      controller: _timerFieldController,
      readOnly: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        fillColor: Colors.red,
      ),
    );
  }
}
