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

  bool _addUserError = false;
  String _addUserErrorMessage;

  Size _size;

  @override
  Widget buildImpl(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) {
          return Column(
            children: <Widget>[
              _buildHeading("Add another user using their connection code", _size.height*0.05, _size.height*0.05),

              FractionallySizedBox(
                widthFactor: 0.6,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: _buildAddUserRow(context), //Need to pass the builder-context, because that is a child of Scaffold and that is needed for the SnackBar. Otherwise it uses the default context (which contains a Scaffold, but is not a child of it) and crashes horribly :(
                ),
              ),


              _buildHeading("Generate a code for other users to add you", _size.height*0.075, _size.height*0.05),


              Padding(
                padding: EdgeInsets.all(5),
                child: _buildGenerateCodeRow(),
              ),

            ],
          );
        },
      )
          );
  }

  String _generateNumberCodeAndInformServer() {
    _numberCode = SecureRandomiser.generateRandomString(9, alphabet: "0123456789");
    _generatedNumberController.text = _numberCode.substring(0,3) + " " + _numberCode.substring(3,6) + " " + _numberCode.substring(6); //Only the text has the spaces for visual separation, the _numberCode variable remains a valid number
    _codeValidForSeconds = 60;
    _timerFieldController.text = _codeValidForSeconds.toString(); //Set the initial value before the timer starts
    Timer.periodic(Duration(seconds: 1), (timer) {
      _codeValidForSeconds-=1;
      _timerFieldController.text = _codeValidForSeconds.toString();
      if(_codeValidForSeconds<=0) {
        timer.cancel();
        setState(() {
          _numberCode = null; //Reset the generated number code (as it is now invalid). This will also enable the "Generate Code" button again
          _generatedNumberController.text = '';
          _timerFieldController.text = '';
        }); //Update UI, so that the button actually enables again
      }
    });

    //TODO - inform server

    setState(() {}); //Update UI
    return _numberCode;
  }

  void _addUser(BuildContext context) {
    if(_addUserFieldController.text.length!=9) { //UserCode of incorrect length
      setState(() {
        _addUserError = true;
        _addUserErrorMessage = "Invalid code! (Should be 9 numbers long)";
        //Does not clear field
      }); //Update UI
      return;
    } else {

      print("Attempting to add user!");

      //TODO - Connect to server and retrieve values for that code

      bool unableToConnect = false;

      if(unableToConnect) {
        setState(() {
          _addUserError = true;
          _addUserErrorMessage = 'Unable to connect to server...';
        });
        return;
      }

      bool serverConfirmsCodeIsCorrect = true;

      if(serverConfirmsCodeIsCorrect) {

        Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("User has been successfully added!"),
              behavior: SnackBarBehavior.floating,
              elevation: 2,
              onVisible: () => print("TODO - Play a success-sound when snackbar shows!"), //TODO - Play sound when SnackBar shows ("Success" or "Ding")
        ));

        setState(() {
          _addUserError = false;
          _addUserErrorMessage = '';
          _addUserFieldController.text = ''; //Reset field after successful add
        });
      } else {
        setState(() {
          _addUserError = true;
          _addUserErrorMessage = 'Invalid code! (Code expired or never existed)';
        });
      }
    }

  }

  Widget _buildAddUserRow(BuildContext context) {
    return Row(
        children: <Widget>[
        Expanded(
        flex: 4,
        child: TextField(
          decoration: InputDecoration(
              errorText: _addUserError ? _addUserErrorMessage : null,
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
        child: Padding(
          padding: EdgeInsets.only(left: 5, bottom: 20),
          child: FloatingActionButton(
            elevation: 0,
            hoverElevation: 0,
            onPressed: () => _addUser(context),
            child: Text(
              "Add",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ],
    );
  }

  Widget _buildGenerateCodeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 140,
          height: 60,
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 3),
            child: _buildGenerateCodeButton(),
          ),
        ),

        SizedBox(
          width: 130,
          child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: _buildGenerateCodeDisplayField(),
          ),
        ),

        SizedBox(
          width: 50,
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


  Widget _buildHeading(String text, double paddingTop, double paddingBottom) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 8 + _size.width/40,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  bool preValidate(BuildContext context) {
    return true;
  }


}
