import "package:dara_app/controller/car_list/car_list_controller.dart";
import "package:dara_app/controller/rent_process/rent_process.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/model/renting_proccess/renting_process.dart";
import "package:dara_app/services/firebase/auth.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

import "../../../../services/maps/distance_calculator.dart";

class RPDetailsFees extends StatefulWidget {
  final bool isDeepLink;

  const RPDetailsFees({super.key, required this.isDeepLink});

  @override
  State<RPDetailsFees> createState() => _RPDetailsFeesState();
}

class _RPDetailsFeesState extends State<RPDetailsFees> {
  RentProcess rentProcess = RentProcess();
  final PersistentData _persistentData = PersistentData();
  String drivingDistance = "";
  String drivingDuration = "";
  String drivingDistanceDriver = "";
  String drivingDurationDriver = "";
  bool payReservationFee = true;
  String driverFee = "0.0";
  String deliveryFee = "0.0";

  @override
  void initState() {
    super.initState();
    if (widget.isDeepLink) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        InfoDialog().showWithCancelProceedButton(
          context: context,
          content: ProjectStrings.rp_details_fees_deep_link_dialog_content,
          header: ProjectStrings.rp_details_fees_deep_link_dialog_title
        );
      });
    }

    calculateDistance();
  }

  Future<void> calculateDistance() async {
    PersistentData _persistentData = PersistentData();
    DistanceCalculator distanceCalculator = DistanceCalculator();

    double startLat = _persistentData.startMapsLatitude;
    double startLng = _persistentData.startMapsLongitude;
    double endLat = _persistentData.endMapsLatitude;
    double endLng = _persistentData.endMapsLongitude;

    await distanceCalculator.calculateDistance(startLat, startLng, endLat, endLng);


    // Update driving distance and duration in the state
    setState(() {
      drivingDistance = distanceCalculator.getDrivingDistance();
      drivingDuration = distanceCalculator.getDrivingTimeDuration();
    });

    calculateDeliveryLocationGarageIfWithDriver();
  }

  Future<void> calculateDeliveryLocationGarageIfWithDriver() async {
    DistanceCalculator distanceCalculator = DistanceCalculator();

    await distanceCalculator.calculateDistance(14.1954, 121.1641, _persistentData.startMapsLatitude, _persistentData.startMapsLongitude);

    setState(() {
      drivingDistanceDriver = _persistentData.deliveryModePickUpOrDelivery == "Delivery" ? distanceCalculator.getDrivingDistance() : "NA";
      drivingDurationDriver = _persistentData.deliveryModePickUpOrDelivery == "Delivery" ? distanceCalculator.getDrivingTimeDuration() : "NA";
    });
  }

  @override
  Widget build(BuildContext context) {
    CarListController _carListController = CarListController();

    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
            radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              _buildAppBar(),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildFirstPanel(),
                    _deliveryFeesPanel(),
                    _driverPanel(),
                    _buildSecondPanel(),
                    _buildThirdPanel(),

                    //  proceed button
                    const SizedBox(height: 30),
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
                          onPressed: () async {
                            Auth _auth = Auth();

                            RentInformation _rentInformation = RentInformation(
                                renterUID: _auth.currentUser?.uid ?? "null",
                                renterEmail: _auth.currentUser?.email ?? "null",
                                carName: _persistentData.selectedCarItem?.name ?? "",
                                startDateTime: "${_persistentData.bookingDetailsStartingDate} | ${_persistentData.bookingDetailsStartingTime}",
                                endDateTime: "${_persistentData.bookingDetailsEndingDate} | ${_persistentData.bookingDetailsEndingTime}",
                                rentLocation: _persistentData.bookingDetailsMapsLocationFromLongitudeLatitude_forrent_location,
                                deliveryLocation: _persistentData.deliveryModePickUpOrDelivery == "Delivery" ? _persistentData.deliveryModeLocation : _persistentData.deliveryModeLocation,
                                estimatedDrivingDistance: drivingDistance,
                                estimatedDrivingDuration: drivingDuration,
                                pickupOrDelivery: _persistentData.deliveryModePickUpOrDelivery,
                                deliveryDistance: _persistentData.deliveryModePickUpOrDelivery == "Delivery" ? drivingDistanceDriver : "NA",
                                deliveryDuration: _persistentData.deliveryModePickUpOrDelivery == "Delivery" ? drivingDurationDriver : "NA",
                                withDriver: _persistentData.bookingDetailsRentWithDriver ? "yes" : "no",
                                driverAmount: _persistentData.bookingDetailsRentWithDriver ? "PHP 0.0" : "NA",
                                rentalFee: "rentalFee",
                                mileageFee: "mileageFee",
                                deliveryFee: deliveryFee,
                                driverFee: _persistentData.bookingDetailsRentWithDriver ? "PHP $driverFee" : "NA",
                                reservationFee: payReservationFee ? "500" : "0",
                                totalAmount: "totalAmount"
                            );
                            // debugPrint(_rentInformation.renterUID);
                            // debugPrint(_rentInformation.renterEmail);
                            // debugPrint(_rentInformation.carName);
                            // debugPrint(_rentInformation.startDateTime);
                            // debugPrint(_rentInformation.endDateTime);
                            // debugPrint(_rentInformation.rentLocation);
                            // debugPrint(_rentInformation.deliveryLocation);
                            // debugPrint(_rentInformation.estimatedDrivingDistance);
                            // debugPrint(_rentInformation.estimatedDrivingDuration);
                            // debugPrint(_rentInformation.pickupOrDelivery);
                            // debugPrint(_rentInformation.deliveryDistance);
                            // debugPrint(_rentInformation.deliveryDuration);
                            // debugPrint(_rentInformation.withDriver);
                            // debugPrint(_rentInformation.driverAmount);
                            // debugPrint(_rentInformation.rentalFee);
                            // debugPrint(_rentInformation.mileageFee);
                            // debugPrint(_rentInformation.deliveryFee);
                            // debugPrint(_rentInformation.driverFee);
                            // debugPrint(_rentInformation.reservationFee);
                            // debugPrint(_rentInformation.totalAmount);

                            LoadingDialog().show(context: context, content: "Please wait while we process your rent application.");
                            await _carListController.submitRentRecords(
                                collectionName: FirebaseConstants.rentRecordsCollection,
                                documentName: _auth.currentUser!.uid,
                                data: _rentInformation.getModelData()
                            );
                            LoadingDialog().dismiss();

                            if (payReservationFee) {
                              rentProcess.startGcashPayment(context);
                            } else {
                              Navigator.of(context).pushNamed("rp_submit_documents");
                            }
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 15),
                              child: CustomComponents.displayText(
                                  payReservationFee ? ProjectStrings.rp_details_fees_proceed_to_payment : "Proceed with Document Submission",
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
                    const SizedBox(height: 50)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _driverPanel() {
    PersistentData _persistentData = PersistentData();

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
                  "Driver Fees",
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            _buildDetailsRow(
                "With Driver",
                _persistentData.bookingDetailsRentWithDriver ? "Yes" : "No",
                false
            ),
            _buildDetailsRow(
                "Amount",
                _persistentData.bookingDetailsRentWithDriver ? "PHP 0.0" : "NA",
                false
            ),
            const Divider(),
            _buildDetailsRow(
                "Driver Fee",
                _persistentData.bookingDetailsRentWithDriver ? "PHP $driverFee" : "NA",
                true
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _deliveryFeesPanel() {
    PersistentData _persistentData = PersistentData();

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
                  "Delivery Fees",
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            _buildDetailsRow(
              "Pick Up or Delivery",
              _persistentData.deliveryModePickUpOrDelivery == "Delivery" ? "Delivery" : "Pick Up",
              false
            ),
            _buildDetailsRow(
              "Delivery Distance",
              _persistentData.deliveryModePickUpOrDelivery == "Delivery" ? drivingDistanceDriver : "NA",
                false
            ),
            _buildDetailsRow(
                "Delivery Duration",
                _persistentData.deliveryModePickUpOrDelivery == "Delivery" ? drivingDurationDriver : "NA",
              false
            ),
            const Divider(),
            _buildDetailsRow(
                "Delivery Fee",
                _persistentData.deliveryModePickUpOrDelivery == "Delivery" ? "PHP $deliveryFee" : "NA",
              true
            ),
            const SizedBox(height: 10),
          ],
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
                  Image.network(
                    FirebaseConstants.retrieveImage(_persistentData.selectedCarItem!.mainPicUrl),
                    width: 80,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomComponents.displayText(
                        _persistentData.selectedCarItem!.name,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          CustomComponents.displayText(
                            ProjectStrings.rp_details_fees_amount_symbol,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(int.parse(
                                ProjectColors.mainColorHex.substring(2),
                                radix: 16)),
                          ),
                          const SizedBox(width: 3),
                          CustomComponents.displayText(
                            _persistentData.selectedCarItem!.price,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(int.parse(
                                ProjectColors.mainColorHex.substring(2),
                                radix: 16)),
                          ),
                          const SizedBox(width: 3),
                          CustomComponents.displayText(
                            ProjectStrings.rp_details_fees_per_day,
                            fontSize: 12,
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
              "${_persistentData.bookingDetailsStartingDate} | ${_persistentData.bookingDetailsStartingTime}",
              false
            ),
            _buildDetailsRow(
              ProjectStrings.rp_details_fees_ending_date_time,
                "${_persistentData.bookingDetailsEndingDate} | ${_persistentData.bookingDetailsEndingTime}",
              false
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomComponents.displayText(
                  "Rent Location",
                  fontSize: 10,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomComponents.displayText(
                    _persistentData.bookingDetailsMapsLocationFromLongitudeLatitude_forrent_location,
                  fontSize: 10
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomComponents.displayText(
                    "${_persistentData.deliveryModePickUpOrDelivery} Location",
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomComponents.displayText(
                    _persistentData.deliveryModePickUpOrDelivery == "Delivery" ? _persistentData.deliveryModeLocation : "${_persistentData.deliveryModeLocation} (garage location)",
                    fontSize: 10
                ),
              ),
            ),
            const SizedBox(height: 7),
            const Divider(),
            _buildDetailsRow(
                "Estimated Driving Distance",
                drivingDistance,
              false
            ),
            _buildDetailsRow(
                "Estimated Driving Duration",
                drivingDuration,
              false
            ),
            const SizedBox(height: 7)
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
              false
            ),
            _buildDetailsRow(
              ProjectStrings.rp_details_fees_mileage_fee,
              ProjectStrings.rp_details_fees_mileage_fee_entry,
              false
            ),
            _buildDetailsRow(
              "Delivery Fee",
              _persistentData.deliveryModePickUpOrDelivery == "Delivery" ? "PHP $deliveryFee" : "NA",
              false
            ),
            _buildDetailsRow(
                "Driver Fee",
                _persistentData.bookingDetailsRentWithDriver ? "PHP $driverFee" : "NA",
                false
            ),
            _buildDetailsRow(
                "Reservation Fee",
                payReservationFee ? "PHP 500" : "NA",
                false
            ),
            const Divider(),
            _buildDetailsRow(ProjectStrings.rp_details_fees_total_amount,
                ProjectStrings.rp_details_fees_total_amount_entry, true),
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
                      value: payReservationFee,
                      onChanged: (bool? value) {
                        setState(() {
                          payReservationFee = !payReservationFee;
                        });
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

  Widget _buildDetailsRow(String title, String entry, bool decorateEntry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomComponents.displayText(
            title,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.displayText(
            entry,
            fontSize: 10,
            color: decorateEntry ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff404040),
            fontWeight: decorateEntry ? FontWeight.bold : FontWeight.normal
          ),
        ],
      ),
    );
  }
}
