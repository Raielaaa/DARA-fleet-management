import "package:dara_app/controller/home/home_controller.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import 'package:url_launcher/url_launcher.dart';

class AdminHome extends StatefulWidget {
  final PersistentTabController controller;

  const AdminHome({super.key, required this.controller});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late Future<List<List<String>>> weatherFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future directly in initState
    HomeController homeController = HomeController();
    weatherFuture = homeController.getWeatherForecast();

    // Optionally, show the opening banner after initializing the future
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOpeningBanner();
      debugPrint("User type - ${PersistentData().userType}");
    });
  }

  Future<void> _showContactBottomDialog() async {
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

  Future<void> _showOpeningBanner() async {
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

  Widget weatherWidget() {
    return FutureBuilder<List<List<String>>>(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // LoadingDialog().show(context: context, content: "Retrieving weather data from the database");

            return const Center(
              child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4.0,
                  )),
            );
          } else {
            // Dismiss the loading dialog when data is ready or error occurs
            // LoadingDialog().dismiss();

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No weather data available'));
            } else {
              List<List<String>> weatherData = snapshot.data!;

              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomComponents.displayText(
                          weatherData[index][0],
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        Image.network(
                          "http://openweathermap.org/img/wn/${weatherData[index][3]}@4x.png",
                          width: MediaQuery.of(context).size.width / 4 - 15,
                        ),
                        CustomComponents.displayText(
                          "${weatherData[index][1].split(".")[0]} ${ProjectStrings.admin_home_weather_temp_placeholder}",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        CustomComponents.displayText(
                          "${weatherData[index][2].split(".")[0]}${ProjectStrings.admin_home_weather_wind_placeholder}",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ],
                    );
                  }));
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
            radix: 16)),
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              //  Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "lib/assets/pictures/app_logo_circle.png",
                      width: 120.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(int.parse(
                            ProjectColors.mainColorHex.substring(2),
                            radix: 16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 30, left: 30),
                        child: CustomComponents.displayText(
                          PersistentData().userType,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomComponents.displayText("Hello, Admin",
                              fontWeight: FontWeight.bold, fontSize: 14),
                          CustomComponents.displayText(
                            "PH +63 ****** 8475",
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: Color(int.parse(
                                ProjectColors.lightGray.substring(2),
                                radix: 16)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "lib/assets/pictures/home_top_image.png",
                        fit: BoxFit
                            .contain, // Ensure the image fits within its container
                      ),
                    ),
                  ],
                ),
              ),

              //  Top options
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    //  inquire
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            widget.controller.jumpToTab(1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white38,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "lib/assets/pictures/home_logo_inquire.png",
                                    fit: BoxFit.contain,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7),
                                    child: CustomComponents.displayText(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      ProjectStrings
                                          .admin_home_top_options_inquire,
                                      color: Color(int.parse(
                                          ProjectColors.darkGray.substring(2),
                                          radix: 16)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //  contact
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            _showContactBottomDialog();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white38,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "lib/assets/pictures/home_top_contact.png",
                                    fit: BoxFit.contain,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7),
                                    child: CustomComponents.displayText(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      ProjectStrings
                                          .admin_home_top_options_contact,
                                      color: Color(int.parse(
                                          ProjectColors.darkGray.substring(2),
                                          radix: 16)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //  report
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("to_report");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white38,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "lib/assets/pictures/home_top_report.png",
                                    fit: BoxFit.contain,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7),
                                    child: CustomComponents.displayText(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      ProjectStrings
                                          .admin_home_top_options_report,
                                      color: Color(int.parse(
                                          ProjectColors.darkGray.substring(2),
                                          radix: 16)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //  settings
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white38,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  "lib/assets/pictures/home_top_settings.png",
                                  fit: BoxFit.contain,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: CustomComponents.displayText(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    ProjectStrings
                                        .admin_home_top_options_settings,
                                    color: Color(int.parse(
                                        ProjectColors.darkGray.substring(2),
                                        radix: 16)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    //  manage
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("manage_report");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white38,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "lib/assets/pictures/home_top_manage.png",
                                    fit: BoxFit.contain,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7),
                                    child: CustomComponents.displayText(
                                      ProjectStrings
                                          .admin_home_top_options_manage,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.darkGray.substring(2),
                                          radix: 16)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    //  Weather
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings.admin_home_weather_header,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          CustomComponents.displayText(
                            "${ProjectStrings.admin_home_weather_date_placeholder} ${HomeController().getCurrentDate()}",
                            color: Color(int.parse(
                                ProjectColors.lightGray.substring(2),
                                radix: 16)),
                            fontStyle: FontStyle.italic,
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(int.parse(
                                ProjectColors.mainColorHex.substring(2),
                                radix: 16)),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: weatherWidget()
                          )
                      ),
                    ),
                    //  Featured
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings.admin_home_featured_header,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          CustomComponents.displayText(
                            ProjectStrings.admin_home_featured_see_all,
                            color: Color(int.parse(
                                ProjectColors.mainColorHex.substring(2),
                                radix: 16)),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: SizedBox(
                        height: 190.0, // Set a specific height
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            //  First static item
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Container(
                                width:
                                    250, // Set a specific width to your container
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "lib/assets/pictures/car_list_placeholder_accent.png",
                                            fit: BoxFit
                                                .contain, // Ensure the image fits within its container
                                          ),
                                        ),
                                      ),
                                      CustomComponents.displayText(
                                        ProjectStrings
                                            .admin_home_car_info_placeholder_name_1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomComponents.displayText(
                                            ProjectStrings
                                                .admin_home_car_info_placeholder_1,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings
                                                .admin_home_car_info_placeholder_2,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings
                                                .admin_home_car_info_placeholder_3,
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomComponents.displayText(
                                              ProjectStrings
                                                  .admin_home_car_info_placeholder_price,
                                              fontWeight: FontWeight.w600,
                                              color: Color(int.parse(
                                                  ProjectColors.mainColorHex
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 12,
                                            ),
                                            Icon(
                                              Icons.list,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //  Second static item
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Container(
                                width:
                                    250, // Set a specific width to your container
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "lib/assets/pictures/car_list_placeholder_innova.png",
                                            fit: BoxFit
                                                .contain, // Ensure the image fits within its container
                                          ),
                                        ),
                                      ),
                                      CustomComponents.displayText(
                                        ProjectStrings
                                            .admin_home_car_info_placeholder_name_2,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomComponents.displayText(
                                            ProjectStrings
                                                .admin_home_car_info_placeholder_1,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings
                                                .admin_home_car_info_placeholder_2,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings
                                                .admin_home_car_info_placeholder_3,
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomComponents.displayText(
                                              ProjectStrings
                                                  .admin_home_car_info_placeholder_price,
                                              fontWeight: FontWeight.w600,
                                              color: Color(int.parse(
                                                  ProjectColors.mainColorHex
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 12,
                                            ),
                                            Icon(
                                              Icons.list,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //  Third static item
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Container(
                                width:
                                    250, // Set a specific width to your container
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "lib/assets/pictures/car_list_placeholder_mirrage.png",
                                            fit: BoxFit
                                                .contain, // Ensure the image fits within its container
                                          ),
                                        ),
                                      ),
                                      CustomComponents.displayText(
                                        ProjectStrings
                                            .admin_home_car_info_placeholder_name_3,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomComponents.displayText(
                                            ProjectStrings
                                                .admin_home_car_info_placeholder_1,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings
                                                .admin_home_car_info_placeholder_2,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings
                                                .admin_home_car_info_placeholder_3,
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomComponents.displayText(
                                              ProjectStrings
                                                  .admin_home_car_info_placeholder_price,
                                              fontWeight: FontWeight.w600,
                                              color: Color(int.parse(
                                                  ProjectColors.mainColorHex
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 12,
                                            ),
                                            Icon(
                                              Icons.list,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //  Banner
                    const SizedBox(height: 20),
                    Container(
                      color: Colors.grey[300],
                      width: double.infinity,
                      height: 200,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CustomComponents.displayText(
                                  ProjectStrings.admin_home_banner_header,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 125,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      width: 290,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.asset(
                                          "lib/assets/pictures/home_bottom_banner_1.jpg",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      width: 290,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.asset(
                                          "lib/assets/pictures/home_bottom_banner_2.jpg",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      width: 290,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.asset(
                                          "lib/assets/pictures/home_bottom_banner_3.jpg",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 40)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
