import 'package:emergency_messenger_client/dataclasses/Message.dart';
import 'package:emergency_messenger_client/dataclasses/User.dart';
import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:emergency_messenger_client/utilities/UnixTimeStringGenerator.dart';
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
  UnixTimeStringGenerator _unixTimeStringGenerator = UnixTimeStringGenerator();

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
              ? IconButton(icon: Icon(Icons.check), onPressed: () => _unBlockPopup(context))
              : IconButton(icon: Icon(Icons.block), onPressed: () => _blockPopup(context)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ListView.builder(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            shrinkWrap: true,
            controller: _scrollController,
            itemExtent: 40,
            reverse: true,
            itemCount: _messages.length + 1, //1 Tile for the loading icon
            itemBuilder: (context, index) {

              //Last item = Top of list
              if (index == _messages.length) return Align(child: CircularProgressIndicator());

              //Otherwise, print message
              return _buildMessage(_messages[index]);
            }
          ).build(context),
          _buildMessageBar(),
        ],
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
    return [
      Message("Hallo Jürgen, wie gehts?",123,false),
      Message("Moinsen, gut!",1551809581000,true),
//      Message("Mehrzeilige\nNachricht\nyey",456,false),
      Message("Was gibt's?",1577461396000,true),
      Message("Ich hab schon wieder diesen Termin vergessen...",1577734285000,false),
//      Message("Extreeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeem lange Nachricht                             d        Ich hab schon wieder diesen Termin vergessen...",456,false),
    ].reversed.toList();
  }

  User getUserOf(String userCode) {
    //TODO - get locally saved name relating to that userCode from local cache
    return User("Heinz", userCode, false);
  }

  _changeAlias(BuildContext context) {
    print("Popup with ability to enter a new name?");
  }

  _blockPopup(BuildContext context) { //Blocks a user
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Block " + _user.localAlias + "?"),
        content: Text("Blocking " + _user.localAlias + " will make it impossible for them to contact you!"),
        actions: <Widget>[
          FlatButton(
            child: Text("Block"),
            onPressed: _block,
          ),
          FlatButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(), //Closes popup
          ),
        ],
      ),
    );
  }

  _block() {
    Navigator.of(context).pop(); //Close popup
    print("Sending out an HTTP request to mark user as blocked on Server"); //Local blocking in the app does not work properly as it exhausts the quota for FCM (Firebase Cloud Messaging) messages. Also, you could DDOS users silently with spam messages if they blocked you.
  }

  _unBlockPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Unblock " + _user.localAlias + "?"),
        content: Text("Unblocking " + _user.localAlias + " will allow them to contact you again!"),
        actions: <Widget>[
          FlatButton(
            child: Text("Unblock"),
            onPressed: _unblock,
          ),
          FlatButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(), //Closes popup
          ),
        ],
      ),
    );
  }

  _unblock() {
    Navigator.of(context).pop(); //Close popup
    print("Sending out an HTTP request to mark user as unblocked on Server"); //Local blocking in the app does not work properly as it exhausts the quota for FCM (Firebase Cloud Messaging) messages. Also, you could DDOS users silently with spam messages if they blocked you.
  }

  Widget _buildMessageBar() {
    print("Building message bar");
    return ListTile(
      contentPadding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      title: TextField(
        showCursor: true,
        cursorColor: Colors.black,
        cursorWidth: 1.5,
        enableSuggestions: true,
        autocorrect: true,
        controller: _controller,
        onSubmitted: _sendMessage,
        decoration: InputDecoration(
          hintText: "Your Message",
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          fillColor: Colors.white,
          filled: true,

          suffixIcon: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(Icons.attach_file, color: Colors.black,),
            onPressed: () => print("Opening 'Attach File' window!"),
            heroTag: null,
          ),
        ),
      ),
      trailing: FloatingActionButton(
        elevation: 0,
        onPressed: () => _sendMessage(_getFieldText()),
        child: Icon(Icons.send),
        heroTag: null,
      ),
    );
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
      title: RichText(
        textAlign: message.isOwnMessage ? TextAlign.right : TextAlign.left,

        text: TextSpan(
          text: message.content,
          style: TextStyle(color: message.isOwnMessage ? Colors.green : Colors.red),
          children: <InlineSpan>[
            TextSpan(
              text: "  " + _unixTimeStringGenerator.generateTimeStringOf(message.unixTimestamp),
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ]
        ),

      ),
    );
  }
}