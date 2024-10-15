import "package:dara_app/model/account/register_model.dart";
import "package:dara_app/services/firebase/firestore.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:slide_switcher/slide_switcher.dart";

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../model/renting_proccess/renting_process.dart";

class Inquiries extends StatefulWidget {
  const Inquiries({super.key});

  @override
  State<Inquiries> createState() => _InquiriesState();
}

class _InquiriesState extends State<Inquiries> {
  List<RentInformation> rentInformationList = [];
  RegisterModel? _userInfoTemp;
  List<RentInformation> ongoingInquiry = [];
  List<RentInformation> pastDuesInquiry = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      retrieveRentRecords();
    });
  }

  Future<void> retrieveUserInfo(String renterUID) async {
    RegisterModel? _userData = await Firestore().getUserInfo(renterUID);
    setState(() {
      _userInfoTemp = _userData!;
    });
  }

  Future<void> retrieveRentRecords() async {
    try {
      // Show the loading dialog while retrieving rent records
      LoadingDialog().show(
        context: context,
        content: "Retrieving rent inquiries. Please wait a moment.",
      );

      // Retrieve rent records outside of setState
      List<RentInformation> records = await Firestore().getRentRecords();

      for (var item in records) {
        if (isDateInPast(item.startDateTime)) {
          setState(() {
            pastDuesInquiry.add(item);
          });
        } else {
          setState(() {
            ongoingInquiry.add(item);
          });
        }
      }

      // Use setState to update the state after the async call
      setState(() {
        rentInformationList = ongoingInquiry; // Assign the retrieved records
      });

      // Dismiss the loading dialog
      LoadingDialog().dismiss();
    } catch (e) {
      // Dismiss the loading dialog if there's an error
      LoadingDialog().dismiss();
      // Show an info dialog with the error message
      InfoDialog().show(
        context: context,
        content: "Something went wrong: $e",
        header: "Warning",
      );
      debugPrint("Error@inquiries.dart@ln45: $e");
    }
  }

  bool isDateInPast(String dateStr) {
    // Parse the date string
    DateFormat format = DateFormat("MMMM d, yyyy | hh:mm a");
    DateTime parsedDate = format.parse(dateStr);

    // Compare with the current date
    return parsedDate.isBefore(DateTime.now());
  }

  Widget buildInfoRow(String title, String value, {EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(right: 15, left: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomComponents.displayText(
            title,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: Color(int.parse(
              ProjectColors.lightGray.substring(2),
              radix: 16,
            )),
          ),
          const Spacer(),
          Expanded(
            child: CustomComponents.displayText(
              value,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              textAlign: TextAlign.end
            ),
          ),
        ],
      ),
    );
  }

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
              // ActionBar
              actionBar(),

              // title and subheader
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(ProjectStrings.ri_title,
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                      ProjectStrings.ri_subheader,
                      fontSize: 10),
                ),
              ),

              // main body
              // Switch option
              const SizedBox(height: 15),
              switcher(ongoingInquiry!, pastDuesInquiry!),
              const SizedBox(height: 15),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: rentInformationList.isEmpty ? Center(
                    child: CircularProgressIndicator(
                      color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                    ),
                  ) : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: rentInformationList.length,
                      itemBuilder: (BuildContext context, int index) {
                        retrieveUserInfo(rentInformationList[index].renterUID);

                        return _userInfoTemp == null ? Center(
                          child: CircularProgressIndicator(color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))),
                        ) : Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 3),
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(int.parse(
                                                      ProjectColors.mainColorBackground
                                                          .substring(2),
                                                      radix: 16)),
                                                  border: Border.all(
                                                      color: Color(int.parse(ProjectColors
                                                          .lineGray)),
                                                      width: 1)),
                                              child: Center(
                                                  child: CustomComponents.displayText("1",
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold))),
                                        ),
                                        const SizedBox(width: 20.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              CustomComponents.displayText(
                                                ProjectStrings
                                                    .ri_renter_information_title,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              const SizedBox(height: 2),
                                              CustomComponents.displayText(
                                                ProjectStrings
                                                    .ri_renter_information_subheader,
                                                color: Color(int.parse(
                                                    ProjectColors.lightGray
                                                        .substring(2),
                                                    radix: 16)),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 10),
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Color(int.parse(
                                        ProjectColors.lineGray.substring(2),
                                        radix: 16)),
                                  ),
                                  // Name
                                  buildInfoRow(ProjectStrings.ri_name_title, "${_userInfoTemp?.firstName} ${_userInfoTemp?.lastName}", padding: const EdgeInsets.only(right: 15, left: 15, top: 15)),

                                  // Email
                                  buildInfoRow(ProjectStrings.ri_email_title, _userInfoTemp!.email),

                                  // Phone number
                                  buildInfoRow(ProjectStrings.ri_phone_number_title, _userInfoTemp!.number),

                                  //  role
                                  buildInfoRow("Role:", _userInfoTemp!.role),

                                  // Rent start date
                                  buildInfoRow(ProjectStrings.ri_rent_start_date_title, rentInformationList[index].startDateTime),

                                  // Rent end date
                                  buildInfoRow(ProjectStrings.ri_rent_end_date_title, rentInformationList[index].endDateTime),

                                  // Delivery mode
                                  buildInfoRow(ProjectStrings.ri_delivery_mode_title, rentInformationList[index].pickupOrDelivery),

                                  // Delivery location
                                  buildInfoRow(ProjectStrings.ri_delivery_location_title, rentInformationList[index].deliveryLocation),

                                  // Reserved
                                  buildInfoRow(ProjectStrings.ri_reserved_title, rentInformationList[index].reservationFee == "0" ? "No" : "Yes"),

                                  const SizedBox(height: 30),

                                  //  attached documents
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: CustomComponents.displayText(
                                          ProjectStrings.ri_attached_document,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),

                                  displayDocuments(
                                      ProjectStrings.ri_government_id_1),
                                  displayDocuments(
                                      ProjectStrings.ri_government_id_2),
                                  displayDocuments(
                                      ProjectStrings.ri_driver_license),
                                  displayDocuments(
                                      ProjectStrings.ri_proof_of_billing),
                                  displayDocuments(
                                      ProjectStrings.ri_ltms_portal),

                                  const SizedBox(height: 30),

                                  //  add note/approve button
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        actionButton(
                                          iconPath: "lib/assets/pictures/rentals_denied.png",
                                          backgroundColor: ProjectColors.redButtonBackground,
                                          labelText: ProjectStrings.ri_add_note,
                                          textColor: ProjectColors.redButtonMain,
                                          onTap: () {
                                            Navigator.pushNamed(context, "rentals_report");
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        actionButton(
                                          iconPath: "lib/assets/pictures/rentals_verified.png",
                                          backgroundColor: ProjectColors.lightGreen,
                                          labelText: ProjectStrings.ri_approve,
                                          textColor: ProjectColors.greenButtonMain,
                                          onTap: () {
                                          },
                                        )
                                      ]
                                  ),

                                  const SizedBox(height: 30)
                                ],
                              )),
                        );
                      }),
                ),
              ),

              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }

  Widget switcher(List<RentInformation> ongoingInquiry, List<RentInformation> pastDuesInquiry) {
    return SlideSwitcher(
      indents: 3,
      containerColor: Colors.white,
      containerBorderRadius: 7,
      slidersColors: [
        Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
      ],
      containerHeight: 50,
      containerWight: MediaQuery.of(context).size.width - 50,
      onSelect: (index) {
        setState(() {
          rentInformationList = index == 0 ? ongoingInquiry : pastDuesInquiry;
        });
      },
      children: [
        CustomComponents.displayText(
          "Current Dues",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          "Past Dues",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )
      ],
    );
  }

  Widget actionButton({
    required String iconPath,
    required String backgroundColor,
    required String labelText,
    required String textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(int.parse(backgroundColor.substring(2), radix: 16)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Image.asset(
                iconPath,
                width: 20,
                height: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 25, left: 5),
              child: CustomComponents.displayText(
                labelText,
                color: Color(int.parse(textColor.substring(2), radix: 16)),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget actionBar() {
    return Container(
      width: double.infinity,
      height: 65,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              PersistentData().openDrawer(0);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("lib/assets/pictures/menu.png"),
            ),
          ),
          CustomComponents.displayText(
            ProjectStrings.ri_appbar,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }

  Widget displayDocuments(String documentName) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Color(int.parse(
                          ProjectColors.mainColorHex.substring(2),
                          radix: 16))),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomComponents.displayText(ProjectStrings.ri_jpg,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomComponents.displayText(documentName,
                        fontSize: 10, fontWeight: FontWeight.w500),
                    Row(
                      children: [
                        CustomComponents.displayText(ProjectStrings.ri_size,
                            fontSize: 10,
                            color: Color(int.parse(
                                ProjectColors.lightGray.substring(2),
                                radix: 16))),
                        const SizedBox(width: 20),
                        CustomComponents.displayText(
                            ProjectStrings.ri_document_date,
                            fontSize: 10,
                            color: Color(int.parse(
                                ProjectColors.lightGray.substring(2),
                                radix: 16)))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          //  view text
          CustomComponents.displayText(ProjectStrings.ri_view,
              color: Color(int.parse(ProjectColors.mainColorHex.substring(2),
                  radix: 16)),
              fontSize: 10,
              fontWeight: FontWeight.bold)
        ],
      ),
    );
  }
}
