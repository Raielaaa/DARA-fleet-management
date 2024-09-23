import 'package:dara_app/controller/utils/constants.dart';
import 'package:dara_app/view/pages/admin/rent_process/gcash_webview.dart';
import 'package:paymongo_sdk/paymongo_sdk.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> gcashPayment(BuildContext context) async {
  const String publicApiKey = Constants.PAYMONGO_PUBLIC_KEY;

  final publicSDK = PaymongoClient<PaymongoPublic>(publicApiKey);

  const data = SourceAttributes(
    type: "gcash",
    amount: 1000, // Ensure this is in the correct unit (e.g., cents)
    currency: "PHP",
    redirect: Redirect(
      success: "https://payment-success.com",
      failed: "https://payment-failed.com",
    ),
    billing: PayMongoBilling(
      name: "Ralph Daniel Honra",
      phone: "09701900391",
      email: "rbhonra@ccc.edu.ph",
      address: PayMongoAddress(
        city: "Calamba",
        postalCode: "4027",
        country: "PH",
        state: "Laguna",
      ),
    ),
  );

  try {
    debugPrint('Creating payment source with data: ${data.toJson()}');
    final result = await publicSDK.instance.source.create(data);
    debugPrint('Payment Source Created: ${result.toJson()}');

    // Use checkout_url if available
    final paymentUrl = result.attributes?.redirect.checkoutUrl ?? result.attributes?.redirect.url;
    if (paymentUrl != null) {
      // Navigate to the WebView screen with the payment URL
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebView(url: paymentUrl),
        ),
      );
      // if (await canLaunchUrlString(paymentUrl)) {
      //   // Navigate to the WebView screen with the payment URL
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => PaymentWebView(url: paymentUrl),
      //     ),
      //   );
      // } else {
      //   debugPrint('Could not launch $paymentUrl');
      // }
    } else {
      debugPrint('Payment URL is null');
    }
  } catch (e, stacktrace) {
    debugPrint('Error creating payment source: ${e.toString()}');
    debugPrint('Stacktrace: $stacktrace');
    if (e is PaymongoError) {
      debugPrint('PaymongoError details: ${e.error.toString()}');
      debugPrint('PaymongoError type: ${e.paymongoErrors.toString()}');
    }
  }
}