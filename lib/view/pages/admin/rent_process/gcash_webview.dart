import "package:dara_app/view/pages/admin/rent_process/details_fees.dart";
import "package:dara_app/view/pages/admin/rent_process/payment_success.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatelessWidget {
  final String url;

  PaymentWebView({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: WebView(
                  backgroundColor: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith('https://payment-success.com')) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentSuccess()),
                      );
                      return NavigationDecision.prevent;
                    } else if (request.url.startsWith('https://payment-failed.com')) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RPDetailsFees(isDeepLink: true,)), // Ensure you have this page or handle failure appropriately
                      );
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      height: 65,
      color: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/left_arrow.png"),
          ),
          Center(
            child: CustomComponents.displayText(
              "GCash Payment",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}