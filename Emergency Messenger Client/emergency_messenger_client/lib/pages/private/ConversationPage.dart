import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  final String title = "Example Page";

  ConversationPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConversationPageState();

}

class ConversationPageState extends PrivateState<ConversationPage> {
  @override
  Widget buildImpl(BuildContext context, String password) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text("Hello World"),
      ),
    );
  }

}