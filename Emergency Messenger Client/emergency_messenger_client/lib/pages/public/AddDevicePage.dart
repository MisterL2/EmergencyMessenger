import 'package:emergency_messenger_client/pages/public/UnregisteredState.dart';
import 'package:flutter/material.dart';

class AddDevicePage extends StatefulWidget {
  final String title;

  AddDevicePage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddDevicePageState();

}

class AddDevicePageState extends UnregisteredState<AddDevicePage> {
  @override
  Widget buildImpl(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adding a new Device"),
      ),
      body: Center(
        child: Text("Add a new device to an already existing account"),
      ),
    );
  }

}