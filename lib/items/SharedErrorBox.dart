import 'package:flutter/material.dart';

class SharedErrorBox {
  static Future<void> ShowError(BuildContext context,String msg,bool default_msg)
  {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Center(child: Text('Something went wrong!')),
          content: Text(default_msg   ?"Please try again after sometime.Please try again after sometime.": msg),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed:() => Navigator.of(ctx).pop(),
            )
          ],
        )
    );
  }
}