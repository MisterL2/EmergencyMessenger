import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:flutter/material.dart';

class ExamplePage extends StatefulWidget {
  final String title = "Example Page";

  ExamplePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ExamplePageState();

}

class ExamplePageState extends PrivateState<ExamplePage> {
  @override
  Widget buildImpl(BuildContext context, String password, int deviceID) {
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