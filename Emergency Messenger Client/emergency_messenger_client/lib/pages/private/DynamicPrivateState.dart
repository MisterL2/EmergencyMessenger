import 'package:emergency_messenger_client/pages/private/PrivateState.dart';
import 'package:flutter/material.dart';

abstract class DynamicPrivateState<T extends StatefulWidget> extends PrivateState<T> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    if(!passwordValidate(context) || !preValidate(context)) { //No password supplied / Invalid preValidate
      return denyPageAccess(context);
    }

    if(!_loaded) {
      loadDynamicContent().then((val) {
        setState(() {
          _loaded = true;
        });
      });
      return displayLoadingPage();
    }

    return buildImpl(context); //Only runs when a valid password has been entered
  }

  Future<void> loadDynamicContent();
  Widget displayLoadingPage();
}