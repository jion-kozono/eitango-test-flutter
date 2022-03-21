import 'package:eitango_test_flutter/constants/device.dart';
import 'package:flutter/material.dart';

SnackBar mySnackBar(BuildContext context, String msg) {
  return SnackBar(
    backgroundColor: Colors.redAccent,
    margin: EdgeInsets.only(
        bottom: DeviceInfo.height(context) * 0.8, right: 20, left: 20),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    content: Text(msg),
  );
}