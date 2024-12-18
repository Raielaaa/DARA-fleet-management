import "dart:convert";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/controller/utils/constants.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

class RPDeliveryMode extends StatefulWidget {
  const RPDeliveryMode({super.key});

  @override
  State<RPDeliveryMode> createState() => _RPDeliveryModeState();
}

class _RPDeliveryModeState extends State<RPDeliveryMode> {
  bool isPickUpSelected = true; // Pick Up is now the default selected option
  String selectedAddress = ProjectStrings.rp_mode_address_label;
  String garageLocation = "";
  bool isLoading = true;
  String googleApiKey = Constants.DIRECTION_API_KEY;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getGarageLocationName();
    });
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      height: 65,
      color: Colors.white,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("lib/assets/pictures/left_arrow.png"),
            ),
          ),
          Center(
            child: CustomComponents.displayText(
              ProjectStrings.rp_mode_appbar_title,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getGarageLocationName() async {
    try {
      DocumentReference garageLocationDoc = FirebaseFirestore.instance.collection('dara-garage-location').doc('garage_location');
      DocumentSnapshot docSnapshot = await garageLocationDoc.get();

      if (docSnapshot.exists) {
        String latitude = docSnapshot['garage_location_latitude'] ?? "0";
        String longitude = docSnapshot['garage_location_longitude'] ?? "0";

        // Fetch the readable location name using the Geocoding API
        String address = await getAddressFromCoordinates(latitude, longitude);
        setState(() {
          garageLocation = address;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        CustomComponents.showToastMessage("Document does not exist!", Colors.red, Colors.white);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CustomComponents.showToastMessage("Error fetching garage location: $e", Colors.red, Colors.white);
      debugPrint("Error fetching garage location@delivery_mode.dart@getGarageLocationName: $e");
    }
  }

  // Function to get the address from latitude and longitude using Google Maps API
  Future<String> getAddressFromCoordinates(String latitude, String longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleApiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          // Get the formatted address from the results
          return data['results'][0]['formatted_address'] ?? "Unknown Address";
        } else {
          return "No address found";
        }
      } else {
        return "Failed to fetch address";
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CustomComponents.showToastMessage("Error fetching address: $e", Colors.red, Colors.white);
      debugPrint("Error fetching address@delivery_mode.dart@getAddressFromCoordinates: $e");
      return "Error occurred";
    }
  }

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
              isLoading ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(
                      color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                    ),
                  ),
                ),
              ) : Expanded(
                  child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 30),
                              child: Column(
                                children: [
                                  // Choose method
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomComponents.displayText(
                                      ProjectStrings.rp_mode_choose_method,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Pick Up option
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isPickUpSelected = true;
                                            selectedAddress = ProjectStrings.rp_mode_address_label;
                                          });
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width / 2 - 50,
                                          height: MediaQuery.of(context).size.width / 2 - 50,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            border: Border.all(
                                              width: isPickUpSelected ? 2 : 0,
                                              color: isPickUpSelected
                                                  ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                                                  : Colors.transparent,
                                            ),
                                            color: isPickUpSelected
                                                ? Colors.white
                                                : Colors.grey.shade100, // Dim effect
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                    child: Image.asset(
                                                      "lib/assets/pictures/delivery_mode_pick_up.png",
                                                      fit: BoxFit.fill,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: CustomComponents.displayText(
                                                  ProjectStrings.rp_mode_pick_up,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              const SizedBox(height: 10)
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Delivery option
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isPickUpSelected = false;
                                          });
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width / 2 - 50,
                                          height: MediaQuery.of(context).size.width / 2 - 50,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            border: Border.all(
                                              width: isPickUpSelected ? 0 : 2,
                                              color: isPickUpSelected
                                                  ? Colors.transparent
                                                  : Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                            ),
                                            color: isPickUpSelected
                                                ? Colors.grey.shade100
                                                : Colors.white, // Dim effect
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                    child: Image.asset(
                                                      "lib/assets/pictures/delivery_mode_delivery.png",
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: CustomComponents.displayText(
                                                  ProjectStrings.rp_mode_delivery,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              const SizedBox(height: 10)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //  pickup location
                                  const SizedBox(height: 30),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      CustomComponents.displayText(
                                        ProjectStrings.rp_mode_pickup_location,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: double.infinity,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Color(int.parse(
                                                ProjectColors.darkGray.substring(2),
                                                radix: 16)),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 4, bottom: 4),
                                              child: Icon(
                                                Icons.location_pin,
                                                color: Color(int.parse(
                                                    ProjectColors.darkGray.substring(2),
                                                    radix: 16)),
                                                size: 22,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: CustomComponents.displayText(
                                                      "$garageLocation",
                                                      fontSize: 10
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  //  delivery location
                                  const SizedBox(height: 30),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Ensures alignment to start
                                    children: [
                                      CustomComponents.displayText(
                                        ProjectStrings.rp_mode_delivery_location,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 7),
                                      GestureDetector(
                                        onTap: () async {
                                          if (!isPickUpSelected) {
                                            final selectedLocation = await Navigator.of(context).pushNamed("map_screen");

                                            if (selectedLocation != null) {
                                              setState(() {
                                                selectedAddress = selectedLocation as String;
                                              });
                                            }
                                          } else {
                                            InfoDialog().show(
                                                context: context,
                                                content: "The delivery location is only available when you chose the \"Delivery\" option.",
                                                header: "Warning"
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(
                                              color: Color(int.parse(
                                                  ProjectColors.darkGray.substring(2),
                                                  radix: 16)),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 4, bottom: 4),
                                                child: Icon(
                                                  Icons.location_pin,
                                                  color: Color(int.parse(
                                                      ProjectColors.darkGray.substring(2),
                                                      radix: 16)),
                                                  size: 22,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 15),
                                                  child: TextField(
                                                    readOnly: true,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Color(int.parse(
                                                            ProjectColors.darkGray
                                                                .substring(2),
                                                            radix: 16))),
                                                    decoration: InputDecoration(
                                                      hintText: selectedAddress, // Placeholder text
                                                      hintStyle: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey.shade600,
                                                          fontWeight: FontWeight.normal,
                                                          fontFamily: ProjectStrings
                                                              .general_font_family),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        borderRadius:
                                                        BorderRadius.circular(7),
                                                      ),
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

                                  //  notice
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomComponents.displayText(
                                        "Note:",
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomComponents.displayText(
                                        "Selecting the delivery option will incur an additional fee, which is calculated based on the distance between the garage and the selected delivery location, plus an applicable driver fee.",
                                        fontSize: 10,
                                        textAlign: TextAlign.start
                                    ),
                                  ),

                                  //  proceed button
                                  const SizedBox(height: 100),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStatePropertyAll<
                                              Color>(
                                              Color(int.parse(
                                                  ProjectColors.mainColorHex.substring(2),
                                                  radix: 16))),
                                          shape: MaterialStatePropertyAll<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(5)))),
                                      onPressed: () {
                                        PersistentData _persistentData = PersistentData();

                                        if (!isPickUpSelected && selectedAddress == ProjectStrings.rp_mode_address_label) {
                                          InfoDialog().show(
                                              context: context,
                                              content: "Delivery mode requires a specified delivery location. Please ensure the delivery location is selected before proceeding.",
                                              header: "Warning"
                                          );
                                        } else {
                                          _persistentData.deliveryModePickUpOrDelivery = isPickUpSelected ? "Pick Up" : "Delivery";
                                          _persistentData.deliveryModeLocation = isPickUpSelected ? garageLocation : selectedAddress;
                                          debugPrint("selected address: $selectedAddress");

                                          if (isPickUpSelected) {
                                            _persistentData.startMapsLatitude = _persistentData.latitudeForGarage;
                                            _persistentData.startMapsLongitude = _persistentData.longitudeForGarage;
                                            debugPrint("isPickUpselected - true");
                                          } else {
                                            _persistentData.startMapsLatitude = double.parse(_persistentData.mapsLatitude);
                                            _persistentData.startMapsLongitude = double.parse(_persistentData.mapsLongitude);
                                            debugPrint("isPickUpselected - false");
                                          }
                                          debugPrint("End maps latitude: ${_persistentData.startMapsLatitude}");
                                          debugPrint("End maps latitude: ${_persistentData.startMapsLongitude}");

                                          Navigator.of(context).pushNamed("rp_details_fees");
                                        }
                                      },
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                                          child: CustomComponents.displayText(
                                              ProjectStrings.rp_bk_proceed,
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 80)
                      ]
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
