import 'package:dara_app/view/pages/account/account_opening.dart';
import 'package:dara_app/view/pages/account/login/login.dart';
import 'package:dara_app/view/pages/account/register/register.dart';
import 'package:dara_app/view/pages/account/register/register_email_pass.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_1.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_2.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_3.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_4.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_5.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_6.dart';
import 'package:dara_app/view/pages/entry/entry_page_video.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        home: const EntryPage(),
        routes: {
          //  Info carousel
          "entry_page_1": (context) => const CarouselPage1(),
          "entry_page_2": (context) => const CarouselPage2(),
          "entry_page_3": (context) => const CarouselPage3(),
          "entry_page_4": (context) => const CarouselPage4(),
          "entry_page_5": (context) => const CarouselPage5(),
          "entry_page_6": (context) => const CarouselPage6(),
      
          //  Login register opening page
          "account_opening_page": (context) => const AccountOpening(),
      
          //  Register
          "register_main": (context) => const Register(),
          "register_name_birthday": (context) => const Register(),
          "register_email_pass": (context) => const RegisterEmailPass(),
      
          //  Login main
          "login_main": (context) => const LoginMain()
        },
      ),
    );
  }
}