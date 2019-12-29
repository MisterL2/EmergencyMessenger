import 'package:emergency_messenger_client/dataclasses/ConversationHeader.dart';
import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:flutter/material.dart';

class LoggedInOverview extends StatefulWidget {
  final String title;

  LoggedInOverview({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoggedInOverviewState();
}

class LoggedInOverviewState extends PrivateState<LoggedInOverview> {
  final List<ConversationHeader> conversationHeaders = [];
  String _password;

  @override
  Widget buildImpl(BuildContext context, String password) {
    _password = password;

    //TODO - Use password to decrypt/access local storage
    _generateConversationHeaders();


    return Scaffold(
      appBar: AppBar(
        title: Text("Your conversations"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: () => _redirectToOptionsMenu(context)),
        ],
      ),
      body: Center(
        child: _buildMessages(),
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
        itemBuilder: (context, i) {
          final int index = i;
          if(index<conversationHeaders.length) {
            return _buildMessage(conversationHeaders[index]);
          }
          return null;
        }
    );
  }

  ListTile _buildMessage(ConversationHeader conversationHeader) {
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text(conversationHeader.name),
      subtitle: Text(conversationHeader.mostRecentMessage),
      trailing: conversationHeader.hasUnreadMessage ? Icon(Icons.error, color: Colors.red) : null, //Only show the icon if there are new messages
      onTap: () => _openConversation(conversationHeader.userCode),
    );
  }

  //Uses all cached messages
  void _generateConversationHeaders() {
    //Reset old list
    conversationHeaders.clear();

    //Read updated list from cache
    var example1 = ConversationHeader("userCode","Rudolf","Der Schlitten ist fertig",true);
    var example2 = ConversationHeader("userCode","Gustav","KFZ Rechnung von 18.03",false);
    var example3 = ConversationHeader("userCode","Anabell","Bitte schnell melden, ich hab den Termin wieder komplett vergessen",false);
    conversationHeaders.add(example1);
    conversationHeaders.add(example2);
    conversationHeaders.add(example3);
  }

  _redirectToOptionsMenu(BuildContext context) {
    Navigator.of(context).pushNamed("/Options", arguments: <String,Object>{
      "password" : _password,
    });
  }

  _openConversation(String userCode) {
    Navigator.of(context).pushNamed("/Conversation", arguments: <String,Object>{
      "password" : _password,
      "userCode" : userCode,
    });
  }
}