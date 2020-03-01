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
  Widget buildImpl(BuildContext context) {

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
                  leading: Icon(Icons.person_add),
                  title: Text("Add another user"), //This redirects to a page where a connectionCode can be generated
                  subtitle: Text(""),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => _redirectToAddPage(),
                ),
                ListTile(
                  leading: Icon(Icons.add_to_home_screen),
                  title: Text("Add new device"),
                  subtitle: Text("Add another device to your account!"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => _redirectToAddNewDevicePage(),
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever),
                  title: Text("Reset usercode"),
                  subtitle: Text("This will irreversibly end all conversations and make it impossible for other people to message you, until they add your new code again!"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => _redirectToResetPage(),
                ),

          ]).toList(),
      ),
    );
  }

  _redirectToResetPage() {
    Navigator.of(context).pushNamed("/Reset", arguments: <String,Object>{
      "password" : password,
    });
  }

  _redirectToAddPage() {
    Navigator.of(context).pushNamed("/AddUser", arguments: <String,Object>{
      "password" : password,
    });
  }

  _redirectToAddNewDevicePage() {
    Navigator.of(context).pushNamed("/AddNewDevice", arguments: <String,Object>{
      "password" : password,
    });
  }

  @override
  bool preValidate(BuildContext context) {
    return true;
  }

}