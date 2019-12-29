import 'dart:html';

import 'package:emergency_messenger_client/dataclasses/Message.dart';
import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {

  ConversationPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConversationPageState();

}

class ConversationPageState extends PrivateState<ConversationPage> {
  String _password;

  @override
  Widget buildImpl(BuildContext context, String password, int deviceID) {
    _password = password;
    Map<String,Object> arguments = ModalRoute.of(context).settings.arguments;
    if(!arguments.containsKey('userCode')) {
      return denyPageAccess(context, alternateText: "Debug: No user found with this userCode! How did this happen?!");
    }

    String userCode = arguments['userCode'];

    if(userCode==null) {
      return denyPageAccess(context, alternateText: "Debug: No user found with this userCode! How did this happen?!");
    }

    String localName = getLocalNameOf(userCode);
    List<Message> messages = fetchNewestMessages(userCode, 10);

    return Scaffold(
      appBar: AppBar(
        title: Text(localName),
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

  String getLocalNameOf(String userCode) {
    //TODO - get locally saved name relating to that userCode from local cache
    return "Heinz";
  }

}