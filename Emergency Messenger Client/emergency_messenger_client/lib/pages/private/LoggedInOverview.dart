import 'package:emergency_messenger_client/dataclasses/ConversationHeader.dart';
import 'package:emergency_messenger_client/local_database/DBHandler.dart';
import 'package:emergency_messenger_client/local_database/SQLiteHandler.dart';
import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class LoggedInOverview extends StatefulWidget {
  final String title;

  LoggedInOverview({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoggedInOverviewState();
}

class LoggedInOverviewState extends PrivateState<LoggedInOverview> {
  final List<ConversationHeader> conversationHeaders = [];
  String _password;
  bool loaded = false;

  @override
  Widget buildImpl(BuildContext context, String password) {
    _password = password;

    if(!loaded) {
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
          child: CircularProgressIndicator(),
        ),
      );

    } else {

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
      leading: Icon(Icons.account_circle), //TODO - This will be a randomly generated icon one day
      title: Text(conversationHeader.name),
      subtitle: Text(conversationHeader.mostRecentMessage),
      trailing: conversationHeader.hasUnreadMessage ? Icon(Icons.error, color: Colors.red) : null, //Only show the icon if there are new messages
      onTap: () => _openConversation(conversationHeader.localUserID),
    );
  }

  //Uses all cached messages
  void _generateConversationHeaders() {
    


    DBHandler dbHandler = SQLiteHandler();
    print("Deleting db");
    dbHandler.deleteDB().then((val) {
      //Test data
      
      dbHandler.addUser("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890").then((val) {
        dbHandler.addMessage("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", "TestData message", 1583070543, true).then((val) {
          print("Fetching conversation headers!");
          Future<List<ConversationHeader>> retrievedHeaders = dbHandler.getConversationHeaders();
          retrievedHeaders.then((conversationHeaderList) {
            print("Future completed!");
            conversationHeaders.clear(); //Reset old list
            for(ConversationHeader conversationHeader in conversationHeaderList) {
              conversationHeaders.add(conversationHeader);
            }
            print("Setting state!");
            setState(() {
              loaded=true;
            });

          });
        });
      });

    });


    //Read updated list from cache
//    var example1 = ConversationHeader(1,"Rudolf","Der Schlitten ist fertig",true, false);
//    var example2 = ConversationHeader(2,"Gustav","KFZ Rechnung von 18.03",false, false);
//    var example3 = ConversationHeader(3,"Anabell","Bitte schnell melden, ich hab den Termin wieder komplett vergessen",false, false);
//    conversationHeaders.add(example1);
//    conversationHeaders.add(example2);
//    conversationHeaders.add(example3);
  }

  _redirectToOptionsMenu(BuildContext context) {
    Navigator.of(context).pushNamed("/Options", arguments: <String,Object>{
      "password" : _password,
    });
  }

  _openConversation(int localUserID) {
    Navigator.of(context).pushNamed("/Conversation", arguments: <String,Object>{
      "password" : _password,
      "localUserID" : localUserID,
    });
  }
}