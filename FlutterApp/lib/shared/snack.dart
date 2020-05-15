import 'package:flutter/material.dart';
class snack{
  SnackBar displaySnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
      backgroundColor: Colors.blue[200],
      action: SnackBarAction(
        label: 'Ok',
        onPressed: (){},
      ),
    );
    return snackBar;
  }
}
