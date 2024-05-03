import "package:dara_app/view/shared/colors.dart";
import "package:flutter/material.dart";

class AccountOpening extends StatelessWidget {
  const AccountOpening({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
      child: Column(
        children: [
          Image.asset("lib/assets/pictures/app_logo_name.png"),
          Image.asset("lib/assets/pictures/account_intro.png"),
          Text("Let's start")
        ],
      ),
    );
  }
}