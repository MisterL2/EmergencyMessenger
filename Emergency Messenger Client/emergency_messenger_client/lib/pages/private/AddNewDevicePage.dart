import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:flutter/material.dart';

class AddNewDevicePage extends StatefulWidget {
  final String title = "Adding a new device";

  AddNewDevicePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddNewDevicePageState();

}

class AddNewDevicePageState extends PrivateState<AddNewDevicePage> {
  @override
  Widget buildImpl(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text("Add a new device to this account"),
      ),
    );
  }

  @override
  bool preValidate(BuildContext context) {
    return true;
  }

}