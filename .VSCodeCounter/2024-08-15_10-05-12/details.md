# Details

Date : 2024-08-15 10:05:12

Directory c:\\Users\\Daniel\\Desktop\\Flutter_Practice\\dara\\dara_app\\lib

Total : 41 files,  10340 codes, 361 comments, 490 blanks, all 11191 lines

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [lib/controller/account/login_controller.dart](/lib/controller/account/login_controller.dart) | Dart | 50 | 2 | 4 | 56 |
| [lib/controller/account/register_controller.dart](/lib/controller/account/register_controller.dart) | Dart | 131 | 7 | 10 | 148 |
| [lib/controller/providers/register_provider.dart](/lib/controller/providers/register_provider.dart) | Dart | 42 | 3 | 6 | 51 |
| [lib/controller/singleton/persistent_data.dart](/lib/controller/singleton/persistent_data.dart) | Dart | 23 | 7 | 11 | 41 |
| [lib/controller/utils/intent_utils.dart](/lib/controller/utils/intent_utils.dart) | Dart | 31 | 2 | 5 | 38 |
| [lib/firebase_options.dart](/lib/firebase_options.dart) | Dart | 53 | 12 | 4 | 69 |
| [lib/main.dart](/lib/main.dart) | Dart | 73 | 9 | 14 | 96 |
| [lib/model/account/register_model.dart](/lib/model/account/register_model.dart) | Dart | 28 | 0 | 2 | 30 |
| [lib/model/constants/firebase_constants.dart](/lib/model/constants/firebase_constants.dart) | Dart | 3 | 0 | 0 | 3 |
| [lib/services/firebase/auth.dart](/lib/services/firebase/auth.dart) | Dart | 31 | 6 | 6 | 43 |
| [lib/services/firebase/firestore.dart](/lib/services/firebase/firestore.dart) | Dart | 14 | 0 | 2 | 16 |
| [lib/services/google/google.dart](/lib/services/google/google.dart) | Dart | 21 | 0 | 5 | 26 |
| [lib/view/pages/account/account_opening.dart](/lib/view/pages/account/account_opening.dart) | Dart | 71 | 7 | 8 | 86 |
| [lib/view/pages/account/login/login.dart](/lib/view/pages/account/login/login.dart) | Dart | 222 | 17 | 18 | 257 |
| [lib/view/pages/account/register/register.dart](/lib/view/pages/account/register/register.dart) | Dart | 220 | 10 | 17 | 247 |
| [lib/view/pages/account/register/register_email_pass.dart](/lib/view/pages/account/register/register_email_pass.dart) | Dart | 164 | 12 | 12 | 188 |
| [lib/view/pages/account/register/register_phone_number.dart](/lib/view/pages/account/register/register_phone_number.dart) | Dart | 154 | 15 | 14 | 183 |
| [lib/view/pages/account/register/register_successful.dart](/lib/view/pages/account/register/register_successful.dart) | Dart | 63 | 5 | 7 | 75 |
| [lib/view/pages/account/register/register_verify_phone.dart](/lib/view/pages/account/register/register_verify_phone.dart) | Dart | 105 | 8 | 9 | 122 |
| [lib/view/pages/account/register/widgets/terms_and_conditions.dart](/lib/view/pages/account/register/widgets/terms_and_conditions.dart) | Dart | 370 | 34 | 36 | 440 |
| [lib/view/pages/admin/car_list/car_list_.dart](/lib/view/pages/admin/car_list/car_list_.dart) | Dart | 720 | 15 | 24 | 759 |
| [lib/view/pages/admin/car_list/unit_preview.dart](/lib/view/pages/admin/car_list/unit_preview.dart) | Dart | 694 | 28 | 18 | 740 |
| [lib/view/pages/admin/center_button/google_maps.dart](/lib/view/pages/admin/center_button/google_maps.dart) | Dart | 19 | 0 | 3 | 22 |
| [lib/view/pages/admin/home/home_page.dart](/lib/view/pages/admin/home/home_page.dart) | Dart | 161 | 4 | 10 | 175 |
| [lib/view/pages/admin/home/main_home.dart](/lib/view/pages/admin/home/main_home.dart) | Dart | 741 | 9 | 11 | 761 |
| [lib/view/pages/admin/manage/inquiries/inquiries.dart](/lib/view/pages/admin/manage/inquiries/inquiries.dart) | Dart | 527 | 16 | 23 | 566 |
| [lib/view/pages/admin/manage/reports/reports.dart](/lib/view/pages/admin/manage/reports/reports.dart) | Dart | 1,067 | 29 | 34 | 1,130 |
| [lib/view/pages/admin/profile/profile.dart](/lib/view/pages/admin/profile/profile.dart) | Dart | 1,182 | 28 | 25 | 1,235 |
| [lib/view/pages/admin/rentals/rentals.dart](/lib/view/pages/admin/rentals/rentals.dart) | Dart | 1,319 | 24 | 30 | 1,373 |
| [lib/view/pages/admin/rentals/report.dart](/lib/view/pages/admin/rentals/report.dart) | Dart | 428 | 8 | 20 | 456 |
| [lib/view/pages/carousel/carousel_page.dart](/lib/view/pages/carousel/carousel_page.dart) | Dart | 12 | 0 | 3 | 15 |
| [lib/view/pages/carousel/widgets/page_1.dart](/lib/view/pages/carousel/widgets/page_1.dart) | Dart | 117 | 2 | 5 | 124 |
| [lib/view/pages/carousel/widgets/page_2.dart](/lib/view/pages/carousel/widgets/page_2.dart) | Dart | 152 | 2 | 5 | 159 |
| [lib/view/pages/carousel/widgets/page_3.dart](/lib/view/pages/carousel/widgets/page_3.dart) | Dart | 152 | 2 | 5 | 159 |
| [lib/view/pages/carousel/widgets/page_4.dart](/lib/view/pages/carousel/widgets/page_4.dart) | Dart | 152 | 2 | 5 | 159 |
| [lib/view/pages/carousel/widgets/page_5.dart](/lib/view/pages/carousel/widgets/page_5.dart) | Dart | 152 | 2 | 5 | 159 |
| [lib/view/pages/carousel/widgets/page_6.dart](/lib/view/pages/carousel/widgets/page_6.dart) | Dart | 152 | 2 | 5 | 159 |
| [lib/view/pages/entry/entry_page_video.dart](/lib/view/pages/entry/entry_page_video.dart) | Dart | 49 | 0 | 10 | 59 |
| [lib/view/shared/colors.dart](/lib/view/shared/colors.dart) | Dart | 27 | 3 | 2 | 32 |
| [lib/view/shared/components.dart](/lib/view/shared/components.dart) | Dart | 255 | 4 | 12 | 271 |
| [lib/view/shared/strings.dart](/lib/view/shared/strings.dart) | Dart | 393 | 25 | 45 | 463 |

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)