import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
            radix: 16)),
        width: double.infinity,
        child: Column(
          children: [
            //  main image
            const SizedBox(height: 100),
            Image.asset("lib/assets/pictures/payment_successful.png",
                width: MediaQuery.of(context).size.width - 150),
            //  title and subtitle
            const SizedBox(height: 20),
            CustomComponents.displayText(ProjectStrings.ps_title,
                fontSize: 12, fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomComponents.displayText(ProjectStrings.ps_subheader,
                  fontSize: 10, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 30),
            //  main panel
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 90, right: 90, top: 15, bottom: 5),
                      child: CustomComponents.displayText(
                          ProjectStrings.ps_reservation_title,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          textAlign: TextAlign.center),
                    ),
                    const Divider(),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings.ps_transaction_type_title,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                          CustomComponents.displayText(
                              ProjectStrings.ps_transaction_date_content,
                              fontSize: 10)
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings.ps_transaction_number_title,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                          CustomComponents.displayText(
                              ProjectStrings.ps_transaction_number_content,
                              fontSize: 10)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 7, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings.ps_transaction_date_title,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                          CustomComponents.displayText(
                              ProjectStrings.ps_transaction_date_content,
                              fontSize: 10)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //  proceed button
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Color(
                          int.parse(ProjectColors.mainColorHex.substring(2),
                              radix: 16))),
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)))),
                  onPressed: () {
                    Navigator.of(context).pushNamed("rp_payment_success");
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: CustomComponents.displayText(
                          ProjectStrings.ps_proceed_button,
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
