import 'package:dara_app/controller/utils/constants.dart';
import 'package:dara_app/view/pages/admin/rent_process/gcash_webview.dart';
import 'package:paymongo_sdk/paymongo_sdk.dart';
import 'package:flutter/material.dart';

import '../../controller/singleton/persistent_data.dart';

Future<void> gcashPayment(BuildContext context, double amount) async {
  const String publicApiKey = Constants.PAYMONGO_PUBLIC_KEY;

  const PaymongoClient<PaymongoPublic> publicSDK = PaymongoClient<PaymongoPublic>(publicApiKey);

  SourceAttributes data = SourceAttributes(
    type: "gcash",
    // Update amount to cents (e.g., 1000 PHP = 100000 cents)
    // amount: 10000,
    amount: amount,
    currency: "PHP",
    redirect: const Redirect(
      success: "https://payment-success.com",
      failed: "https://payment-failed.com",
    ),
    billing: const PayMongoBilling(
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

    // Extract transaction ID or reference number
    final String transactionId = result.id; // The unique ID of the source
    debugPrint('Transaction ID: $transactionId');
    PersistentData().gcashTransactionId = transactionId;

    // Use checkout_url if available
    final String? paymentUrl = result.attributes?.redirect.checkoutUrl ?? result.attributes?.redirect.url;
    if (paymentUrl != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebView(url: paymentUrl),
        ),
      );
    } else {
      debugPrint('Payment URL is null');
      // You can show a dialog or message to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment URL is not available.")),
      );
    }
  } catch (e, stacktrace) {
    debugPrint('Error creating payment source: ${e.toString()}');
    debugPrint('Stacktrace: $stacktrace');
    if (e is PaymongoError) {
      debugPrint('PaymongoError details: ${e.error.toString()}');
      debugPrint('PaymongoError type: ${e.paymongoErrors.toString()}');
    }
    // Show error message to user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to create payment. Please try again.")),
    );
  }
}
