# Details

Date : 2024-09-14 13:34:58

Directory c:\\Users\\Daniel\\Desktop\\Flutter_Practice\\dara\\dara_app\\lib

Total : 60 files,  15635 codes, 518 comments, 755 blanks, all 16908 lines

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [lib/controller/account/login_controller.dart](/lib/controller/account/login_controller.dart) | Dart | 47 | 20 | 4 | 71 |
| [lib/controller/account/register_controller.dart](/lib/controller/account/register_controller.dart) | Dart | 131 | 7 | 10 | 148 |
| [lib/controller/home/home_controller.dart](/lib/controller/home/home_controller.dart) | Dart | 267 | 11 | 20 | 298 |
| [lib/controller/providers/register_provider.dart](/lib/controller/providers/register_provider.dart) | Dart | 42 | 3 | 6 | 51 |
| [lib/controller/rent_process/rent_process.dart](/lib/controller/rent_process/rent_process.dart) | Dart | 143 | 3 | 13 | 159 |
| [lib/controller/singleton/persistent_data.dart](/lib/controller/singleton/persistent_data.dart) | Dart | 24 | 8 | 13 | 45 |
| [lib/controller/utils/constants.dart](/lib/controller/utils/constants.dart) | Dart | 5 | 0 | 0 | 5 |
| [lib/controller/utils/intent_utils.dart](/lib/controller/utils/intent_utils.dart) | Dart | 31 | 2 | 5 | 38 |
| [lib/firebase_options.dart](/lib/firebase_options.dart) | Dart | 53 | 12 | 4 | 69 |
| [lib/main.dart](/lib/main.dart) | Dart | 128 | 18 | 23 | 169 |
| [lib/model/account/register_model.dart](/lib/model/account/register_model.dart) | Dart | 28 | 0 | 2 | 30 |
| [lib/model/constants/firebase_constants.dart](/lib/model/constants/firebase_constants.dart) | Dart | 3 | 0 | 0 | 3 |
| [lib/services/firebase/auth.dart](/lib/services/firebase/auth.dart) | Dart | 64 | 6 | 8 | 78 |
| [lib/services/firebase/firestore.dart](/lib/services/firebase/firestore.dart) | Dart | 14 | 0 | 2 | 16 |
| [lib/services/gcash/gcash_payment.dart](/lib/services/gcash/gcash_payment.dart) | Dart | 57 | 6 | 5 | 68 |
| [lib/services/google/google.dart](/lib/services/google/google.dart) | Dart | 21 | 0 | 5 | 26 |
| [lib/services/weather/open_weather.dart](/lib/services/weather/open_weather.dart) | Dart | 39 | 8 | 8 | 55 |
| [lib/view/pages/account/account_opening.dart](/lib/view/pages/account/account_opening.dart) | Dart | 73 | 7 | 8 | 88 |
| [lib/view/pages/account/login/login.dart](/lib/view/pages/account/login/login.dart) | Dart | 400 | 24 | 22 | 446 |
| [lib/view/pages/account/register/register.dart](/lib/view/pages/account/register/register.dart) | Dart | 352 | 13 | 21 | 386 |
| [lib/view/pages/account/register/register_email_pass.dart](/lib/view/pages/account/register/register_email_pass.dart) | Dart | 164 | 12 | 12 | 188 |
| [lib/view/pages/account/register/register_phone_number.dart](/lib/view/pages/account/register/register_phone_number.dart) | Dart | 155 | 15 | 14 | 184 |
| [lib/view/pages/account/register/register_successful.dart](/lib/view/pages/account/register/register_successful.dart) | Dart | 63 | 5 | 7 | 75 |
| [lib/view/pages/account/register/register_verify_phone.dart](/lib/view/pages/account/register/register_verify_phone.dart) | Dart | 105 | 8 | 9 | 122 |
| [lib/view/pages/account/register/widgets/terms_and_conditions.dart](/lib/view/pages/account/register/widgets/terms_and_conditions.dart) | Dart | 346 | 34 | 36 | 416 |
| [lib/view/pages/accountant/accountant_home.dart](/lib/view/pages/accountant/accountant_home.dart) | Dart | 465 | 5 | 17 | 487 |
| [lib/view/pages/accountant/income.dart](/lib/view/pages/accountant/income.dart) | Dart | 330 | 1 | 16 | 347 |
| [lib/view/pages/accountant/income_dialog.dart](/lib/view/pages/accountant/income_dialog.dart) | Dart | 643 | 20 | 21 | 684 |
| [lib/view/pages/admin/car_list/car_list_.dart](/lib/view/pages/admin/car_list/car_list_.dart) | Dart | 720 | 15 | 24 | 759 |
| [lib/view/pages/admin/car_list/unit_preview.dart](/lib/view/pages/admin/car_list/unit_preview.dart) | Dart | 696 | 28 | 18 | 742 |
| [lib/view/pages/admin/center_button/google_maps.dart](/lib/view/pages/admin/center_button/google_maps.dart) | Dart | 19 | 0 | 3 | 22 |
| [lib/view/pages/admin/home/home_page.dart](/lib/view/pages/admin/home/home_page.dart) | Dart | 160 | 3 | 10 | 173 |
| [lib/view/pages/admin/home/main_home.dart](/lib/view/pages/admin/home/main_home.dart) | Dart | 839 | 18 | 15 | 872 |
| [lib/view/pages/admin/home_top_option/top_report.dart](/lib/view/pages/admin/home_top_option/top_report.dart) | Dart | 419 | 8 | 20 | 447 |
| [lib/view/pages/admin/manage/inquiries/inquiries.dart](/lib/view/pages/admin/manage/inquiries/inquiries.dart) | Dart | 528 | 16 | 23 | 567 |
| [lib/view/pages/admin/manage/reports/reports.dart](/lib/view/pages/admin/manage/reports/reports.dart) | Dart | 1,072 | 29 | 34 | 1,135 |
| [lib/view/pages/admin/manage/status/status.dart](/lib/view/pages/admin/manage/status/status.dart) | Dart | 764 | 11 | 10 | 785 |
| [lib/view/pages/admin/profile/profile.dart](/lib/view/pages/admin/profile/profile.dart) | Dart | 667 | 28 | 30 | 725 |
| [lib/view/pages/admin/rent_process/booking_details.dart](/lib/view/pages/admin/rent_process/booking_details.dart) | Dart | 424 | 5 | 21 | 450 |
| [lib/view/pages/admin/rent_process/delivery_mode.dart](/lib/view/pages/admin/rent_process/delivery_mode.dart) | Dart | 320 | 6 | 9 | 335 |
| [lib/view/pages/admin/rent_process/details_fees.dart](/lib/view/pages/admin/rent_process/details_fees.dart) | Dart | 330 | 3 | 14 | 347 |
| [lib/view/pages/admin/rent_process/documents/submit_documents.dart](/lib/view/pages/admin/rent_process/documents/submit_documents.dart) | Dart | 193 | 1 | 7 | 201 |
| [lib/view/pages/admin/rent_process/documents/verify_booking.dart](/lib/view/pages/admin/rent_process/documents/verify_booking.dart) | Dart | 71 | 1 | 4 | 76 |
| [lib/view/pages/admin/rent_process/gcash_webview.dart](/lib/view/pages/admin/rent_process/gcash_webview.dart) | Dart | 71 | 0 | 4 | 75 |
| [lib/view/pages/admin/rent_process/payment_success.dart](/lib/view/pages/admin/rent_process/payment_success.dart) | Dart | 239 | 2 | 7 | 248 |
| [lib/view/pages/admin/rentals/rentals.dart](/lib/view/pages/admin/rentals/rentals.dart) | Dart | 1,325 | 25 | 40 | 1,390 |
| [lib/view/pages/admin/rentals/report.dart](/lib/view/pages/admin/rentals/report.dart) | Dart | 428 | 8 | 20 | 456 |
| [lib/view/pages/carousel/carousel_page.dart](/lib/view/pages/carousel/carousel_page.dart) | Dart | 12 | 0 | 3 | 15 |
| [lib/view/pages/carousel/widgets/page_1.dart](/lib/view/pages/carousel/widgets/page_1.dart) | Dart | 118 | 2 | 5 | 125 |
| [lib/view/pages/carousel/widgets/page_2.dart](/lib/view/pages/carousel/widgets/page_2.dart) | Dart | 154 | 2 | 5 | 161 |
| [lib/view/pages/carousel/widgets/page_3.dart](/lib/view/pages/carousel/widgets/page_3.dart) | Dart | 154 | 2 | 5 | 161 |
| [lib/view/pages/carousel/widgets/page_4.dart](/lib/view/pages/carousel/widgets/page_4.dart) | Dart | 154 | 2 | 5 | 161 |
| [lib/view/pages/carousel/widgets/page_5.dart](/lib/view/pages/carousel/widgets/page_5.dart) | Dart | 154 | 2 | 5 | 161 |
| [lib/view/pages/carousel/widgets/page_6.dart](/lib/view/pages/carousel/widgets/page_6.dart) | Dart | 154 | 2 | 5 | 161 |
| [lib/view/pages/entry/entry_page_video.dart](/lib/view/pages/entry/entry_page_video.dart) | Dart | 49 | 0 | 10 | 59 |
| [lib/view/shared/colors.dart](/lib/view/shared/colors.dart) | Dart | 31 | 4 | 3 | 38 |
| [lib/view/shared/components.dart](/lib/view/shared/components.dart) | Dart | 255 | 4 | 12 | 271 |
| [lib/view/shared/info_dialog.dart](/lib/view/shared/info_dialog.dart) | Dart | 266 | 3 | 10 | 279 |
| [lib/view/shared/loading.dart](/lib/view/shared/loading.dart) | Dart | 91 | 4 | 7 | 102 |
| [lib/view/shared/strings.dart](/lib/view/shared/strings.dart) | Dart | 565 | 36 | 56 | 657 |

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)