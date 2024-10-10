import "package:dara_app/controller/account/login_controller.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/services/firebase/auth.dart";
import "package:dara_app/services/google/google.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  State<LoginMain> createState() => _LoginMain();
}

class _LoginMain extends State<LoginMain> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordResetController = TextEditingController();

  //  Google sign-in
  final GoogleLogin _googleLogin = GoogleLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late GoogleSignInAccount _userObj;

  String clickedUserType = "Renter";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showUserOptionsDialog();
    });
  }

  Widget inputEmailBottomDialog() {
    return DraggableScrollableSheet(
        builder: (_, controller) => Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)
                )
            ),
            child: ListView(
                controller: controller,
                children: [
                  CustomComponents.displayText(
                      "Please enter the email address you used to register with us:",
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                  const SizedBox(height: 20),
                  CustomComponents.displayTextField(
                      "Enter your email here",
                    controller: _passwordResetController
                  ),
                  //  Login button
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: CustomComponents.displayElevatedButton(
                      "Proceed",
                      fontSize: 12,
                      onPressed: () async {
                        InfoDialog _infoDialog = InfoDialog();
                        LoadingDialog _loadingDialog = LoadingDialog();

                        try {
                          _loadingDialog.show(context: context, content: "Please wait while we are sending you the email.");
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: _passwordResetController.text.trim());
                          _loadingDialog.dismiss();
                          _infoDialog.show(context: context, content: "Password reset email sent successfully.", header: "Success");
                        } on FirebaseAuthException catch (err) {
                          debugPrint("Password reset error: ${err.message}");
                          _infoDialog.show(context: context, content: "Error: ${err.message}", header: "Warning");
                        } catch (err) {
                          debugPrint("Password reset error: ${err.toString()}");
                          _infoDialog.show(context: context, content: "Fatal error: ${err.toString()}", header: "Warning");
                        }

                      },
                    ),
                  ),
                ]
            )
        )
    );
  }

  Future<void> _showUserOptionsDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            backgroundColor: Color(int.parse(
              ProjectColors.mainColorBackground.substring(2),
              radix: 16,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top design
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
                            ProjectStrings.account_login_main_dialog_title,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          Image.asset(
                            "lib/assets/pictures/app_logo_circle.png",
                            width: 80.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                //  main body
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //  admin/manager
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          clickedUserType = "Admin/Manager";
                          PersistentData().userType = "Admin";
                        });
                      },
                      child: _userType(
                          ProjectStrings.account_login_main_admin_manager,
                          "lib/assets/pictures/admin_manager.jpg"),
                    ),
                    const SizedBox(width: 10),
                    //  accountant
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          clickedUserType = "Accountant";
                          PersistentData().userType = "Accountant";
                        });
                      },
                      child: _userType(
                          ProjectStrings.account_login_main_accountant,
                          "lib/assets/pictures/accountant.jpg"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //  driver
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          clickedUserType = "Driver";
                          PersistentData().userType = "Driver";
                        });
                      },
                      child: _userType(
                          ProjectStrings.account_login_main_driver,
                          "lib/assets/pictures/user_type_driver.jpeg"),
                    ),
                    const SizedBox(width: 10),
                    //  outsource
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          clickedUserType = "Outsource";
                          PersistentData().userType = "Outsource";
                        });
                      },
                      child: _userType(
                          ProjectStrings.account_login_main_outsource,
                          "lib/assets/pictures/user_type_outsource.jpg"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                //  user
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      clickedUserType = "Renter";
                      PersistentData().userType = "Renter";
                    });
                  },
                  child: _userType(
                      "Renter",
                      "lib/assets/pictures/user_type_user.jpg"),
                ),
                const SizedBox(height: 30)
              ],
            ),
          );
        });
  }

    Widget _userType(String header, String imagePath) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            child: Image.asset(
              imagePath,
              height: 60,
              width: double.infinity, // Expand image to full width
              fit: BoxFit.cover, // Cover the entire width of the container
            ),
          ),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                header,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    InfoDialog().dismissBoolean();

    return Material(
      child: Container(
          padding:
              const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 62),
          color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
              radix: 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                //  Back button
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "account_opening_page");
                  },
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 25.0, // desired size
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(), // override default min size of 48px
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),

              //  Text header
              const SizedBox(height: 30),
              CustomComponents.displayText(
                ProjectStrings.account_login_main_header,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(
                    int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
              ),

              //  Text subheader
              const SizedBox(height: 5),
              CustomComponents.displayText(
                  ProjectStrings.account_login_main_subheader,
                  fontSize: 12,
                  ),

              //  Email
              const SizedBox(height: 40),
              CustomComponents.displayText(
                  ProjectStrings.account_register_ep_email,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(int.parse(ProjectColors.blackHeader.substring(2),
                      radix: 16))),
              const SizedBox(height: 10),
              CustomComponents.displayTextField(
                  ProjectStrings.account_register_ep_email_hint,
                  controller: _emailController,
                  labelColor: Color(int.parse(
                      ProjectColors.lightGray.substring(2),
                      radix: 16))),

              //  Password
              CustomComponents.displayText(
                  ProjectStrings.account_register_ep_password,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(int.parse(ProjectColors.blackHeader.substring(2),
                      radix: 16))),
              const SizedBox(height: 10),
              CustomComponents.displayTextField(
                  ProjectStrings.account_login_main_password_hint,
                  isTextHidden: !_isPasswordVisible,
                  isIconPresent: true,
                  controller: _passwordController,
                  labelColor: Color(int.parse(
                      ProjectColors.lightGray.substring(2),
                      radix: 16)), iconPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),

              //  Text - Change user type
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return inputEmailBottomDialog();
                          }
                      );
                    },
                    child: CustomComponents.displayText(
                        "Forgot password?",
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: Color(int.parse(
                            ProjectColors.mainColorHex.substring(2),
                            radix: 16)
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showUserOptionsDialog();
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustomComponents.displayText(
                          "Not a $clickedUserType? Click here",
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          color: Color(int.parse(
                              ProjectColors.mainColorHex.substring(2),
                              radix: 16))),
                    ),
                  ),
                ],
              ),

              //  Login button
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: CustomComponents.displayElevatedButton(
                  ProjectStrings.account_login_main_login_button,
                  fontSize: 12,
                  onPressed: () {
                    LoginController loginController = LoginController();
                    loginController.validateInputs(
                        context: context,
                        email: _emailController.text,
                        password: _passwordController.text);
                  },
                ),
              ),

              //  Row - "Or" TextView
              const SizedBox(height: 20),
              Row(
                children: [
                  //  First line
                  Expanded(
                      child: Container(
                    height: 1,
                    color: Colors.grey,
                  )),

                  //  Text - "Or"
                  const SizedBox(width: 10),
                  CustomComponents.displayText(
                      ProjectStrings.account_login_main_or,
                      fontSize: 10,
                      color: Color(int.parse(
                          ProjectColors.darkGray.substring(2),
                          radix: 16)),
                      fontWeight: FontWeight.bold),
                  const SizedBox(width: 10),

                  //  Second line
                  Expanded(
                      child: Container(
                    height: 1,
                    color: Colors.grey,
                  ))
                ],
              ),

              //  Google sign-in button
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (PersistentData().userType != "Admin" && PersistentData().userType != "Accountant") {
                    // Call signInWithGoogle function when the button is pressed
                    final User? user = await _googleLogin.signInWithGoogle(context);
                    if (user != null) {
                      //  insert items to db
                      List<String>? subdividedName = user.displayName?.split(" ");
                      LoginController _loginController = LoginController();
                      _loginController.insertGoogleCredentialsToDB(
                          userUID: user.uid,
                          firstName: subdividedName!.first,
                          lastName: subdividedName.last,
                          birthday: PersistentData().birthdayFromGoogleSignIn,
                          email: user.email!,
                          role: PersistentData().userType,
                          context: context
                      );
                    }
                  } else {
                    InfoDialog().show(
                        context: context,
                        content: "Google sign-in can be made only with either as driver, outsource, or renter. Accountant and Admin is not allowed",
                        header: "Warning"
                    );
                  }
                },
                style: ButtonStyle(
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.all(3)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
                child:
                    Stack(alignment: Alignment.centerLeft, children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "lib/assets/pictures/google.png",
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomComponents.displayText(
                      ProjectStrings.account_login_main_login_google,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  )
                ]),
              ),

              //  Text - No account
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed("register_main");
                },
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: ProjectStrings.account_login_main_no_account_1,
                        style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xff404040),
                            fontFamily: ProjectStrings.general_font_family),
                        children: [
                          TextSpan(
                              text:
                                  ProjectStrings.account_login_main_no_account_2,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff3FA2BE),
                                  fontFamily: ProjectStrings.general_font_family,
                                  fontWeight: FontWeight.w600))
                        ]
                    )
                ),
              )
            ],
          )),
    );
  }
}
