import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/model/constants/firebase_constants.dart';
import 'package:dara_app/services/firebase/firestore.dart';
import 'package:dara_app/services/weather/open_weather.dart';
import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/info_dialog.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/weather.dart';

import '../../model/home/featured_car_info.dart';
import '../utils/constants.dart';

class HomeController {
  final Firestore _firestore = Firestore();

  Future<List<FeaturedCarInfo>> fetchCars() {
    return _firestore.getCars();
  }

  Future<List<List<String>>> getWeatherForecast(double? selectedLongitude, double? selectedLatitude) async {
    OpenWeather openWeather = OpenWeather();
    List<List<String>> forecastData = [];

    try {
      // Await the forecast retrieval
      List<Weather>? retrievedForecast =
          await openWeather.getWeatherForecastFromAPI(selectedLongitude, selectedLatitude);

      if (retrievedForecast != null) {
        // Loop through each Weather object in the list
        for (Weather weather in retrievedForecast) {
          String formattedDate;

          if (!weather.date.toString().contains("08:00:00")) {
            continue;
          }
          try {
            // Parse the date and format it
            DateTime weatherDate = DateTime.parse(weather.date.toString());
            formattedDate = DateFormat('E d').format(weatherDate);
          } catch (e) {
            debugPrint("Error formatting date: $e");
            formattedDate = "Unknown Date"; // Fallback in case of error
          }

          String temperature = weather.temperature?.celsius?.toString() ?? "N/A";
          String wind = weather.windSpeed.toString();
          String weatherCode = weather.weatherIcon.toString();

          // Store the data in a list and add it to forecastData
          forecastData.add([formattedDate, temperature, wind, weatherCode]);
        }
      }
    } catch (e) {
      debugPrint("Error while retrieving weather forecast: $e");
    }

    return forecastData;
  }

  void makePhoneCall({
    String number = "09701900391"
}) async {
    var url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      //  error dialog
    }
  }

  void showMessageApp({
    String number = "09971263452"
  }) async {
    // Android
    String body = "Please type your inquiry here.";
    Uri url = Uri.parse("sms:$number?body=$body");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // iOS
      Uri url = Uri.parse("sms:0039-222-060-888?body=$body");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        //  error dialog
      }
    }
  }

  void showGmailApp({
    String userEmail = "donalpha.transportservice@gmail.com"
}) async {
    String email = Uri.encodeComponent(userEmail);
    String subject = Uri.encodeComponent("DARA - Support Request");
    String body = Uri.encodeComponent("Please type your inquiry here.");

    Uri url = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {}
  }

  String getCurrentDate() {
    //  Get the current date
    DateTime dateTime = DateTime.now();

    //  date format
    DateFormat formatter = DateFormat("MMMM dd, yyyy");

    //  format current date
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }

  Future<void> showOpeningBanner(BuildContext context, int filesLength) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width - 10,
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Adjust the height based on content
                children: [
                  GestureDetector(
                    onTap: () {
                      _launchFacebookURL(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.network(
                        PersistentData().popupImageUrls[0],
                        fit: BoxFit.fitWidth,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            // Image has finished loading
                            return child;
                          } else {
                            // Show circular progress indicator while loading
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double
                        .infinity, // Makes the button take the full width of the parent container
                    child: GestureDetector(
                      onTap: () {
                        _launchFacebookURL(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(int.parse(
                              ProjectColors.mainColorHex.substring(2),
                              radix: 16)),
                        ),
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child: CustomComponents.displayText(
                            "Check more offers",
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double
                        .infinity, // Makes the button take the full width of the parent container
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        debugPrint("Files length: $filesLength............${filesLength == 5}");
                        debugPrint("Number: ${PersistentData().userInfo!.number}..............${PersistentData().userInfo!.number.isNotEmpty}");
                        if (PersistentData().userInfo!.number.isNotEmpty && filesLength == 5 && PersistentData().userInfo?.status.toLowerCase() != "verified") {
                          InfoDialog().show(
                              context: context,
                              content: "Your account is currently under review. Please await admin approval before proceeding.",
                              header: "Notice"
                          );
                        } else if (PersistentData().userInfo!.number.isEmpty || filesLength < 5) {
                          InfoDialog().show(
                              context: context,
                              content: "Your account is unverified. Please verify your phone number and submit all required documents to access full features.",
                              header: "Warning"
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.transparent,
                          border: Border.all(
                            width: 1,
                            color: Colors.white,
                          ),
                        ),
                        height: 35,
                        child: Align(
                          alignment: Alignment.center,
                          child: CustomComponents.displayText(
                            "Close",
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _launchFacebookURL(BuildContext context) async {
    const url = "https://www.facebook.com/profile.php?id=61565665724728";
    await launchUrl(Uri.parse(url));
    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url));
    // } else {
    //   InfoDialog().show(context: context, content: "Could not launch $url", header: "Warning");
    //
    //   throw 'Could not launch $url';
    // }
  }

  void topOptionManageAccessibility(BuildContext context) {
    switch (PersistentData().userType) {
      case "Admin":
        {
          Navigator.of(context).pushNamed("manage_report");
          break;
        }
      case "Accountant":
        {
          Navigator.of(context).pushNamed("to_manage_accountant");
          break;
        }
      case "Driver":
        {
          if (PersistentData().userInfo?.status.toLowerCase() == "verified") {
            _showInformationDialog(context);
            break;
          } else {
            InfoDialog().show(
                context: context,
                header: "Account Verification Required",
                content: "Please verify your account to access this feature."
            );
            break;
          }
        }
      case "Outsource":
        {
          if (PersistentData().userInfo?.status.toLowerCase() == "verified") {
            Navigator.of(context).pushNamed("manage_outsource");
            break;
          } else {
            InfoDialog().show(
                context: context,
                header: "Account Verification Required",
                content: "Please verify your account to access this feature."
            );
            break;
          }
          break;
        }
      case "Renter":
        {
          InfoDialog().show(
            context: context,
            content: ProjectStrings.home_top_option_manage_no_access_content,
            header: ProjectStrings.home_top_option_manage_no_access_title
          );
        }
    }
  }

  /////////////////////////////////////// for drivers /////////////////////////////////////////////////////////////////////////////////////////////
  int _informationDialogCurrentIndex = 0;
  final List<Map<String, String>> guides = [
    {
      "title": ProjectStrings.driver_information_carousel_personal_info_header,
      "content": ProjectStrings.driver_information_carousel_personal_info_subheader
    },
    {
      "title": ProjectStrings.driver_information_carousel_emergency_contact_header,
      "content": ProjectStrings.driver_information_carousel_emergency_contact_subheader
    },
    {
      "title": ProjectStrings.driver_information_carousel_educ_prof_header,
      "content": ProjectStrings.driver_information_carousel_educ_prof_subheader
    },
    {
      "title": ProjectStrings.driver_information_carousel_supp_doc_header,
      "content": ProjectStrings.driver_information_carousel_supp_doc_subheader
    }
  ];

  void _showInformationDialog(BuildContext contextParent) {
    showDialog(
      context: contextParent,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Color(int.parse(
              ProjectColors.mainColorBackground.substring(2),
              radix: 16)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Image.asset(
                          "lib/assets/pictures/exit.png",
                          width: 30,
                        ),
                      ),
                    ),
                    //  left arrow - main image - right arrow
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_informationDialogCurrentIndex > 0) {
                                _informationDialogCurrentIndex--;
                              }
                            });
                          },
                          child: Image.asset(
                            "lib/assets/pictures/id_left_arrow.png",
                            width: 30,
                          ),
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                            child: KeyedSubtree(
                              key:
                              ValueKey<int>(_informationDialogCurrentIndex),
                              child: Image.asset(
                                  "lib/assets/pictures/information_dialog.png"),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_informationDialogCurrentIndex <
                                  guides.length - 1) {
                                _informationDialogCurrentIndex++;
                              } else {
                                Navigator.of(contextParent).pushNamed("driver_ap_personal_information");
                                Navigator.of(context).pop();
                              }
                            });
                          },
                          child: Image.asset(
                              "lib/assets/pictures/id_right_arrow.png",
                              width: 30),
                        ),
                      ],
                    ),
                    //  indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(guides.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _informationDialogCurrentIndex == index
                                ? Color(int.parse(
                                ProjectColors.mainColorHex.substring(2),
                                radix: 16))
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                    //  title
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: KeyedSubtree(
                          key: ValueKey<int>(_informationDialogCurrentIndex),
                          child: CustomComponents.displayText(
                            guides[_informationDialogCurrentIndex]["title"]!,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    //  content
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: KeyedSubtree(
                          key:
                          ValueKey<int>(_informationDialogCurrentIndex + 1),
                          child: CustomComponents.displayText(
                            textAlign: TextAlign.center,
                            guides[_informationDialogCurrentIndex]["content"]!,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    //  spacer
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> showContactBottomDialog(BuildContext context, {
    String number = "09971263452",
    String email = "donalpha.transportservices@gmail.coom"
  }) async {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomComponents.displayText(ProjectStrings.to_bottom_title,
                    fontSize: 12, fontWeight: FontWeight.bold),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showGmailApp(userEmail: email);
                  },
                  child: _bottomSheetContactItems(
                      "lib/assets/pictures/bottom_email.png",
                      ProjectStrings.to_bottom_email_title,
                      email),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    showMessageApp(number: number);
                  },
                  child: _bottomSheetContactItems(
                      "lib/assets/pictures/bottom_chat.png",
                      ProjectStrings.to_bottom_message_title,
                      number),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    makePhoneCall(number: number);
                  },
                  child: _bottomSheetContactItems(
                      "lib/assets/pictures/bottom_call.png",
                      ProjectStrings.to_bottom_call_title,
                      number),
                ),
                const SizedBox(height: 60),
              ],
            ),
          );
        });
  }

  Widget _bottomSheetContactItems(
    String imagePath,
    String contactTitle,
    String contactContent
  ) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 38,
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomComponents.displayText(contactTitle,
                fontSize: 10, fontWeight: FontWeight.bold),
            const SizedBox(height: 3),
            CustomComponents.displayText(contactContent, fontSize: 10)
          ],
        )
      ],
    );
  }
}
