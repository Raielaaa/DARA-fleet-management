import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class TopOptionReport extends StatefulWidget {
  const TopOptionReport({super.key});

  @override
  State<TopOptionReport> createState() => _TopOptionReportState();
}

class _TopOptionReportState extends State<TopOptionReport> {
  bool engineProblemsIsChecked = false;
  bool transmissionIsChecked = false;
  bool brakeIsChecked = false;
  bool otherIsChecked = false;

  //  Set an int with value -1 since no item has been selected
  int selectedCard = 0;

  //  Car name/brands
  List<String> carBrands = [
    ProjectStrings.to_others,
    ProjectStrings.to_driver,
    ProjectStrings.to_toyota_wigo,
    ProjectStrings.to_mitsubishi_mirage,
    ProjectStrings.to_toyota_avanza,
    ProjectStrings.to_hyundai_accent,
    ProjectStrings.to_suzuki_ertiga,
    ProjectStrings.to_hyundai_stargaizer,
    ProjectStrings.to_cvt_mirage,
    ProjectStrings.to_kia_picanto,
    ProjectStrings.to_toyota_inova,
    ProjectStrings.to_suzuki_apv
  ];

  Future<void> _showInconvenienceDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      "lib/assets/pictures/exit.png",
                      width: 20,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
                child: Image.asset(
                  "lib/assets/pictures/incon.png",
                  width: double.infinity,
                ),
              ),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: CustomComponents.displayText(
                  ProjectStrings.report_dialog_title,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: CustomComponents.displayText(
                  ProjectStrings.report_dialog_subheader,
                  fontSize: 10,
                  textAlign: TextAlign.center
                ),
              ),
              const SizedBox(height: 100)
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
            radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              //  ActionBar
              Container(
                width: double.infinity,
                height: 65,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("lib/assets/pictures/left_arrow.png"),
                    ),
                    CustomComponents.displayText(
                      ProjectStrings.to_appbar_title,
                      fontWeight: FontWeight.bold,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                          "lib/assets/pictures/three_vertical_dots.png"),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    //  main content
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15, top: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
                          child: Column(
                            children: [
                              GridView.builder(
                                padding: const EdgeInsets.only(top: 20),
                                shrinkWrap: true,
                                itemCount: 12,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2,
                                  childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 8)
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCard = index;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                        color: selectedCard == index ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) :
                                        Color(int.parse(ProjectColors.reportMainColorBackground.substring(2), radix: 16))
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: CustomComponents.displayText(
                                            carBrands[index].toString(),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: selectedCard == index ? Colors.white : const Color(0xff404040)
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                
                              //  location
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: CustomComponents.displayText(
                                      ProjectStrings.report_location_title,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: CustomComponents.displayTextField(
                                  ProjectStrings.report_location,
                                ),
                              ),
                
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Color(
                                              int.parse(ProjectColors.blackBody)),
                                          width: 1.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 5),
                                        CustomComponents.displayText(
                                            ProjectStrings.report_add_photo,
                                            fontSize: 10)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomComponents.displayText(
                                      ProjectStrings.report_maximum_photo_size,
                                      fontSize: 10,
                                      fontStyle: FontStyle.italic,
                                      color: Color(int.parse(
                                          ProjectColors.carouselNotSelected))),
                                ),
                              ),
                
                              //  problem checkboxes
                              const SizedBox(height: 30),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                  ProjectStrings.report_check_all_that_applies,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                    ProjectStrings.report_check_all_subheader,
                                    fontSize: 10),
                              ),
                
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 30,
                                    child: Checkbox(
                                      activeColor: Color(int.parse(
                                          ProjectColors.mainColorHex.substring(2),
                                          radix: 16)),
                                      value: engineProblemsIsChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          engineProblemsIsChecked = value!;
                                        });
                                      },
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  CustomComponents.displayText(
                                      ProjectStrings.report_engine_problems,
                                      fontSize: 10)
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 30,
                                    child: Checkbox(
                                      activeColor: Color(int.parse(
                                          ProjectColors.mainColorHex.substring(2),
                                          radix: 16)),
                                      value: transmissionIsChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          transmissionIsChecked = value!;
                                        });
                                      },
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  CustomComponents.displayText(
                                      ProjectStrings.report_transmission_issues,
                                      fontSize: 10)
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 30,
                                    child: Checkbox(
                                      activeColor: Color(int.parse(
                                          ProjectColors.mainColorHex.substring(2),
                                          radix: 16)),
                                      value: brakeIsChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          brakeIsChecked = value!;
                                        });
                                      },
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  CustomComponents.displayText(
                                      ProjectStrings.report_brake_malfunction,
                                      fontSize: 10)
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 30,
                                    child: Checkbox(
                                      activeColor: Color(int.parse(
                                          ProjectColors.mainColorHex.substring(2),
                                          radix: 16)),
                                      value: otherIsChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          otherIsChecked = value!;
                                        });
                                      },
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  CustomComponents.displayText(
                                      ProjectStrings.report_other,
                                      fontSize: 10)
                                ],
                              ),
                
                              //  comments
                              //  problem checkboxes
                              const SizedBox(height: 30),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                  ProjectStrings.report_comments,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                    ProjectStrings.report_comments_subheader,
                                    fontSize: 10),
                              ),
                
                              const SizedBox(height: 10),
                              TextField(
                                cursorColor: Color(int.parse(
                                    ProjectColors.mainColorHex.substring(2),
                                    radix: 16)),
                                maxLines:
                                    null, // Allows the text box to be multiline and expands as needed
                                keyboardType: TextInputType
                                    .multiline, // Sets the keyboard type to multiline
                                style: const TextStyle(
                                    fontSize: 10, color: Color(0xff404040)),
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(
                                      fontSize: 10, color: Color(0xffaeaeae)),
                                  hintText: ProjectStrings
                                      .report_enter_your_comment, // Placeholder text
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(
                                          5))), // Adds a border around the text box
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide: BorderSide(
                                      color: Color(int.parse(
                                          ProjectColors.mainColorHex.substring(2),
                                          radix:
                                              16)), // Your desired color when focused
                                      width:
                                          2.0, // Thickness of the border when focused
                                    ),
                                  ),
                                ),
                              ),
                
                              const SizedBox(height: 50),
                              GestureDetector(
                                onTap: () {
                                  _showInconvenienceDialog();
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: CustomComponents.displayElevatedButton(
                                    ProjectStrings.report_submit_report,
                                    fontSize: 12
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 55)
            ],
          ),
        ),
      ),
    );
  }
}