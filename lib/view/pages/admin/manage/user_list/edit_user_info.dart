import "package:dara_app/controller/home/home_controller.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class EditUserInfo extends StatefulWidget {
  const EditUserInfo({super.key});

  @override
  State<EditUserInfo> createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
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
              _actionBar(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _headerSection(),
                    const SizedBox(height: 20),
                    _renterInfoContainer(context),
                    _bottomSection(),
                    const SizedBox(height: 10),
                    confirmCancelButtons(),
                    const SizedBox(height: 80)
                  ],
                ),
              )
            ],
          ),
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
            InfoDialog().showDecoratedTwoOptionsDialog(
                context: context,
                content: ProjectStrings.edit_user_info_dialog_content,
                header: ProjectStrings.edit_user_info_dialog_header
            );
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16))
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 55, left: 55),
              child: CustomComponents.displayText(
                  ProjectStrings.edit_user_info_apply_changes,
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

  Widget _bottomSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          children: [
            _renterInfoRowForBottomPanel(),
            Divider(color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16))),
            _attachedDocumentsSection(),
            const SizedBox(height: 20),
          ],
        ),
      )
    );
  }

  void showConfirmDialog() {
    InfoDialog().showDecoratedTwoOptionsDialog(
        context: context,
        content: ProjectStrings.income_page_confirm_delete_content,
        header: ProjectStrings.income_page_confirm_delete
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/left_arrow.png"),
          ),
          CustomComponents.displayText(
            ProjectStrings.edit_user_info_appbar_title,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
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
              _infoField(ProjectStrings.ri_name_title, ProjectStrings.ri_name),
              _infoField(ProjectStrings.ri_email_title, ProjectStrings.ri_email),
              _infoField(ProjectStrings.ri_phone_number_title, ProjectStrings.ri_phone_number),
              _infoField(ProjectStrings.admin_user_info_address_title, ProjectStrings.admin_user_info_address),
              _infoField(ProjectStrings.admin_user_info_age_title, ProjectStrings.admin_user_info_age),
              _infoField(ProjectStrings.admin_user_info_gender_title, ProjectStrings.admin_user_info_gender),
              _infoField(ProjectStrings.admin_user_info_account_status_title, ProjectStrings.admin_user_info_account_status),
              _infoField(ProjectStrings.admin_user_info_date_registered_title, ProjectStrings.admin_user_info_date_registered),

              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _renterInfoRowForBottomPanel() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100)
            ),
            width: 40,
            height: 40,
            child: Icon(
              Icons.folder_copy,
              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
              size: 25,
            )
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomComponents.displayText(
                    ProjectStrings.edit_user_info_attached_documents,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 2),
                CustomComponents.displayText(
                    ProjectStrings.edit_user_info_attached_documents_subheader,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ],
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
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100)
            ),
            width: 40,
            height: 40,
            child: Image.asset(
              "lib/assets/pictures/user_info_user.png",
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomComponents.displayText(
                    ProjectStrings.admin_user_info_name,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 2),
                CustomComponents.displayText(
                    ProjectStrings.admin_user_info_user_type,
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

  Widget _infoField(String title, String value) {
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
            initialValue: value,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                ),
              ),
              contentPadding: const EdgeInsets.only(bottom: 13),
              isDense: true, // Reduces the space inside the field
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10, // Set font size to 10
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachedDocumentsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _documentRow(ProjectStrings.ri_government_id_1),
          _documentRow(ProjectStrings.ri_government_id_2),
          _documentRow(ProjectStrings.ri_driver_license),
          _documentRow(ProjectStrings.ri_proof_of_billing),
          _documentRow(ProjectStrings.ri_ltms_portal),
        ],
      ),
    );
  }

  Widget _documentRow(String document) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Color(int.parse(
                          ProjectColors.mainColorHex.substring(2),
                          radix: 16))),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomComponents.displayText(ProjectStrings.ri_jpg,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomComponents.displayText(document,
                        fontSize: 10, fontWeight: FontWeight.w500),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        CustomComponents.displayText(ProjectStrings.ri_size,
                            fontSize: 10,
                            color: Color(int.parse(
                                ProjectColors.lightGray.substring(2),
                                radix: 16))),
                        const SizedBox(width: 20),
                        CustomComponents.displayText(
                            ProjectStrings.ri_document_date,
                            fontSize: 10,
                            color: Color(int.parse(
                                ProjectColors.lightGray.substring(2),
                                radix: 16)))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          //  view text
          Row(
            children: [
              CustomComponents.displayText(ProjectStrings.ri_view,
                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2),
                      radix: 16)),
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
              const SizedBox(width: 30),
              CustomComponents.displayText(ProjectStrings.edit_user_info_delete,
                  color: Color(int.parse(ProjectColors.redButtonMain.substring(2),
                      radix: 16)),
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ],
          )
        ],
      ),
    );
  }

  HomeController homeController = HomeController();
  Widget _bottomPanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _bottomPanelItem(
              "lib/assets/pictures/user_info_edit.png",
              ProjectColors.userInfoLightBlue,
              ProjectStrings.admin_user_info_edit,
                  () {}
          ),
          const SizedBox(width: 18),
          _bottomPanelItem(
              "lib/assets/pictures/delete.png",
              ProjectColors.userInfoRed,
              ProjectStrings.admin_user_info_delete,
                  () {
                showConfirmDialog();
              }
          ),
          const SizedBox(width: 18),
          _bottomPanelItem(
              "lib/assets/pictures/user_info_email.png",
              ProjectColors.userInfoGreen,
              ProjectStrings.user_info_contact,
                  () {
                homeController.showContactBottomDialog(context);
              }
          ),
        ],
      ),
    );
  }

  Widget _bottomPanelItem(String iconPath, String color, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(int.parse(color.substring(2), radix: 16)),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset(iconPath, width: 25, height: 25),
            ),
          ),
          const SizedBox(height: 5),
          CustomComponents.displayText(label, fontSize: 10),
        ],
      ),
    );
  }
}
