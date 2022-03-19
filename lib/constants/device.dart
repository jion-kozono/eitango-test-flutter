
import 'package:flutter/material.dart';

class DeviceInfo {
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}