import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:flutter/material.dart';

class OptionsMenu extends StatefulWidget {
  final String title = "Options";

  OptionsMenu({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OptionsMenuState();

}

class OptionsMenuState extends PrivateState<OptionsMenu> {

  @override
  Widget buildImpl(BuildContext context, String password) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children:
          ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  leading: Icon(Icons.build),
                  title: Text("Add another user"),
                  subtitle: Text(""),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: Icon(Icons.build),
                  title: Text("Generate connection code"),
                  subtitle: Text(""),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: Icon(Icons.build),
                  title: Text("Reset usercode"),
                  subtitle: Text("This will irreversibly end all conversations and make it impossible for other people to message you, until they add your new code again!"),
                  trailing: Icon(Icons.arrow_forward),
                ),
          ]).toList(),
      ),
    );
  }

}