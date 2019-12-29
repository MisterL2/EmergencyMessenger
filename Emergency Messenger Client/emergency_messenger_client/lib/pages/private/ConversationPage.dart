import 'package:emergency_messenger_client/dataclasses/Message.dart';
import 'package:emergency_messenger_client/dataclasses/User.dart';
import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {

  ConversationPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConversationPageState();

}

class ConversationPageState extends PrivateState<ConversationPage> {
  String _password;
  User _user;

  @override
  Widget buildImpl(BuildContext context, String password) {
    _password = password;
    Map<String,Object> arguments = ModalRoute.of(context).settings.arguments;
    if(!arguments.containsKey('userCode')) {
      return denyPageAccess(context, alternateText: "Debug: No user found with this userCode! How did this happen?!");
    }

    String userCode = arguments['userCode'];

    if(userCode==null) {
      return denyPageAccess(context, alternateText: "Debug: No user found with this userCode! How did this happen?!");
    }

    _user = getUserOf(userCode);
    List<Message> messages = fetchNewestMessages(userCode, 10);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Icon(Icons.account_circle), //TODO - This will be a randomly generated icon one day
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(_user.localAlias),
            )

          ],
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.person), onPressed: () => _changeAlias(context)), //Change the locally saved name mapped to that userCode
          _user.isBlocked
              ? IconButton(icon: Icon(Icons.check), onPressed: () => _unBlock(context))
              : IconButton(icon: Icon(Icons.block), onPressed: () => _block(context)),
        ],
      ),
      body: Center(
        child: Text(""),
      ),
    );
  }

  List<Message> fetchNewestMessages(String userCode, int amount) {
    //Get `amount` messages from the local cache for this conversation
    print(userCode);

    //The below 3 TODO-s should be done in 1 SQL query

    //TODO - Fetch *amount* most recent messages for userCode from the local cache
    //TODO - Fetch *amount* most recent messages from SELF going TO userCode from the local cache
    //TODO - Find the *amount* most recent messages from the two lists just generated, and sort them by "most recent"
    return [];
  }

  User getUserOf(String userCode) {
    //TODO - get locally saved name relating to that userCode from local cache
    return User("Heinz", userCode, false);
  }

  _changeAlias(BuildContext context) {
    print("Popup with ability to enter a new name?");
  }

  _block(BuildContext context) { //Blocks a user
    print("Sending out an HTTP request to mark user as blocked on Server || OR || Locally adding user to a block-list"); //Not sure which one is better, but probably Local
  }

  _unBlock(BuildContext context) {
    print("Sending out an HTTP request to mark user as UNblocked on Server || OR || Locally removing user to a block-list"); //Not sure which one is better, but probably Local
  }

}