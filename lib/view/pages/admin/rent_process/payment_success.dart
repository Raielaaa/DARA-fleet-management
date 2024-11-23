import "package:dara_app/controller/singleton/persistent_data.dart";
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
  Widget _informationRow(String infoCount, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(int.parse(
                        ProjectColors.mainColorHex.substring(2),
                        radix: 16)),
                    borderRadius: const BorderRadius.all(Radius.circular(100))),
                width: 30,
                height: 30,
              ),
              CustomComponents.displayText(infoCount,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.white)
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CustomComponents.displayText(info, fontSize: 10),
          )
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75, // 3/4 of the screen height
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, // Full width
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "lib/assets/pictures/id.png",
                          width: MediaQuery.of(context).size.width - 150,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomComponents.displayText(ProjectStrings.sd_title,
                          fontWeight: FontWeight.bold, fontSize: 14),
                      _informationRow("1", ProjectStrings.sd_notice_1),
                      _informationRow("2", ProjectStrings.sd_notice_2),
                      _informationRow("3", ProjectStrings.sd_notice_3),
                      _informationRow("4", ProjectStrings.sd_notice_4),

                      //  proceed button
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Color(int.parse(
                                      ProjectColors.mainColorHex.substring(2),
                                      radix: 16))),
                              shape: MaterialStatePropertyAll<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          onPressed: () {
                            Navigator.of(context).pushNamed("rp_submit_documents");
                          },
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: CustomComponents.displayText(
                                  ProjectStrings.ps_proceed_button,
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
            radix: 16)),
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 100),
            Image.asset("lib/assets/pictures/payment_successful.png",
                width: MediaQuery.of(context).size.width - 150),
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
                              "Reservation Fee",
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
                              PersistentData().gcashTransactionId,
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
                          PersistentData().getCurrentFormattedDate(),
                              fontSize: 10)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                  _showBottomSheet(context);
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
