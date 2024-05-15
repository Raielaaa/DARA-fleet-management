import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  Calls showDialog method right after screen display
      showSuccessfulRegisterSnackbar();
    });
  }
  //  Shows dialog if the previous registration process is successful
  void showSuccessfulRegisterSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Login Successful",
          style: TextStyle(
            fontFamily: ProjectStrings.general_font_family,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12
          ),
        ),
        backgroundColor: Colors.green,
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
      ),
    );
  }
}