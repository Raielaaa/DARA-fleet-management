import "package:cached_network_image/cached_network_image.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/model/report/report.dart";
import "package:dara_app/services/firebase/firestore.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:slide_switcher/slide_switcher.dart";

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../model/constants/firebase_constants.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/strings.dart";

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<ReportModel> listToBeDisplayed = [];
  List<ReportModel> resolvedReports = [];
  List<ReportModel> unresolvedReports = [];
  int currentSelectedIndex = 0;
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await retrieveReports();
    });

    _searchController.addListener(_filterReports);
  }

  Future<void> refreshPage() async {
    await retrieveReports();
  }

  void _filterReports() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      listToBeDisplayed = (currentSelectedIndex == 0 ? unresolvedReports : resolvedReports)
          .where((report) => report.senderName.toLowerCase().contains(query) ||
          report.location.toLowerCase().contains(query) ||
          report.problemSource.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> retrieveReports() async {
    listToBeDisplayed.clear();
    resolvedReports.clear();
    unresolvedReports.clear();

    LoadingDialog().show(context: context, content: "Please wait while we retrieve all user reports");
    List<ReportModel> retrievedReports = await Firestore().getReports();
    LoadingDialog().dismiss();

    for (var item in retrievedReports) {
      setState(() {
        if (item.reportStatus.toLowerCase() == "resolved") {
          resolvedReports.add(item);
        } else if (item.reportStatus.toLowerCase() == "unresolved") {
          unresolvedReports.add(item);
        }
      });
    }

    setState(() {
      listToBeDisplayed = unresolvedReports;
      _isLoading = false;
    });
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
                    appBar(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                            "Incident Reports",
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
                            "Monitor rental activity and report details",
                            fontSize: 10
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    switchOption(),
                    const SizedBox(height: 15),
                    _searchAndFilterBar(),
                    const SizedBox(height: 15),
                    Expanded(child: reportList()),
                    const SizedBox(height: 65)
                  ],
                )
            )
        )
    );
  }

  Future<void> _seeCompleteReportInfo(ReportModel currentItem) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Color(int.parse(
              ProjectColors.mainColorBackground.substring(2),
              radix: 16)),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //  top design
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          child: Image.asset(
                            "lib/assets/pictures/header_background_curves.png",
                            width: MediaQuery.of(context).size.width - 10,
                            height: 70, // Adjust height as needed
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomComponents.displayText(
                                  ProjectStrings.dialog_title_1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                              Image.asset(
                                "lib/assets/pictures/app_logo_circle.png",
                                width: 80.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    // const SizedBox(height: 10),
                    // Container(
                    //     color: Colors.white,
                    //     height: 250,
                    //     child: Column(
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.only(left: 15, top: 10),
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.only(top: 3),
                    //                 child: Container(
                    //                     width: 30,
                    //                     height: 30,
                    //                     decoration: BoxDecoration(
                    //                         shape: BoxShape.circle,
                    //                         color: Color(int.parse(
                    //                             ProjectColors.mainColorBackground
                    //                                 .substring(2),
                    //                             radix: 16)),
                    //                         border: Border.all(
                    //                             color: Color(int.parse(
                    //                                 ProjectColors.lineGray)),
                    //                             width: 1)),
                    //                     child: Center(
                    //                         child: CustomComponents.displayText(
                    //                             "1",
                    //                             fontSize: 12,
                    //                             fontWeight: FontWeight.bold))),
                    //               ),
                    //               const SizedBox(
                    //                   width:
                    //                   20.0), // Optional: Add spacing between the Text and the Column
                    //               Expanded(
                    //                 child: Column(
                    //                   crossAxisAlignment:
                    //                   CrossAxisAlignment.start,
                    //                   children: [
                    //                     CustomComponents.displayText(
                    //                       ProjectStrings.dialog_car_info_title,
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.bold,
                    //                     ),
                    //                     const SizedBox(height: 2),
                    //                     CustomComponents.displayText(
                    //                       ProjectStrings.dialog_car_info,
                    //                       color: Color(int.parse(
                    //                           ProjectColors.lightGray
                    //                               .substring(2),
                    //                           radix: 16)),
                    //                       fontSize: 10,
                    //                       fontWeight: FontWeight.w500,
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //
                    //         const SizedBox(height: 10),
                    //         Container(
                    //           height: 1,
                    //           width: double.infinity,
                    //           color: Color(int.parse(
                    //               ProjectColors.lineGray.substring(2),
                    //               radix: 16)),
                    //         ),
                    //         //  car model
                    //         Padding(
                    //           padding: const EdgeInsets.only(
                    //               right: 15, left: 15, top: 15),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               CustomComponents.displayText(
                    //                   ProjectStrings.dialog_car_model_title,
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 10,
                    //                   color: Color(int.parse(
                    //                       ProjectColors.lightGray.substring(2),
                    //                       radix: 16))),
                    //               CustomComponents.displayText(
                    //                 ProjectStrings.dialog_car_model,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 10,
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //
                    //         //  Transmission
                    //         Padding(
                    //           padding: const EdgeInsets.only(
                    //               right: 15, left: 15, top: 5),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               CustomComponents.displayText(
                    //                   ProjectStrings.dialog_transmission_title,
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 10,
                    //                   color: Color(int.parse(
                    //                       ProjectColors.lightGray.substring(2),
                    //                       radix: 16))),
                    //               CustomComponents.displayText(
                    //                 ProjectStrings.dialog_transmission,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 10,
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //
                    //         //  seat capacity
                    //         Padding(
                    //           padding: const EdgeInsets.only(
                    //               right: 15, left: 15, top: 5),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               CustomComponents.displayText(
                    //                   ProjectStrings.dialog_capacity_title,
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 10,
                    //                   color: Color(int.parse(
                    //                       ProjectColors.lightGray.substring(2),
                    //                       radix: 16))),
                    //               CustomComponents.displayText(
                    //                 ProjectStrings.dialog_capacity,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 10,
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //
                    //         //  fuel variant
                    //         Padding(
                    //           padding: const EdgeInsets.only(
                    //               right: 15, left: 15, top: 5),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               CustomComponents.displayText(
                    //                   ProjectStrings.dialog_fuel_title,
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 10,
                    //                   color: Color(int.parse(
                    //                       ProjectColors.lightGray.substring(2),
                    //                       radix: 16))),
                    //               CustomComponents.displayText(
                    //                 ProjectStrings.dialog_fuel,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 10,
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //
                    //         //  fuel capacity
                    //         Padding(
                    //           padding: const EdgeInsets.only(
                    //               right: 15, left: 15, top: 5),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               CustomComponents.displayText(
                    //                   ProjectStrings.dialog_fuel_capacity_title,
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 10,
                    //                   color: Color(int.parse(
                    //                       ProjectColors.lightGray.substring(2),
                    //                       radix: 16))),
                    //               CustomComponents.displayText(
                    //                 ProjectStrings.dialog_fuel_capacity,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 10,
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //
                    //         //  unit color
                    //         Padding(
                    //           padding: const EdgeInsets.only(
                    //               right: 15, left: 15, top: 5),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               CustomComponents.displayText(
                    //                   ProjectStrings.dialog_unit_color_title,
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 10,
                    //                   color: Color(int.parse(
                    //                       ProjectColors.lightGray.substring(2),
                    //                       radix: 16))),
                    //               CustomComponents.displayText(
                    //                 ProjectStrings.dialog__unit_color,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 10,
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //
                    //         //  engine
                    //         Padding(
                    //           padding: const EdgeInsets.only(
                    //               right: 15, left: 15, top: 5),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               CustomComponents.displayText(
                    //                   ProjectStrings.dialog_engine_title,
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 10,
                    //                   color: Color(int.parse(
                    //                       ProjectColors.lightGray.substring(2),
                    //                       radix: 16))),
                    //               CustomComponents.displayText(
                    //                 ProjectStrings.dialog_engine,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 10,
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //
                    //         const SizedBox(height: 10)
                    //       ],
                    //     )),

                    //  report information
                    const SizedBox(height: 10),
                    Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(int.parse(
                                                ProjectColors.mainColorBackground
                                                    .substring(2),
                                                radix: 16)),
                                            border: Border.all(
                                                color: Color(int.parse(
                                                    ProjectColors.lineGray)),
                                                width: 1)),
                                        child: Center(
                                            child: CustomComponents.displayText(
                                                "1",
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))),
                                  ),
                                  const SizedBox(
                                      width:
                                      20.0), // Optional: Add spacing between the Text and the Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        CustomComponents.displayText(
                                          ProjectStrings.mr_dialog_title_3,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 2),
                                        CustomComponents.displayText(
                                          "See complete report details",
                                          color: Color(int.parse(
                                              ProjectColors.lightGray
                                                  .substring(2),
                                              radix: 16)),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: Color(int.parse(
                                  ProjectColors.lineGray.substring(2),
                                  radix: 16)),
                            ),
                            //  photo
                            GestureDetector(
                              onTap: () async {
                                String? imageURL = await getDownloadUrlFromPartialFolderName(currentItem.problemUID);
                                debugPrint("image-url: $imageURL");

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: CachedNetworkImage(
                                        imageUrl: imageURL ?? "",
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 15, left: 15, top: 15, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: CustomComponents.displayText(
                                          ProjectStrings.mr_dialog_photo_title,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          color: Color(int.parse(
                                              ProjectColors.lightGray.substring(2),
                                              radix: 16))),
                                    ),
                                    Container(
                                      child: Row(
                                          children: [
                                            CustomComponents.displayText(
                                                ProjectStrings.mr_dialog_photo,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                                            ),
                                            const SizedBox(width: 7),
                                            Image.asset(
                                              "lib/assets/pictures/right_arrow.png",
                                              width: 10,
                                            )
                                          ]
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            _buildRow("Name: ", currentItem.senderName),
                            _buildRow("Email: ", currentItem.senderEmail),
                            _buildRow("Number: ", currentItem.senderPhoneNumber),
                            _buildRow("Profile status: ", currentItem.senderStatus),
                            _buildRow("Date submitted: ", currentItem.dateSubmitted),
                            _buildRow("Location: ", currentItem.problemSource),
                            _buildRow("Reported location: ", currentItem.location),
                            _buildRow("Selected category", currentItem.selectedProblems),
                            _buildRow("Comments", currentItem.comments),
                            const SizedBox(height: 10)
                          ],
                        )),

                    const SizedBox(height: 15),
                    GestureDetector(
                        onTap: () {
                          InfoDialog().showDecoratedTwoOptionsDialog(
                              context: context,
                              content: "Are you sure you want to proceed with this action? This cannot be undone!",
                              header: "Confirm Action",
                              confirmAction: () async {
                                await resolveFunction(currentItem);
                                Navigator.of(context).pop();
                              }
                          );
                        },
                        child: UnconstrainedBox(
                          child: Row(
                            children: [
                              //  mark as resolved
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: currentSelectedIndex == 0 ? Color(int.parse(ProjectColors.greenButtonBackground.substring(2), radix: 16))
                                        : Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16)),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Image.asset(
                                          currentSelectedIndex == 0 ? "lib/assets/pictures/rentals_verified.png" : "lib/assets/pictures/rentals_denied.png",
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10, right: 25, left: 5),
                                        child: CustomComponents.displayText(
                                          currentSelectedIndex == 0 ? ProjectStrings.mr_dialog_mark_as_resolve : "Mark as Unresolved",
                                          color: currentSelectedIndex == 0 ? Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16))
                                              : Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        )
                    ),

                    const SizedBox(height: 15)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget reportList() {
    return _isLoading ? Center(
      child: CircularProgressIndicator(
        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
      ),
    ) : Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: RefreshIndicator(
        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        onRefresh: () async {
          await refreshPage();
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: listToBeDisplayed.length,
          itemBuilder: (BuildContext context, int index) {
            ReportModel currentItem = listToBeDisplayed[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _seeCompleteReportInfo(currentItem);
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                color: Color(int.parse(ProjectColors
                                    .reportItemBackground
                                    .substring(2),
                                    radix: 16)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: CustomComponents.displayText(
                                  "${currentItem.senderName.split(" ")[0][0]}${currentItem.senderName.split(" ")[1][0]}",
                                  color: Color(int.parse(ProjectColors
                                      .reportPurple.substring(2),
                                      radix: 16)),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                CustomComponents.displayText(
                                  currentItem.location,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                const SizedBox(height: 5),
                                CustomComponents.displayText(
                                  currentItem.problemSource,
                                  fontSize: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        "lib/assets/pictures/trash.png",
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }



  Future<void> resolveFunction(ReportModel currentItem) async {
    DocumentReference userDoc = FirebaseFirestore.instance.collection(FirebaseConstants.userReportCollection).doc(currentItem.problemUID);

    try {
      await userDoc.update({
        "problem_status" : currentSelectedIndex == 0 ? "resolved" : "unresolved"
      });
      debugPrint("User phone number updated successfully");
    } catch(e) {
      debugPrint("Error updating user phone number: $e");
    }
  }

  Future<String?> getDownloadUrlFromPartialFolderName(String partialFolderName) async {
    try {
      // Define the path to the root folder containing the report images
      final Reference rootRef = FirebaseStorage.instance.ref('report_images');

      // List all folders in the root folder
      final ListResult result = await rootRef.listAll();

      // Find the folder that contains the partial name
      Reference? matchingFolder;
      for (final folder in result.prefixes) {
        if (folder.name.contains(partialFolderName)) {
          matchingFolder = folder;
          break;
        }
      }

      if (matchingFolder != null) {
        // List all files in the matching folder (should only be one file)
        final ListResult folderContents = await matchingFolder.listAll();

        if (folderContents.items.isNotEmpty) {
          // Get the file reference and retrieve its download URL
          final Reference fileRef = folderContents.items.first;
          return await fileRef.getDownloadURL();
        } else {
          debugPrint('No files found in folder: ${matchingFolder.fullPath}');
          return null;
        }
      } else {
        debugPrint('No folder found with the partial name: $partialFolderName');
        return null;
      }
    } catch (e) {
      debugPrint('Error getting download URL: $e');
      return null;
    }
  }

  Widget _buildRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomComponents.displayText(
              title,
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
            ),
          ),
          Expanded(
            child: value is Widget
                ? value
                : CustomComponents.displayText(
              value.toString(),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.white,
            width: 0.0,
          ),
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
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: "Search reports...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 10,
                      fontFamily: ProjectStrings.general_font_family,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 10,
                    fontFamily: ProjectStrings.general_font_family,
                  ),
                ),
              ),
              const SizedBox(width: 20, height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget switchOption() {
    return SlideSwitcher(
      indents: 3,
      containerColor: Colors.white,
      containerBorderRadius: 7,
      slidersColors: [Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))],
      containerHeight: 50,
      containerWight: MediaQuery.of(context).size.width - 50,
      onSelect: (index) {
        setState(() {
          currentSelectedIndex = index;
          listToBeDisplayed = index == 0 ? unresolvedReports : resolvedReports;
          _filterReports();
        });
      },
      children: [
        CustomComponents.displayText("Unresolved", color: Color(int.parse(ProjectColors.mainColorHex)), fontSize: 12, fontWeight: FontWeight.w600),
        CustomComponents.displayText("Resolved", color: Color(int.parse(ProjectColors.mainColorHex)), fontSize: 12, fontWeight: FontWeight.w600),
      ],
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
            "Reports Page",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
