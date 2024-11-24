import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/info_dialog.dart";
import "../../../../shared/strings.dart";

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();

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
              sectionHeader(
                "Update Your Credentials",
                "Keep your account secure by updating your email and password regularly",
              ),
              emailAndPasswordField(),
              submitButton(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  Widget submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                InfoDialog().showDecoratedTwoOptionsDialog(
                  context: context,
                  header: "Confirm Action",
                  content: "A password reset link will be sent shortly after proceeding. Please follow the instructions provided in the email to update your account password.",
                  confirmAction: () async {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser!.email.toString());
                    } catch(err) {
                      CustomComponents.showToastMessage("Password reset error: ${err.toString()}", Colors.red, Colors.white);
                    }
                  }
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: CustomComponents.displayText(
                  "Reset Password",
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(alignment: Alignment.centerLeft, child: CustomComponents.displayText(title, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 3),
          CustomComponents.displayText(subtitle, fontSize: 10),
        ],
      ),
    );
  }

  Widget emailAndPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  new email
          const SizedBox(height: 25),
          CustomComponents.displayText(
              ProjectStrings.account_register_ep_email,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2),
                  radix: 16))),
          const SizedBox(height: 10),
          CustomComponents.displayTextField(
              "Your new email",
              controller: _emailController,
              maxLength: 30,
              labelColor: Color(int.parse(
                  ProjectColors.lightGray.substring(2),
                  radix: 16))),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset(
                    "lib/assets/pictures/home_top_report.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomComponents.displayText(
                    "Please ensure that the email address you have entered is valid.",
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          //  reset email button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_emailController.text.isNotEmpty) {
                        if (isValidEmail(_emailController.text)) {
                          InfoDialog().showDecoratedTwoOptionsDialog(
                            context: context,
                            content: "An email reset link will be sent shortly after proceeding. Please follow the instructions provided in the email to update your registered email address.",
                            header: "Confirm Action",
                            confirmAction: () async {
                              await reauthenticateAndChangeCredentials();
                              await updateEmailOnRoleDB();
                            },
                          );
                        } else {
                          InfoDialog().show(
                            context: context,
                            content: "Please enter a valid email address.",
                            header: "Invalid Email",
                          );
                        }
                      } else {
                        InfoDialog().show(
                          context: context,
                          content: "Please fill the required field.",
                          header: "Warning",
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(17),
                      child: CustomComponents.displayText(
                        "Reset Email",
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.warning,
                    color: Color(0xffffa726)
                  )
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomComponents.displayText(
                    "To change your account password, click the button below. Please note that an email containing detailed instructions will be sent to your currently registered email address.",
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateEmailOnRoleDB() async {
    await FirebaseFirestore.instance.collection(FirebaseConstants.registerRoleCollection).doc(FirebaseAuth.instance.currentUser?.uid).update({"user_email" : _emailController.value.text});
    await FirebaseFirestore.instance.collection(FirebaseConstants.registerCollection).doc(FirebaseAuth.instance.currentUser?.uid).update({"user_email" : _emailController.value.text});
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
            onTap: () => PersistentData().openDrawer(0),
            child: Padding(padding: const EdgeInsets.all(20.0), child: Image.asset("lib/assets/pictures/menu.png")),
          ),
          CustomComponents.displayText("Update Account", fontWeight: FontWeight.bold),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }

  Future<void> reauthenticateAndChangeCredentials() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update email
        await user.verifyBeforeUpdateEmail(_emailController.text);
      }
    } catch (e) {
      CustomComponents.showToastMessage("Error: $e", Colors.red, Colors.white);
      debugPrint("Error: $e");
    }
  }
}