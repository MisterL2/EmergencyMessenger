import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:flutter/material.dart';

class AddUserPage extends StatefulWidget {
  final String title = "Add another user";

  AddUserPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddUserPageState();

}

class AddUserPageState extends PrivateState<AddUserPage> {
  @override
  Widget buildImpl(BuildContext context, String password) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text("Enter & Generate a connection code on this page"),
      ),
    );
  }

}