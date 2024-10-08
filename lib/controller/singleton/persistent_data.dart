// ignore_for_file: unnecessary_getters_setters
import 'package:dara_app/model/account/register_model.dart';
import 'package:dara_app/model/home/featured_car_info.dart';
import 'package:geocoding/geocoding.dart';

import '../../model/car_list/complete_car_list.dart';


class PersistentData {
  //  Private constructors
  PersistentData._privateConstructor();

  //  The single instance of the class
  static final PersistentData _instance = PersistentData._privateConstructor();

  //  Factory constructor to provide access to the instance
  factory PersistentData() {
    return _instance;
  }

  //  Custom methods and properties

  //  Register page informations
  String? _firstName;
  String? _lastName;
  String? _birthday;
  String? _email;
  String? _password;

  String? get getFirstName => _firstName;
  set setFirstName(String? value) => _firstName = value;

  String? get getLastName => _lastName;
  set setLastName(String? value) => _lastName = value;

  String? get getBirthday => _birthday;
  set setBirthday(String? value) => _birthday = value;

  String? get getEmail => _email;
  set setEmail(String? value) => _email = value;

  String? get getPassword => _password;
  set setPassword(String? value) => _password = value;

  //  For checking if the registration is successful
  bool isRegistrationSuccessful = false;


  //  login page
  String userType = "Renter";

  //  selected role on register
  String? selectedRoleOnRegister;
  String? verificationId;

  //  phone number insert + otp verification page authenticator for dialog
  bool isFromOtpPage = false;
  bool isOtpVerified = false;
  String? inputtedCellphoneNumber;
  int? forceResendingToken;

  //  for updating the user info (user number)
  String userUId = "";

  String birthdayFromGoogleSignIn = "";

  //  maps
  String mapsLatitude = "";
  String mapsLongitude = "";
  double startMapsLatitude = 0.0;
  double startMapsLongitude = 0.0;

  double endMapsLatitude = 0.0;
  double endMapsLongitude = 0.0;

  //////////////////////////////////////////////////////////  RENTING PROCESS ////////////////////////////////////////////
  // booking details info to be inserted to the database
  String distanceFromGarageToDeliveryLocation = "";
  String drivingDistance = "";
  String drivingTimeDuration = "";
  int rentalDurationInMinutes = 0;
  String bookingDetailsMapsLocationFromLongitudeLatitude = "";
  String bookingDetailsMapsLocationFromLongitudeLatitude_forrent_location = "";
  String bookingDetailsStartingDate = "";
  String bookingDetailsEndingDate = "";
  String bookingDetailsStartingTime = "";
  String bookingDetailsEndingTime = "";
  bool bookingDetailsRentWithDriver = false;
  //  delivery mode
  String deliveryModePickUpOrDelivery = "";
  String deliveryModeLocation = "";

  /////////////////////////////////////////////////////////   RENTING PROCESS   //////////////////////////////////////////////////
  //  selected item to be displayed - car list info
  CompleteCarInfo? selectedCarItem;
  FeaturedCarInfo? selectedFeaturedCarItem;

  RegisterModel? userInfo;
}