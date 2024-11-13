import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../controller/utils/intent_utils.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";

class IntegratedApps extends StatefulWidget {
  const IntegratedApps({super.key});

  @override
  State<IntegratedApps> createState() => _IntegratedAppsState();
}

class _IntegratedAppsState extends State<IntegratedApps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
            child: Padding(
                padding: const EdgeInsets.only(top: 38),
                child: Column(
                  children: [
                    appBar(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                            "System Connections",
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                            "View and access partner applications",
                            fontSize: 10
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        IntentUtils.launchAntripIOT(androidPackageName: "com.slxk.gpsantu");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Background circular container
                                        Container(
                                          width: 45,
                                          height: 45,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle, // Makes it circular
                                            color: Color(0xff0179ff),
                                          ),
                                        ),
                                        // Centered image on top of the circular background
                                        Image.asset(
                                          "lib/assets/pictures/bottom_nav_bar_antrip.png",
                                          width: 25,
                                          height: 25,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomComponents.displayText(
                                            "Antrip IOT",
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold
                                        ),
                                        const SizedBox(height: 3),
                                        CustomComponents.displayText(
                                            "System Application",
                                            fontSize: 10
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                CustomComponents.displayText(
                                  "visit application",
                                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 10
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        debugPrint("longitude-maps: ${PersistentData().longitudeForGarage}");
                        debugPrint("latitude-maps: ${PersistentData().latitudeForGarage}");
                        IntentUtils.launchGoogleMaps(PersistentData().longitudeForGarage, PersistentData().latitudeForGarage);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Background circular container
                                        Container(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFFF5F5F5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1), // Light shadow color
                                                blurRadius: 4, // How blurred the shadow will be
                                                offset: const Offset(0, 2), // Position of the shadow (slightly below the circle)
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Centered image on top of the circular background
                                        Image.asset(
                                          "lib/assets/pictures/google_maps_icon.png",
                                          width: 35,
                                          height: 35,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomComponents.displayText(
                                            "Google Maps",
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold
                                        ),
                                        const SizedBox(height: 3),
                                        CustomComponents.displayText(
                                            "Location Navigation",
                                            fontSize: 10
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                CustomComponents.displayText(
                                    "visit application",
                                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                    fontStyle: FontStyle.italic,
                                    fontSize: 10
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 65),
                  ],
                )
            )
        )
    );
  }

  Widget appBar() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 65,
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
            "Integrated Apps",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
