// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dara_app/controller/utils/intent_utils.dart';
import 'package:dara_app/view/pages/admin/car_list/car_list_.dart';
import 'package:dara_app/view/pages/admin/home/main_home.dart';
import 'package:dara_app/view/pages/admin/profile/profile.dart';
import 'package:dara_app/view/pages/admin/rentals/rentals.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
        AdminHome(controller: _controller),
        const CarList(),
        const Profile(),
        const Rentals()
      ];
    }

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
      )
    ;
  }
}
