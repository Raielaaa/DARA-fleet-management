import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOpeningBanner();
    });
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
              mainAxisSize: MainAxisSize.min, // Adjust the height based on content
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
                  width: double.infinity, // Makes the button take the full width of the parent container
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
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
                  width: double.infinity, // Makes the button take the full width of the parent container
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
              ],
            ),
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
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
                        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 30, left: 30),
                        child: CustomComponents.displayText(
                          "Admin",
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
                          CustomComponents.displayText(
                            "Hello, Admin",
                            fontWeight: FontWeight.bold,
                          ),
                          CustomComponents.displayText(
                            "PH +63 ****** 8475",
                            fontWeight: FontWeight.w600,
                            color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "lib/assets/pictures/home_top_image.png",
                        fit: BoxFit.contain, // Ensure the image fits within its container
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
                                    ProjectStrings.admin_home_top_options_inquire,
                                    color: Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    //  contact
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
                                  "lib/assets/pictures/home_top_contact.png",
                                  fit: BoxFit.contain,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: CustomComponents.displayText(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    ProjectStrings.admin_home_top_options_contact,
                                    color: Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
                                  ),
                                )
                              ],
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
                                      ProjectStrings.admin_home_top_options_report,
                                      color: Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
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
                                    ProjectStrings.admin_home_top_options_settings,
                                    color: Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
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
                                      ProjectStrings.admin_home_top_options_manage,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
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
                            fontWeight: FontWeight.w600,
                          ),
                          CustomComponents.displayText(
                            ProjectStrings.admin_home_weather_date_placeholder,
                            color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                          borderRadius: BorderRadius.circular(7),
                        ),
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
                            fontWeight: FontWeight.w600,
                          ),
                          CustomComponents.displayText(
                            ProjectStrings.admin_home_featured_see_all,
                            color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
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
                                width: 250, // Set a specific width to your container
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "lib/assets/pictures/car_list_placeholder_accent.png",
                                            fit: BoxFit.contain, // Ensure the image fits within its container
                                          ),
                                        ),
                                      ),
                                      CustomComponents.displayText(
                                        ProjectStrings.admin_home_car_info_placeholder_name_1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomComponents.displayText(
                                            ProjectStrings.admin_home_car_info_placeholder_1,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings.admin_home_car_info_placeholder_2,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings.admin_home_car_info_placeholder_3,
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomComponents.displayText(
                                              ProjectStrings.admin_home_car_info_placeholder_price,
                                              fontWeight: FontWeight.w600,
                                              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                              fontSize: 12,
                                            ),
                                            Icon(
                                              Icons.list,
                                              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
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
                                width: 250, // Set a specific width to your container
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "lib/assets/pictures/car_list_placeholder_innova.png",
                                            fit: BoxFit.contain, // Ensure the image fits within its container
                                          ),
                                        ),
                                      ),
                                      CustomComponents.displayText(
                                        ProjectStrings.admin_home_car_info_placeholder_name_2,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomComponents.displayText(
                                            ProjectStrings.admin_home_car_info_placeholder_1,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings.admin_home_car_info_placeholder_2,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings.admin_home_car_info_placeholder_3,
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomComponents.displayText(
                                              ProjectStrings.admin_home_car_info_placeholder_price,
                                              fontWeight: FontWeight.w600,
                                              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                              fontSize: 12,
                                            ),
                                            Icon(
                                              Icons.list,
                                              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
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
                                width: 250, // Set a specific width to your container
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "lib/assets/pictures/car_list_placeholder_mirrage.png",
                                            fit: BoxFit.contain, // Ensure the image fits within its container
                                          ),
                                        ),
                                      ),
                                      CustomComponents.displayText(
                                        ProjectStrings.admin_home_car_info_placeholder_name_3,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomComponents.displayText(
                                            ProjectStrings.admin_home_car_info_placeholder_1,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings.admin_home_car_info_placeholder_2,
                                            fontSize: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Container(
                                              width: 1,
                                              height: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          CustomComponents.displayText(
                                            ProjectStrings.admin_home_car_info_placeholder_3,
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomComponents.displayText(
                                              ProjectStrings.admin_home_car_info_placeholder_price,
                                              fontWeight: FontWeight.w600,
                                              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                              fontSize: 12,
                                            ),
                                            Icon(
                                              Icons.list,
                                              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
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
                            padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CustomComponents.displayText(
                                ProjectStrings.admin_home_banner_header,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          SizedBox(
                            height: 125,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      width: 290,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7)
                                      ),
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
                                        borderRadius: BorderRadius.circular(7)
                                      ),
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
                                        borderRadius: BorderRadius.circular(7)
                                      ),
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
