import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Internet {
  Future<bool> connectivityChecker() async {
    var connected = false;
    print("Checking internet...");
    try {
      final result = await InternetAddress.lookup('google.com');
      final result2 = await InternetAddress.lookup('facebook.com');
      final result3 = await InternetAddress.lookup('microsoft.com');
      if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
          (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
          (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty)) {
        ReusableCard.showToast(
            Colors.red, 'Internet connection on', Colors.white);
        connected = true;
      } else {
        print("No internet");
        ReusableCard.showToast(
            Colors.red, 'No internet connection', Colors.white);
        connected = false;
      }
    } on SocketException catch (_) {
      ReusableCard.showToast(
          Colors.red, 'No internet connection', Colors.white);
      connected = false;
    }
    return connected;
  }
}

class ReusableCard {
  ReusableCard(
      {required this.colourBG, required this.text, required this.colourText});
  final Color colourBG;
  final String text;
  final Color colourText;

  static showToast(colourBG, text, colourText) {
    Fluttertoast.showToast(
        msg: text.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: colourBG,
        textColor: colourText);
  }
}
