
import 'package:emergency_messenger_client/pages/generic/ErrorPage.dart';
import 'package:emergency_messenger_client/pages/generic/SuccessPage.dart';
import 'package:emergency_messenger_client/pages/private/ConversationPage.dart';
import 'package:emergency_messenger_client/pages/private/LoggedInOverview.dart';
import 'package:emergency_messenger_client/pages/private/OptionsMenu.dart';
import 'package:emergency_messenger_client/pages/public/AddDevicePage.dart';
import 'package:emergency_messenger_client/pages/public/FrontPage.dart';
import 'package:emergency_messenger_client/pages/public/LoginPage.dart';
import 'package:emergency_messenger_client/pages/public/RegisterPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(EmergencyMessenger());

class EmergencyMessenger extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (context) => FrontPage(),
        '/Login' : (context) => LoginPage(),
        '/Register' : (context) => RegisterPage(),
        '/AddDevice' : (context) => AddDevicePage(),
        '/Success' : (context) => SuccessPage(),
        '/Error' : (context) => ErrorPage(),
        '/Messages' : (context) => LoggedInOverview(),
        '/Options' : (context) => OptionsMenu(),
        '/Conversation' : (context) => ConversationPage(),
      },
      title: 'Emergency Messenger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}


















