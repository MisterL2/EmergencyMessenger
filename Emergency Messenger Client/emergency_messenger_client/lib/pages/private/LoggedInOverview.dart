import 'package:emergency_messenger_client/dataclasses/ConversationHeader.dart';
import 'package:emergency_messenger_client/dataclasses/UserCode.dart';
import 'package:emergency_messenger_client/local_database/DBHandler.dart';
import 'package:emergency_messenger_client/pages/private/DynamicPrivateState.dart';
import 'package:flutter/material.dart';

class LoggedInOverview extends StatefulWidget {
  final String title;

  LoggedInOverview({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoggedInOverviewState();
}

class LoggedInOverviewState extends DynamicPrivateState<LoggedInOverview> {
  final List<ConversationHeader> conversationHeaders = [];
  bool loaded = false;

  @override
  Widget buildImpl(BuildContext context) {

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
      leading: Icon(Icons.account_circle), //TODO - This will be a randomly generated icon one day
      title: Text(conversationHeader.name),
      subtitle: Text(conversationHeader.mostRecentMessage),
      trailing: conversationHeader.hasUnreadMessage ? Icon(Icons.error, color: Colors.red) : null, //Only show the icon if there are new messages
      onTap: () => _openConversation(conversationHeader.localUserID),
    );
  }


  _redirectToOptionsMenu(BuildContext context) {
    Navigator.of(context).pushNamed("/Options", arguments: <String,Object>{
      "password" : password,
    });
  }

  _openConversation(int localUserID) {
    Navigator.of(context).pushNamed("/Conversation", arguments: <String,Object>{
      "password" : password,
      "localUserID" : localUserID,
    });
  }

  @override
  Widget displayLoadingPage() {
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
  }

  @override
  Future<void> loadDynamicContent() async {
    DBHandler dbHandler = DBHandler.getDBHandler();
    print("Deleting db");
    await dbHandler.deleteDB();


    //Test data
    print("Adding test data!");
    await dbHandler.addUser(UserCode("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"));
    await dbHandler.addMessage(1, "TestData message 1", 1583070543000, true);
    await dbHandler.addMessage(1, "TestData message 11", 1583070544000, true);
    await dbHandler.addMessage(1, "TestData message 12", 1583070545000, true);
//    await dbHandler.addMessage(1, "TestData message 13", 1583070546000, true);
//    await dbHandler.addMessage(1, "TestData message 14", 1583070547000, true);
//    await dbHandler.addMessage(1, "TestData message 15", 1583070548000, true);
//    await dbHandler.addMessage(1, "TestData message 16", 1583070549000, true);
//    await dbHandler.addMessage(1, "TestData message 17", 1583070553000, false);
//    await dbHandler.addMessage(1, "TestData message 18", 1583070573000, false);
//    await dbHandler.addMessage(1, "TestData message 19", 1583070503000, true);
//    await dbHandler.addMessage(1, "TestData message 20", 1583070143000, true);
    await dbHandler.addMessage(1, "TestData message 21", 1583050543000, true);
    await dbHandler.addMessage(1, "TestData message 22", 1533070543000, false);
    await dbHandler.addMessage(1, "TestData message 23", 1283070543000, false);
    await dbHandler.addMessage(1, "TestData message 24", 1583270543000, true);
    await dbHandler.addMessage(1, "TestData message 25", 1582870543000, true);

    await dbHandler.addUser(UserCode("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567891"));
    await dbHandler.addMessage(2, "TestData message 2", 1583070543000, true);

    await dbHandler.addUser(UserCode("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567892"));
    await dbHandler.addMessage(3, "TestData message 3", 1583070543000, true);

    await dbHandler.addUser(UserCode("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567893"));
    await dbHandler.addMessage(4, "Outgoing message 4", 1583070543000, false);

    await dbHandler.addUser(UserCode("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567894"));
    await dbHandler.addMessage(5, "TestData message 5", 1583070543000, true);

    await dbHandler.addUser(UserCode("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567895"));
    await dbHandler.addMessage(6, "TestData message 6", 1583070543000, true);

    await dbHandler.addUser(UserCode("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567896"));
    await dbHandler.addMessage(7, "TestData message 7", 1583070543000, false);

    await dbHandler.addUser(UserCode("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567897"));
    await dbHandler.addMessage(8, "TestData message 8", 1583070543000, true);

    await dbHandler.addUser(UserCode("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567898"));
    await dbHandler.addMessage(9, "TestData message 9", 1583070543000, false);

    await dbHandler.addUser(UserCode("1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567899"));
    await dbHandler.addMessage(10, "TestData message 10", 1583070543000, true);
    //End of Test data

    List<ConversationHeader> retrievedHeaders = await dbHandler.getConversationHeaders();
    conversationHeaders.clear(); //Reset old list
    for(ConversationHeader conversationHeader in retrievedHeaders) {
      conversationHeaders.add(conversationHeader);
    }




    //Read updated list from cache
//    var example1 = ConversationHeader(1,"Rudolf","Der Schlitten ist fertig",true, false);
//    var example2 = ConversationHeader(2,"Gustav","KFZ Rechnung von 18.03",false, false);
//    var example3 = ConversationHeader(3,"Anabell","Bitte schnell melden, ich hab den Termin wieder komplett vergessen",false, false);
//    conversationHeaders.add(example1);
//    conversationHeaders.add(example2);
//    conversationHeaders.add(example3);
  }

  @override
  bool preValidate(BuildContext context) {
    return true;
  }
}