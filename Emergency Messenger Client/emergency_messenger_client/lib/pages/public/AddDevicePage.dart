import 'package:emergency_messenger_client/pages/public/UnregisteredState.dart';
import 'package:flutter/material.dart';

class AddThisDevicePage extends StatefulWidget {
  final String title;

  AddThisDevicePage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddThisDevicePageState();

}

class AddThisDevicePageState extends UnregisteredState<AddThisDevicePage> {
  @override
  Widget buildImpl(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adding this device to an account"),
      ),
      body: Center(
        child: Text("Add this device to an already existing account"),
      ),
    );
  }

}