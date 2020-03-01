import 'package:emergency_messenger_client/dataclasses/Message.dart';
import 'package:emergency_messenger_client/dataclasses/User.dart';
import 'package:emergency_messenger_client/local_database/DBHandler.dart';
import 'package:emergency_messenger_client/pages/private/DynamicPrivateState.dart';
import 'package:emergency_messenger_client/utilities/UnixTimeStringGenerator.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {

  ConversationPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConversationPageState();

}

class ConversationPageState extends DynamicPrivateState<ConversationPage> {
  int _conversationPartnerID;
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
        //TODO - Determine when the top is reached and there are no further messages to load!
        _messages = await fetchNewestMessages(messagesToGet);
        setState(() {}); //Update UI to reflect this change
      }
    });
  }
  
  @override
  Widget buildImpl(BuildContext context) {
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

  Future<List<Message>> fetchNewestMessages(int amount) async {
    //Get `amount` messages from the local cache for this conversation
    DBHandler dbHandler = DBHandler.getDBHandler();
    _user = await dbHandler.getUser(_conversationPartnerID);

    //Fetches the *amount* most recent messages for the given localUserID from the local cache
    return dbHandler.fetchMessages(_conversationPartnerID, amount);

//    return [
//      Message("Hallo Jürgen, wie gehts?",123,false,false),
//      Message("Moinsen, gut!",1551809581000,true,false),
////      Message("Mehrzeilige\nNachricht\nyey",456,false),
//      Message("Was gibt's?",1577461396000,true,false),
//      Message("Ich hab schon wieder diesen Termin vergessen...",1577734285000,false, true),
////      Message("Extreeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeem lange Nachricht                             d        Ich hab schon wieder diesen Termin vergessen...",456,false),
//    ].reversed.toList();
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

      _messages.insert(0,Message(message,currentUnixTime,true,false)); //Add to the start of the list

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

  @override
  Widget displayLoadingPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loading your conversation..."),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Future<void> loadDynamicContent() async {
    _messages = await fetchNewestMessages(20);
  }

  @override
  bool preValidate(BuildContext context) {
    Map<String,Object> arguments = ModalRoute.of(context).settings.arguments;
    if(!arguments.containsKey('localUserID')) {
      return false;
    }

    int conversationPartnerID = arguments['localUserID'];
    if(conversationPartnerID==null) {
      return false;
    }
    _conversationPartnerID = conversationPartnerID;
    return true;
  }
}