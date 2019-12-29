import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:flutter/material.dart';

class ResetPage extends StatefulWidget {
  final String title = "Hard Reset";

  ResetPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ResetPageState();

}

class ResetPageState extends PrivateState<ResetPage> {
  @override
  Widget buildImpl(BuildContext context, String password) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text("Reset your usercode"),
      ),
    );
  }

}