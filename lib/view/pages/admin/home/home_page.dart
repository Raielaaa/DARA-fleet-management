// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/controller/utils/intent_utils.dart';
import 'package:dara_app/view/pages/admin/car_list/car_list_.dart';
import 'package:dara_app/view/pages/admin/home/main_home.dart';
import 'package:dara_app/view/pages/admin/profile/profile.dart';
import 'package:dara_app/view/pages/admin/rentals/rentals.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    PersistentData().scaffoldKey = _key;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Calls showDialog method right after screen display
      showSuccessfulRegisterSnackbar();
    });
  }

  // Shows dialog if the previous registration process is successful
  void showSuccessfulRegisterSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Login Successful",
          style: TextStyle(
            fontFamily: ProjectStrings.general_font_family,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      AdminHome(controller: _controller),
      const CarList(),
      const Profile(),
      const Rentals()
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<PersistentTabConfig> _navBarsItems() {
      return [
        PersistentTabConfig(
          screen: AdminHome(controller: _controller),
          item: ItemConfig(
            icon: const Icon(Icons.home_rounded),
            title: "Home",
            textStyle: const TextStyle(
              fontSize: 10,
              fontFamily: ProjectStrings.general_font_family,
            ),
            activeForegroundColor: CupertinoColors.activeBlue,
            inactiveForegroundColor: CupertinoColors.systemGrey,
          ),
        ),
        PersistentTabConfig(
          screen: const CarList(),
          item: ItemConfig(
            icon: const Icon(Icons.explore),
            title: "Explore",
            textStyle: const TextStyle(
              fontSize: 10,
              fontFamily: ProjectStrings.general_font_family,
            ),
            activeForegroundColor: CupertinoColors.activeBlue,
            inactiveForegroundColor: CupertinoColors.systemGrey,
          ),
        ),
        PersistentTabConfig.noScreen(
          item: ItemConfig(
            icon: Tab(
              icon: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  "lib/assets/pictures/bottom_nav_bar_antrip.png",
                ),
              )
            ),
            title: " ",
            activeForegroundColor: CupertinoColors.activeBlue,
            inactiveForegroundColor: CupertinoColors.activeBlue,
          ),
          onPressed: (context) {
            IntentUtils.launchAntripIOT(androidPackageName: "com.slxk.gpsantu");
          }
        ),
        PersistentTabConfig(
          screen: const Rentals(),
          item: ItemConfig(
            icon: const Icon(Icons.car_crash),
            title: "Rentals",
            textStyle: const TextStyle(
              fontSize: 10,
              fontFamily: ProjectStrings.general_font_family,
            ),
            activeForegroundColor: CupertinoColors.activeBlue,
            inactiveForegroundColor: CupertinoColors.systemGrey,
          ),
        ),
        PersistentTabConfig(
          screen: const Profile(),
          item: ItemConfig(
            icon: const Icon(Icons.person),
            title: "Profile",
            textStyle: const TextStyle(
              fontSize: 10,
              fontFamily: ProjectStrings.general_font_family,
            ),
            activeForegroundColor: CupertinoColors.activeBlue,
            inactiveForegroundColor: CupertinoColors.systemGrey,
          ),
        ),
      ];
    }

    return Scaffold(
      key: _key,
      drawer: Padding(
        padding: const EdgeInsets.only(top: 50, left: 13, bottom: 15),
        child: drawerUI()
      ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 55),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () async {
              await IntentUtils.launchGoogleMaps();
            },
            shape: const CircleBorder(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "lib/assets/pictures/google_maps_icon.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        body: PersistentTabView(
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          stateManagement: true,
          controller: _controller,
          popAllScreensOnTapOfSelectedTab: true,
          tabs: _navBarsItems(),
          navBarBuilder: (navBarConfig) => Style13BottomNavBar(
            navBarConfig: navBarConfig,
          ),
        ),
      );
  }

  Widget drawerUI() {
    return Drawer(
      // Give the drawer a margin and apply a shape for rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(int.parse("0xfffd6057")),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(int.parse("0xfffcbc2e")),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(int.parse("0xff30c840")),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: UnconstrainedBox(
                  child: Row(
                    children: [
                      Image.asset(
                        "lib/assets/pictures/app_logo_circle.png",
                        width: 100,
                      ),
                      const SizedBox(width: 5),
                      // Create a container with a fixed height
                      Container(
                        height: 22, // Adjust height as needed
                        alignment: Alignment.bottomLeft, // Align to the bottom
                        child: CustomComponents.displayText(
                          "v1.0",
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Add more items if needed below
            ],
          ),
        ),
      ),
    );
  }

}
