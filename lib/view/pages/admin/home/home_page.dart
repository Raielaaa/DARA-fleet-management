// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/controller/utils/intent_utils.dart';
import 'package:dara_app/view/pages/admin/car_list/car_list_.dart';
import 'package:dara_app/view/pages/admin/home/main_home.dart';
import 'package:dara_app/view/pages/admin/profile/profile.dart';
import 'package:dara_app/view/pages/admin/rentals/rentals.dart';
import 'package:dara_app/view/shared/colors.dart';
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
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedDrawerIndex = 0;

  @override
  void initState() {
    super.initState();
    PersistentData().scaffoldKey = scaffoldKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Calls showDialog method right after screen display
      showSuccessfulRegisterSnackbar();
    });

    // Set the callback to update local state
    PersistentData().onDrawerIndexChanged = (index) {
      setState(() {
        selectedDrawerIndex = index;
      });
    };

    PersistentData().scaffoldKey = scaffoldKey; // Set the scaffold key in the singleton
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
      key: scaffoldKey,
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
      drawerEnableOpenDragGesture: false,
      );
  }

  Widget drawerUI() {
    int selectedIndex = PersistentData().selectedDrawerIndex;

    return Drawer(
      // Give the drawer a margin and apply a shape for rounded corners
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
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

              // navigation items
              //  home
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  PersistentData().openDrawer(0);
                  _controller.jumpToTab(0);
                  Navigator.of(context).pop();
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "lib/assets/pictures/drawer_dashboards.png",
                        width: 15,
                        color: selectedIndex == 0 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff7a7b7e),
                      ),
                      const SizedBox(width: 18),
                      CustomComponents.displayText(
                          "Home",
                          fontSize: 12,
                        color: selectedIndex == 0 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff404040),
                        fontWeight: selectedIndex == 0 ? FontWeight.bold : FontWeight.normal
                      )
                    ]
                ),
              ),
              //  explore
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  PersistentData().openDrawer(1);
                  _controller.jumpToTab(1);
                  Navigator.of(context).pop();
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "lib/assets/pictures/drawer_explore.png",
                        width: 16,
                        color: selectedIndex == 1 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff7a7b7e),
                      ),
                      const SizedBox(width: 17),
                      CustomComponents.displayText(
                          "Explore",
                          fontSize: 12,
                          color: selectedIndex == 1 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff404040),
                          fontWeight: selectedIndex == 1 ? FontWeight.bold : FontWeight.normal
                      )
                    ]
                ),
              ),
              //  rentals
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  PersistentData().openDrawer(2);
                  _controller.jumpToTab(3);
                  Navigator.of(context).pop();
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "lib/assets/pictures/drawer_rental.png",
                        width: 20,
                        color: selectedIndex == 2 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff7a7b7e),
                      ),
                      const SizedBox(width: 13),
                      CustomComponents.displayText(
                          "Rentals",
                          fontSize: 12,
                          color: selectedIndex == 2 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff404040),
                          fontWeight: selectedIndex == 2 ? FontWeight.bold : FontWeight.normal
                      )
                    ]
                ),
              ),
              //  profile
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  PersistentData().openDrawer(3);
                  _controller.jumpToTab(4);
                  Navigator.of(context).pop();
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "lib/assets/pictures/drawer_profile.png",
                        width: 18,
                        color: selectedIndex == 3 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff7a7b7e),
                      ),
                      const SizedBox(width: 15),
                      CustomComponents.displayText(
                          "Profile",
                          fontSize: 12,
                          color: selectedIndex == 3 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff404040),
                          fontWeight: selectedIndex == 3 ? FontWeight.bold : FontWeight.normal
                      )
                    ]
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              CustomComponents.displayText(
                  "App Details",
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),

              //  terms
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  PersistentData().selectedDrawerIndex = 4;
                  // Navigator.of(context).pushNamed("rentals");
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "lib/assets/pictures/drawer_terms.png",
                        width: 16,
                        color: selectedIndex == 4 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff7a7b7e),
                      ),
                      const SizedBox(width: 15),
                      CustomComponents.displayText(
                          "Terms",
                          fontSize: 12,
                          color: selectedIndex == 4 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff404040),
                          fontWeight: selectedIndex == 4 ? FontWeight.bold : FontWeight.normal
                      )
                    ]
                ),
              ),
              //  about
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  PersistentData().selectedDrawerIndex = 5;
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "lib/assets/pictures/drawer_about.png",
                        width: 17,
                        color: selectedIndex == 5 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff7a7b7e),
                      ),
                      const SizedBox(width: 15),
                      CustomComponents.displayText(
                          "About",
                          fontSize: 12,
                          color: selectedIndex == 5 ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) : const Color(0xff404040),
                          fontWeight: selectedIndex == 5 ? FontWeight.bold : FontWeight.normal
                      )
                    ]
                ),
              ),

              const SizedBox(height:30),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)))
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        backgroundImage: AssetImage('lib/assets/pictures/user_info_user.png'), // Default image
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomComponents.displayText(
                            PersistentData().userInfo?.firstName == null ? "John Mark Reyes" : "${PersistentData().userInfo?.firstName} ${PersistentData().userInfo?.lastName}",
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),
                          const SizedBox(height: 3),
                          CustomComponents.displayText(
                              PersistentData().userInfo?.email == null ? "johnmarkreyes@gmail.com" : "${PersistentData().userInfo?.email}",
                            fontSize: 10,
                            color: Colors.grey
                          )
                        ],
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.more_horiz,
                        color: Color(0xff404040)
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
