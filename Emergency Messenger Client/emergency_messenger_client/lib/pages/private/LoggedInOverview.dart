import 'package:emergency_messenger_client/pages/dataclasses/ConversationHeader.dart';
import 'package:flutter/material.dart';

class LoggedInOverview extends StatefulWidget {
  final String title;
  final List<ConversationHeader> conversationHeaders = [];

  LoggedInOverview({Key key, this.title}) : super(key: key) {
    _generateConversationHeaders();
  }

  @override
  State<StatefulWidget> createState() => LoggedInOverviewState();

  //Uses all cached messages
  void _generateConversationHeaders() {
    var example1 = ConversationHeader("Rudolf","Der Schlitten ist fertig",true);
    var example2 = ConversationHeader("Gustav","KFZ Rechnung von 18.03",false);
    var example3 = ConversationHeader("Anabell","Bitte schnell melden, ich hab den Termin wieder komplett vergessen",false);
    conversationHeaders.add(example1);
    conversationHeaders.add(example2);
    conversationHeaders.add(example3);
  }

}

class LoggedInOverviewState extends State<LoggedInOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your conversations"),
      ),
      body: Center(
        child: _buildMessages(),
      ),
    );
  }

  Widget _buildMessages() {
    print(widget);
  }
//    return ListView.builder(
//        itemBuilder: (context, i) {
//          if(i.isOdd) return Divider();
//          final int index = i ~/ 2;
//          if(index<=widget.conversationHeaders.length) {
//            return _buildMessage(widget.conversationHeaders[index]);
//          }
//          return ListTile();
//        }
//    );
//  }

  ListTile _buildMessage(ConversationHeader conversationHeader) {
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text(conversationHeader.name),
      subtitle: Text(conversationHeader.mostRecentMessage),
      trailing: conversationHeader.hasUnreadMessage ? Icon(Icons.error) : null, //Only show the icon if there are new messages
    );
  }

}