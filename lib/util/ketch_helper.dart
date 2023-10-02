import 'package:flutter/services.dart';

class KetchHelper{
  static const platform = MethodChannel('flutter.dev/sounds');

  static Future<void> getWebAds() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('get_ads');
      // batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
  }
}