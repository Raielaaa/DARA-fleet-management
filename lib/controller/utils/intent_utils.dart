import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IntentUtils {
  IntentUtils._();
  static Future<void> launchGoogleMaps() async {
    const double destinationLatitude= 14.195691850762733;
    const double destinationLongitude = 121.1643007807619;
    final uri = Uri(
        scheme: "google.navigation",
        // host: '"0,0"',  {here we can put host}
        queryParameters: {
          'q': '$destinationLatitude, $destinationLongitude'
        });
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }

  static Future<void> launchAntripIOT({
    required String androidPackageName
  }) async {
    if (Platform.isAndroid) {
      final androidOpenAppUrl = Uri.parse("market://launch?id=$androidPackageName");
      final appInstalled = await canLaunchUrl(androidOpenAppUrl);

      if (appInstalled) {
        //  If we can open the url then open the app
        await launchUrl(androidOpenAppUrl);
      }
    }
  }
}
