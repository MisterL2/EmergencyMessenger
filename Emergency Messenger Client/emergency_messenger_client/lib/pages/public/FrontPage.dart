import 'package:emergency_messenger_client/utilities/SoundManager.dart';
import 'package:flutter/material.dart';


class FrontPage extends StatefulWidget {
  final String title = "Emergency Messenger";

  FrontPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FrontPageState();
}

class FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {
    SoundManager.initialise(); //Runs async, pre-loads sounds for better performance

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 1,
          child: ListView(
              children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                ListTile(
                  leading: Icon(Icons.play_for_work),
                  title: Text("Register"),
                  subtitle: Text("Create a new account"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => Navigator.of(context).pushNamed("/Register"),
                ),
                ListTile(
                  leading: Icon(Icons.add_to_home_screen),
                  title: Text("Add new device"),
                  subtitle: Text("Add a new device to an already existing account"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => Navigator.of(context).pushNamed("/AddThisDevice"),
                ),
                ListTile(
                  leading: Icon(Icons.vpn_key),
                  title: Text("Login"),
                  subtitle: Text("Log into an already existing account for this device"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => Navigator.of(context).pushNamed("/Login"),
                ),
              ])
                  .toList()
          ),
        )
      ),
    );
  }


}