// ignore_for_file: unnecessary_getters_setters
import 'package:geocoding/geocoding.dart';


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
  String userType = "User";

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

  // booking details info to be inserted to the database
  String bookingDetailsMapsLocationFromLongitudeLatitude = "";
  String bookingDetailsStartingDate = "";
  String bookingDetailsEndingDate = "";
  String bookingDetailsStartingTime = "";
  String bookingDetailsEndingTime = "";
  bool bookingDetailsRentWithDriver = false;
}