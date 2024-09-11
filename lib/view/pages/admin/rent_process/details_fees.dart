import "package:dara_app/controller/rent_process/rent_process.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class RPDetailsFees extends StatefulWidget {
  const RPDetailsFees({super.key});

  @override
  State<RPDetailsFees> createState() => _RPDetailsFeesState();
}

class _RPDetailsFeesState extends State<RPDetailsFees> {
  RentProcess rentProcess = RentProcess();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
            radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              _buildAppBar(),
              _buildFirstPanel(),
              _buildSecondPanel(),
              _buildThirdPanel(),

              //  proceed button
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            ProjectStrings.rp_details_fees_proceed_to_payment,
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),

              const SizedBox(height: 15),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    rentProcess.showUploadPhotoBottomDialog(context);
                  },
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          text: ProjectStrings.rp_details_fees_send_screenshot_1,
                          style: TextStyle(
                              fontSize: 10,
                              color: Color(0xff404040),
                              fontFamily: ProjectStrings.general_font_family),
                          children: [
                            TextSpan(
                                text:
                                    ProjectStrings.rp_details_fees_send_screenshot_2,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xff3FA2BE),
                                    fontFamily: ProjectStrings.general_font_family,
                                    fontWeight: FontWeight.w600)
                                ),
                            TextSpan(
                              text: ProjectStrings.rp_details_fees_send_screenshot_3,
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff404040),
                                fontFamily: ProjectStrings.general_font_family),
                              )
                          ]
                      )
                  ),
                ),
              ),
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
              ProjectStrings.rp_details_fees_appbar_title,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstPanel() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
        ),
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 5),
              child: Row(
                children: [
                  Image.asset(
                    "lib/assets/pictures/rental_car_placeholder.png",
                    width: 80,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomComponents.displayText(
                        ProjectStrings.rp_details_fees_car_name,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          CustomComponents.displayText(
                            ProjectStrings.rp_details_fees_amount_symbol,
                            fontSize: 10,
                            color: Color(int.parse(
                                ProjectColors.mainColorHex.substring(2),
                                radix: 16)),
                          ),
                          const SizedBox(width: 3),
                          CustomComponents.displayText(
                            ProjectStrings.rp_details_fees_amount,
                            fontSize: 10,
                            color: Color(int.parse(
                                ProjectColors.mainColorHex.substring(2),
                                radix: 16)),
                          ),
                          const SizedBox(width: 3),
                          CustomComponents.displayText(
                            ProjectStrings.rp_details_fees_per_day,
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            _buildDetailsRow(
              ProjectStrings.rp_details_fees_starting_date_time,
              ProjectStrings.rp_details_fees_starting_date_time_entry,
            ),
            _buildDetailsRow(
              ProjectStrings.rp_details_fees_ending_date_time,
              ProjectStrings.rp_details_fees_ending_date_time_entry,
            ),
            const Divider(),
            _buildDetailsRow(
              ProjectStrings.rp_details_fees_pick_up_location,
              ProjectStrings.rp_details_fees_pick_up_location_entry,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondPanel() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 15, top: 15, bottom: 7),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomComponents.displayText(
                  ProjectStrings.rp_details_fees_price_breakdown,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            _buildDetailsRow(
              ProjectStrings.rp_details_fees_rent_fee,
              ProjectStrings.rp_details_fees_rent_fee_entry,
            ),
            _buildDetailsRow(
              ProjectStrings.rp_details_fees_mileage_fee,
              ProjectStrings.rp_details_fees_mileage_fee_entry,
            ),
            const Divider(),
            _buildDetailsRow(ProjectStrings.rp_details_fees_total_amount,
                ProjectStrings.rp_details_fees_total_amount_entry),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdPanel() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: double.infinity,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 20, top: 15, bottom: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomComponents.displayText(
                      ProjectStrings.rp_details_fees_reservation_fee,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomComponents.displayText(
                        ProjectStrings.rp_details_fees_reservation_fees_entry,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)
                  ],
                )),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: CustomComponents.displayText(
                  ProjectStrings.rp_details_fees_agreement_entry,
                  fontSize: 10,
                  textAlign: TextAlign.justify),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 10),
              child: Row(
                children: [
                  Transform.scale(
                    scale:
                        0.8, // Adjust the scale to change the size of the checkbox
                    child: Checkbox(
                      value: true,
                      onChanged: (bool? value) {
                        // Handle checkbox change
                      },
                      activeColor: Color(int.parse(
                          ProjectColors.mainColorHex.substring(2),
                          radix:
                              16)), // The color of the checkbox when it's checked
                      checkColor: Colors
                          .white, // The color of the checkmark inside the checkbox
                    ),
                  ),
                  const SizedBox(
                      width: 8), // Add spacing between checkbox and text
                  CustomComponents.displayText(
                      ProjectStrings.rp_details_fees_agreement,
                      fontSize: 10)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsRow(String title, String entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomComponents.displayText(title,
              fontSize: 10, fontWeight: FontWeight.bold),
          CustomComponents.displayText(entry, fontSize: 10),
        ],
      ),
    );
  }
}
