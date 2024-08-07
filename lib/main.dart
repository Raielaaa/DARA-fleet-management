import 'package:dara_app/controller/providers/register_provider.dart';
import 'package:dara_app/view/pages/account/account_opening.dart';
import 'package:dara_app/view/pages/account/login/login.dart';
import 'package:dara_app/view/pages/account/register/register.dart';
import 'package:dara_app/view/pages/account/register/register_email_pass.dart';
import 'package:dara_app/view/pages/account/register/register_phone_number.dart';
import 'package:dara_app/view/pages/account/register/register_successful.dart';
import 'package:dara_app/view/pages/account/register/register_verify_phone.dart';
import 'package:dara_app/view/pages/admin/rentals/report.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_1.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_2.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_3.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_4.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_5.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_6.dart';
import 'package:dara_app/view/pages/entry/entry_page_video.dart';
import 'package:dara_app/view/pages/admin/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => RegisterProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: true,
          home: const EntryPage(),
          routes: {
            // Info carousel
            "entry_page_1": (context) => const CarouselPage1(),
            "entry_page_2": (context) => const CarouselPage2(),
            "entry_page_3": (context) => const CarouselPage3(),
            "entry_page_4": (context) => const CarouselPage4(),
            "entry_page_5": (context) => const CarouselPage5(),
            "entry_page_6": (context) => const CarouselPage6(),

            // Login register opening page
            "account_opening_page": (context) => const AccountOpening(),

            // Register
            "register_main": (context) => const Register(),
            "register_name_birthday": (context) => const Register(),
            "register_email_pass": (context) => const RegisterEmailPass(),
            "register_phone_number": (context) => const RegisterPhoneNumber(),
            "register_verify_number": (context) => const RegisterVerifyNumber(),
            "register_successful": (context) => const RegisterSuccessful(),

            // Login main
            "login_main": (context) => const LoginMain(),

            // Home page
            "home_main": (context) => const HomePage(),

            //  Rentals - report page
            "rentals_report": (context) => const Report()
          },
        ),
      ),
    );
  }
}
