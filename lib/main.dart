import 'package:dara_app/controller/providers/register_provider.dart';
import 'package:dara_app/view/pages/account/account_opening.dart';
import 'package:dara_app/view/pages/account/login/login.dart';
import 'package:dara_app/view/pages/account/register/register.dart';
import 'package:dara_app/view/pages/account/register/register_email_pass.dart';
import 'package:dara_app/view/pages/account/register/register_phone_number.dart';
import 'package:dara_app/view/pages/account/register/register_successful.dart';
import 'package:dara_app/view/pages/account/register/register_verify_phone.dart';
import 'package:dara_app/view/pages/accountant/accountant_home.dart';
import 'package:dara_app/view/pages/accountant/income.dart';
import 'package:dara_app/view/pages/admin/car_list/unit_preview.dart';
import 'package:dara_app/view/pages/admin/home_top_option/top_report.dart';
import 'package:dara_app/view/pages/admin/manage/inquiries/inquiries.dart';
import 'package:dara_app/view/pages/admin/manage/reports/reports.dart';
import 'package:dara_app/view/pages/admin/manage/status/status.dart';
import 'package:dara_app/view/pages/admin/manage/user_list/user_info.dart';
import 'package:dara_app/view/pages/admin/manage/user_list/user_list.dart';
import 'package:dara_app/view/pages/admin/rent_process/booking_details.dart';
import 'package:dara_app/view/pages/admin/rent_process/delivery_mode.dart';
import 'package:dara_app/view/pages/admin/rent_process/details_fees.dart';
import 'package:dara_app/view/pages/admin/rent_process/documents/submit_documents.dart';
import 'package:dara_app/view/pages/admin/rent_process/documents/verify_booking.dart';
import 'package:dara_app/view/pages/admin/rent_process/payment_success.dart';
import 'package:dara_app/view/pages/admin/rentals/report.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_1.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_2.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_3.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_4.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_5.dart';
import 'package:dara_app/view/pages/carousel/widgets/page_6.dart';
import 'package:dara_app/view/pages/entry/entry_page_video.dart';
import 'package:dara_app/view/pages/admin/home/home_page.dart';
import 'package:dara_app/view/pages/outsource/accounting_outsource.dart';
import 'package:dara_app/view/pages/outsource/manage_outsource.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        // Add other providers here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const DeepLinkHandler(),
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

          // Rentals - report page
          "rentals_report": (context) => const Report(),

          // Selected item
          "selected_item": (context) => const UnitPreview(),

          // Admin options - Manage report
          "manage_report": (context) => const ManageReports(),

          // Admin option - Manage inquiries
          "manage_inquiries": (context) => const Inquiries(),

          // Admin option - Manage Car Status
          "manage_car_status": (context) => const CarStatus(),

          // Admin option - User List
          "manage_user_list": (context) => const UserList(),
          "manage_user_list_info": (context) => const UserInfo(),

          // Renting process - Booking Details
          "rp_booking_details": (context) => const RPBookingDetails(),
          "rp_delivery_mode": (context) => const RPDeliveryMode(),
          "rp_details_fees": (context) => const RPDetailsFees(isDeepLink: false),
          "rp_payment_success": (context) => const PaymentSuccess(),
          "rp_submit_documents": (context) => const SubmitDocuments(),
          "rp_verify_booking": (context) => const VerifyBooking(),

          // Top option - report
          "to_report": (context) => const TopOptionReport(),

          // Accountant manage option
          "to_manage_accountant": (context) => const AccountantOption(),
          "to_income_accountant": (context) => const IncomePage(),

          // Outsource manage option
          "manage_outsource": (context) => const OutsourceManage(),
          "accounting_outsource": (context) => const OutsourceAccounting()
        },
      ),
    );
  }
}

class DeepLinkHandler extends StatefulWidget {
  const DeepLinkHandler({Key? key}) : super(key: key);

  @override
  _DeepLinkHandlerState createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> {
  @override
  void initState() {
    super.initState();
    _initLinks();
  }

  void _initLinks() async {
    try {
      // Get the initial link if the app was launched via a deep link
      final initialLink = await getInitialLink();
      _handleDeepLink(initialLink);

      // Listen for incoming deep links
      linkStream.listen((link) {
        _handleDeepLink(link);
      });
    } on PlatformException {
      debugPrint('Failed to get initial link.');
    }
  }

  void _handleDeepLink(String? link) {
    if (link != null) {
      if (link.contains('payment-success')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PaymentSuccess()),
        );
      } else if (link.contains('payment-failed')) {
        Navigator.pushReplacement(
          context,
          // MaterialPageRoute(builder: (context) => const PaymentFailed()),
          MaterialPageRoute(builder: (context) => const PaymentSuccess()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your app's home widget
    return const EntryPage();
  }
}
