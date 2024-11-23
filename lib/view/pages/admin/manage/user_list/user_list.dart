import "dart:math";

import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/model/account/register_model.dart";
import "package:dara_app/view/pages/admin/manage/user_list/SortFilterDrawer.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";

import "../../../../../controller/admin_manage/user_list/user_list_controller.dart";

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserListController _userListController = UserListController();
  late List<RegisterModel> originalData;
  late List<RegisterModel> retrievedData;
  List<RegisterModel> renterList = [];
  List<RegisterModel> driverList = [];
  List<RegisterModel> outsourceList = [];
  bool _isLoading = true;

  String _key = '';
  String _value = '';
  String _searchQuery = '';

  void _applySortAndFilter(String key, String value) {
    setState(() {
      _key = key;
      _value = value;
    });

    // Refresh the list based on the selected sort and filter options
    _updateUserList();
  }

  Future<void> _updateUserList() async {
    // Start with the original data
    List<RegisterModel> filteredList = List.from(originalData);

    // Apply filters based on the selected value
    if (_value == "verified") {
      filteredList = filteredList.where((item) => item.status.toLowerCase() == "verified").toList();
    } else if (_value == "unverified") {
      filteredList = filteredList.where((item) => item.status.toLowerCase() == "unverified").toList();
    } else if (_value == "renter") {
      filteredList = filteredList.where((item) => item.role.toLowerCase() == "renter").toList();
    } else if (_value == "outsource") {
      filteredList = filteredList.where((item) => item.role.toLowerCase() == "outsource").toList();
    } else if (_value == "driver") {
      filteredList = filteredList.where((item) => item.role.toLowerCase() == "driver").toList();
    } else if (_value == "clear") {
      // If 'clear' is selected, show all original data
      filteredList = List.from(originalData);
    }

    // search filter function
    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((item) =>
      item.firstName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.lastName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.number.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.email.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Update the state with the filtered data
    setState(() {
      retrievedData = filteredList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      retrieveUserList();
    });
  }

  Future<void> _refreshPage() async {
    LoadingDialog().show(context: context, content: "Please wait while we refresh the page.");
    await retrieveUserList();
    LoadingDialog().dismiss();
  }

  Future<void> retrieveUserList() async {
    originalData = await _userListController.getCompleteUserList();

    setState(() {
      for (var item in originalData) {
        if (item.role.toLowerCase() == "renter") {
          renterList.add(item);
        } else if (item.role.toLowerCase() == "outsource") {
          outsourceList.add(item);
        } else if (item.role.toLowerCase() == "driver") {
          driverList.add(item);
        }
        debugPrint("counter");
      }
      retrievedData = originalData;
      _isLoading = false;
    });
  }

  void _searchUserList(String query) {
    setState(() {
      _searchQuery = query; // Update the search query
    });

    _updateUserList(); // Update the user list based on the search query
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SortFilterDrawer(onApply: _applySortAndFilter),
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              _actionBar(),

              // title and subheader
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(ProjectStrings.admin_user_list_header,
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                      ProjectStrings.admin_user_list_subheader,
                      fontSize: 10),
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _searchAndFilterBar(),
              ),

              const SizedBox(height: 20),
              _userListItems(),
              const SizedBox(height: 70)
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchAndFilterBar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.white,
          width: 0.0
        )
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.search,
              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
              size: 25,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 170,
              child: TextField(
                onChanged: _searchUserList,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: ProjectStrings.admin_user_list_search,
                  labelStyle: TextStyle(
                    fontFamily: ProjectStrings.general_font_family,
                    fontSize: 10,
                    color: Color(int.parse(ProjectColors.lineGray))
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none
                ),
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: ProjectStrings.general_font_family
                ),
              ),
            ),
            SizedBox(
              width: 20,
              height: 20,
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                child: Image.asset(
                  "lib/assets/pictures/settings.png",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getInitials(String input) {
    // Split the string into words
    List<String> words = input.split(' ');

    // Filter out numeric words
    List<String> filteredWords = words.where((word) => !RegExp(r'^\d+$').hasMatch(word)).toList();

    // Ensure there are at least two non-numeric words
    if (filteredWords.length < 2) return '';

    // Get the first letter of the first two non-numeric words
    String firstInitial = filteredWords[0][0];
    String secondInitial = filteredWords[1][0];

    // Combine them and return
    return firstInitial + secondInitial;
  }

  Widget _designPerItem({
    required String imagePath,
    required String userName,
    required String userContactNumber,
    required String userEmail,
    required String userStatus,
    required String userType,
    required String userProfilePicPath,
    required RegisterModel selectedUserInformation
  }) {
    final colors = [
      const Color(0xff0564ff),
      const Color(0xff00be15),
      const Color(0xfffe7701),
      const Color(0xffffb103),
      const Color(0xffe93c2e),
    ];

    // Select a random color
    final randomColor = colors[Random().nextInt(colors.length)];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Constrain Column height
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: randomColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      getInitials(userName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomComponents.displayText(
                          userName,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            CustomComponents.displayText(
                              ProjectStrings.admin_user_list_contact_no_title,
                              fontSize: 10,
                            ),
                            CustomComponents.displayText(
                              userContactNumber,
                              fontSize: 10,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CustomComponents.displayText(
                              ProjectStrings.admin_user_list_email_title,
                              fontSize: 10,
                            ),
                            CustomComponents.displayText(
                              userEmail,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      PersistentData().selectedUser = selectedUserInformation;
                      Navigator.of(context).pushNamed("manage_user_list_info");
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "lib/assets/pictures/see_more.png",
                          width: 20,
                        ),
                        CustomComponents.displayText(
                          ProjectStrings.admin_user_list_see_more,
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // status
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: userStatus.toLowerCase() == "verified" ? Color(int.parse(ProjectColors.lightGreen.substring(2), radix: 16))
                        : Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16))
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            userStatus.toLowerCase() == "verified" ? "lib/assets/pictures/rentals_verified.png" : "lib/assets/pictures/rentals_denied.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            right: 25,
                            left: 5,
                          ),
                          child: CustomComponents.displayText(
                            CustomComponents.capitalizeFirstLetter(userStatus),
                            color: userStatus.toLowerCase() == "verified" ? Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16))
                                  : Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // User type
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: userType.toLowerCase() == "renter" ? Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
                        : userType.toLowerCase() == "driver" ? Color(int.parse(ProjectColors.userListDriverHexBackground.substring(2), radix: 16))
                        : userType.toLowerCase() == "outsource" ? Color(int.parse(ProjectColors.userListOutsourceHexBackground.substring(2), radix: 16))
                        : Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
                      child: CustomComponents.displayText(
                        userType,
                        color: userType.toLowerCase() == "renter" ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                        : userType.toLowerCase() == "driver" ? Color(int.parse(ProjectColors.userListDriverHex.substring(2), radix: 16))
                        : userType.toLowerCase() == "outsource" ? Color(int.parse(ProjectColors.userListOutsourceHex.substring(2), radix: 16))
                        : Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userListItems() {
    return Expanded(
      child: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        ),
      )
          : RefreshIndicator(
        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        onRefresh: () async {
          await _refreshPage();
        },
            child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: retrievedData.length,
                    itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _designPerItem(
                imagePath: "lib/assets/pictures/user_info_user.png",
                userName: "${retrievedData[index].firstName} ${retrievedData[index].lastName}",
                userContactNumber:retrievedData[index].number,
                userEmail: retrievedData[index].email,
                userStatus: retrievedData[index].status,
                userType: retrievedData[index].role,
                userProfilePicPath: "",
                selectedUserInformation: retrievedData[index]
              ),
            );
                    },
                  ),
          ),
    );
  }

  Widget _actionBar() {
    return Container(
      width: double.infinity,
      height: 65,
      color: Colors.white,
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
            ProjectStrings.admin_user_list_appbar_title,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context)
        ],
      ),
    );
  }
}