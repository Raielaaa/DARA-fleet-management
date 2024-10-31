import 'package:flutter/material.dart';

import '../../../../../controller/singleton/persistent_data.dart';
import '../../../../../model/car_list/complete_car_list.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/components.dart';
import '../../../../shared/strings.dart';

class EditUnit extends StatefulWidget {
  const EditUnit({super.key});

  @override
  State<EditUnit> createState() => _EditUnitState();
}

class _EditUnitState extends State<EditUnit> {
  Map<String, String> userInfo = {};
  Map<String, TextEditingController> controllers = {};
  CompleteCarInfo carUnitInfo = PersistentData().selectedCarUnitForManageUnit!;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      setState(() {
        userInfo = {
          "name": carUnitInfo.name,
          "price": "PHP ${carUnitInfo.price}",
          "color": carUnitInfo.color,
          "capacity": "${carUnitInfo.capacity} seats",
          "horsepower": carUnitInfo.horsePower,
          "engine": carUnitInfo.engine,
          "fuel": carUnitInfo.fuel,
          "fuel_variant": carUnitInfo.fuelVariant,
          "type": carUnitInfo.carType,
          "transmission": carUnitInfo.transmission,
          "short_description": carUnitInfo.shortDescription,
          "long_description": carUnitInfo.longDescription,
          "owner": carUnitInfo.carOwner,
        };

        userInfo.forEach((key, value) {
          controllers[key] = TextEditingController(text: value);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
      child: Padding(
        padding: const EdgeInsets.only(top: 38),
        child: Column(
          children: [
            appBar(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _headerSection(),
                  const SizedBox(height: 20),
                  _renterInfoContainer(context),
                  // _bottomSection(),
                  const SizedBox(height: 10),
                  confirmCancelButtons(),
                  const SizedBox(height: 80)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget confirmCancelButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(int.parse(ProjectColors.confirmActionCancelBackground.substring(2), radix: 16))
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 55, left: 55),
              child: CustomComponents.displayText(
                  ProjectStrings.income_page_confirm_delete_cancel,
                  color: Color(int.parse(ProjectColors.confirmActionCancelMain.substring(2), radix: 16)),
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),
          ),
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: () {
            // InfoDialog().showDecoratedTwoOptionsDialog(
            //     context: context,
            //     content: ProjectStrings.edit_user_info_dialog_content,
            //     header: ProjectStrings.edit_user_info_dialog_header,
            //     confirmAction: () async {
            //       await updateDB();
            //       Navigator.of(context).pop();
            //     }
            // );
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16))
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 55, left: 55),
              child: CustomComponents.displayText(
                  "Save",
                  color: Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renterInfoContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _renterInfoRow(),
              Divider(color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16))),
              _infoField("Name/Model", "name"),
              _infoField("Price", "price"),
              _infoField("Color", "color"),
              _infoField("Capacity", "capacity"),
              _infoField("Horsepower", "horsepower"),
              _infoField("Engine", "engine"),
              _infoField("Fuel", "fuel"),
              _infoField("Fuel Variant", "fuel_variant"),
              _infoField("Type", "type"),
              _infoField("Transmission", "transmission"),
              _infoField("Short Description", "short_description"),
              _infoField("Long Description", "long_description"),
              _infoField("Owner", "owner"),

              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoField(String title, String key) {
    // Retrieve the corresponding TextEditingController
    final controller = controllers[key] ?? TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomComponents.displayText(
            title,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            onChanged: (newValue) {
              // Update userInfo with the new value
              userInfo[key] = newValue;
            },
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                ),
              ),
              contentPadding: const EdgeInsets.only(bottom: 13),
              isDense: true,
            ),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                fontFamily: ProjectStrings.general_font_family
            ),
          ),
        ],
      ),
    );
  }

  Widget _renterInfoRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(int.parse(
                    ProjectColors.mainColorBackground.substring(2), radix: 16)),
                border: Border.all(
                    color: Color(int.parse(ProjectColors.lineGray)), width: 1),
              ),
              child: Center(
                child: CustomComponents.displayText(
                    "1",
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomComponents.displayText(
                    "Vehicle Information",
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 2),
                CustomComponents.displayText(
                    "Edit vehicle specification",
                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerSection() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomComponents.displayText(ProjectStrings.edit_user_info_header,
                fontWeight: FontWeight.bold, fontSize: 12),
            const SizedBox(height: 3),
            CustomComponents.displayText(ProjectStrings.edit_user_info_subheader,
                fontSize: 10),
          ],
        ),
      ),
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
            "Edit Unit",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
