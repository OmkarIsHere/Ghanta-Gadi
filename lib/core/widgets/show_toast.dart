import 'package:flutter/material.dart' show BuildContext,Color, Colors;
import 'package:fluttertoast/fluttertoast.dart';

showCustomToast(String? message, BuildContext context, {bool isError = true}) {
  Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isError ? const Color(0xFFFF2B18) : const Color(
          0xFF14BF04),
      textColor: Colors.white,
      fontSize: 16.0
  );
}

showBasicToast(String? message, BuildContext context) {
  Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 14.0
  );
}