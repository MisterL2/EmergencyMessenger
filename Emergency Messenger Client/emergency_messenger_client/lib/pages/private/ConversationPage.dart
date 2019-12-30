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
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      double distanceToMaxScroll = _scrollController.position.maxScrollExtent - _scrollController.offset;
      if(distanceToMaxScroll < 10) {
        int messagesToGet = _messages.length + 10; //Fetches 10 additional messages (fetches all messages from local DB every time to ensure consistency (and also its easier to do in SQL))
        _messages = fetchNewestMessages(messagesToGet);
        setState(() {}); //Update UI to reflect this change
      }
    });
  }
  
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
    _messages = fetchNewestMessages(20);

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
        child: ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemCount: _messages.length + 2, //1 Tile for loading icon, 1 Tile for messaging bar
          itemBuilder: (context, index) {
            if (index==0) return _buildMessageBar();

            //Last item = Top of list
            if (index == _messages.length + 1) return Align(child: CircularProgressIndicator());

            //Otherwise, print message
            return _buildMessage(_messages[index-1]);
          }
        ).build(context)
      ),
    );
  }

  List<Message> fetchNewestMessages(int amount) {
    //Get `amount` messages from the local cache for this conversation
    String userCode = _user.userCode;
    print("Fetching new messages!");

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

  Widget _buildMessageBar() {
    print("Building message bar");
    return ListTile(
      contentPadding: EdgeInsets.all(5),
      title:TextField(
        showCursor: true,
        enableSuggestions: true,
        autocorrect: true,
        controller: _controller,
        onSubmitted: _sendMessage,
        decoration: InputDecoration(
          hintText: "Your Message",
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          suffixIcon: Icon(Icons.attach_file),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
      trailing: Padding(
        padding: EdgeInsets.only(right: 10),
        child: FloatingActionButton(
          elevation: 0,
          child: Icon(Icons.send),
          onPressed: () => _sendMessage(_getFieldText()),
        ),
      )
    );
  }

  Widget _buildSendButton() {
    return RaisedButton.icon(
        onPressed: () => _sendMessage(_getFieldText()),
        icon: Icon(Icons.send),
        label: Text(""));
  }

  String _getFieldText() {
    return _controller.text;
  }

  void _sendMessage(String message) {
    int currentUnixTime = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _controller.text = '';
      if(message==null || message.length==0) {
        print("Cannot send empty message, ignore");
        return;
      }

      _messages.insert(0,Message(message,currentUnixTime,true)); //Add to the start of the list

    });

    print("Sending message and unixTime to userCode!");
    print(message);

    //TODO - HTTPS transaction to send out message
    //TODO - Save send-out message in local storage. Mark whether transmission succeeded or not! (If not, keep resending)
  }

  Widget _buildMessage(Message message) {
    return ListTile(
      title: Text(
          message.content,
          style: TextStyle(color: message.isOwnMessage ? Colors.green : Colors.red),
      ),
      trailing: Text(
        "Today 18:00",
        style: TextStyle(color: Colors.grey, fontSize: 6),
      ),
    );
  }
}