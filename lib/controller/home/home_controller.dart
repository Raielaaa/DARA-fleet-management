import 'package:dara_app/services/weather/open_weather.dart';
import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/weather.dart';

class HomeController {
  Future<List<List<String>>> getWeatherForecast() async {
    OpenWeather openWeather = OpenWeather();
    List<List<String>> forecastData = [];

    try {
      // Await the forecast retrieval
      List<Weather>? retrievedForecast = await openWeather.getWeatherForecastFromAPI();

      if (retrievedForecast != null) {
        // Loop through each Weather object in the list
        for (Weather weather in retrievedForecast) {
          String formattedDate;

          if (!weather.date.toString().contains("14:00:00")) {
            continue;
          }
          try {
            // Parse the date and format it
            DateTime weatherDate = DateTime.parse(weather.date.toString());
            formattedDate = DateFormat('E d').format(weatherDate);
          } catch (e) {
            debugPrint("Error formatting date: $e");
            formattedDate = "Unknown Date";  // Fallback in case of error
          }

          String temperature = weather.temperature?.celsius?.toString() ?? "N/A";
          String wind = weather.windSpeed.toString();
          String weatherCode = weather.weatherIcon.toString();

          // Store the data in a list and add it to forecastData
          debugPrint("Hello Controller - $formattedDate");
          forecastData.add(
            [formattedDate, temperature, wind, weatherCode]
          );
        }
      }
    } catch (e) {
      debugPrint("Error while retrieving weather forecast: $e");
    }

    return forecastData;
  }

  void makePhoneCall() async {
    var url = Uri.parse("tel:9701900391");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      //  error dialog
    }
  }

  void showMessageApp() async {
    // Android
    String body = "Please type your inquiry here.";
    Uri url = Uri.parse("sms:+63 0970 190 0391?body=$body");
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

  void showGmailApp() async {
    String email = Uri.encodeComponent("rbhonra@ccc.edu.ph");
    String subject = Uri.encodeComponent("DARA - Support Request");
    String body = Uri.encodeComponent("Please type your inquiry here.");

    Uri url = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {

    }
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

  Future<void> showOpeningBanner(BuildContext context) async {
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.asset(
                      "lib/assets/pictures/home_opening_banner.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double
                        .infinity, // Makes the button take the full width of the parent container
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
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double
                        .infinity, // Makes the button take the full width of the parent container
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
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

  Future<void> showContactBottomDialog(BuildContext context) async {
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
                    showGmailApp();
                  },
                  child: _bottomSheetContactItems(
                      "lib/assets/pictures/bottom_email.png",
                      ProjectStrings.to_bottom_email_title,
                      ProjectStrings.to_bottom_email_content),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    showMessageApp();
                  },
                  child: _bottomSheetContactItems(
                      "lib/assets/pictures/bottom_chat.png",
                      ProjectStrings.to_bottom_message_title,
                      ProjectStrings.to_bottom_message_content),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    makePhoneCall();
                  },
                  child: _bottomSheetContactItems(
                      "lib/assets/pictures/bottom_call.png",
                      ProjectStrings.to_bottom_call_title,
                      ProjectStrings.to_bottom_call_content),
                ),
                const SizedBox(height: 60),
              ],
            ),
          );
        });
  }

  Widget _bottomSheetContactItems(
      String imagePath, String contactTitle, String contactContent) {
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
