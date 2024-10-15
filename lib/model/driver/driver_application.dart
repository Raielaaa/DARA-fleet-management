class DriverApplication {
  String piFirstName;
  String piMiddleName;
  String piLastName;
  String piBirthday;
  String piCivilStatus;
  String piReligion;
  String piCompleteAddress;
  String piMobileNumber;
  String piEmailAddress;
  String piFatherName;
  String piFatherBirthplace;
  String piMotherName;
  String piMotherBirthplace;
  String piHeight;
  String piWeight;
  String ecNameContactPerson;
  String ecRelationship;
  String ecContactNumber;
  String ecCompleteAddress;
  String epiEducationAttainment;
  String epiDriverLicense;
  String epiSSSNumber;
  String epiTINNumber;

  DriverApplication({
    required this.piFirstName,
    required this.piMiddleName,
    required this.piLastName,
    required this.piBirthday,
    required this.piCivilStatus,
    required this.piReligion,
    required this.piCompleteAddress,
    required this.piMobileNumber,
    required this.piEmailAddress,
    required this.piFatherName,
    required this.piFatherBirthplace,
    required this.piMotherName,
    required this.piMotherBirthplace,
    required this.piHeight,
    required this.piWeight,
    required this.ecNameContactPerson,
    required this.ecRelationship,
    required this.ecContactNumber,
    required this.ecCompleteAddress,
    required this.epiEducationAttainment,
    required this.epiDriverLicense,
    required this.epiSSSNumber,
    required this.epiTINNumber,
  });

  Map<String, String> getModelData() {
    return {
      "pi_first_name": piFirstName,
      "pi_middle_name": piMiddleName,
      "pi_last_name": piLastName,
      "pi_birthday": piBirthday,
      "pi_civil_status": piCivilStatus,
      "pi_religion": piReligion,
      "pi_complete_address": piCompleteAddress,
      "pi_mobile_number": piMobileNumber,
      "pi_email_address": piEmailAddress,
      "pi_father_name": piFatherName,
      "pi_father_birthplace": piFatherBirthplace,
      "pi_mother_name": piMotherName,
      "pi_mother_birthplace": piMotherBirthplace,
      "pi_height": piHeight,
      "pi_weight": piWeight,
      "ec_name_contact_person": ecNameContactPerson,
      "ec_relationship": ecRelationship,
      "ec_contact_number": ecContactNumber,
      "ec_complete_address": ecCompleteAddress,
      "epi_education_attainment": epiEducationAttainment,
      "epi_driver_license": epiDriverLicense,
      "epi_sss_number": epiSSSNumber,
      "epi_tin_number": epiTINNumber,
    };
  }

  factory DriverApplication.fromFirestore(Map<String, dynamic> data) {
    return DriverApplication(
      piFirstName: data["pi_first_name"] ?? "",
      piMiddleName: data["pi_middle_name"] ?? "",
      piLastName: data["pi_last_name"] ?? "",
      piBirthday: data["pi_birthday"] ?? "",
      piCivilStatus: data["pi_civil_status"] ?? "",
      piReligion: data["pi_religion"] ?? "",
      piCompleteAddress: data["pi_complete_address"] ?? "",
      piMobileNumber: data["pi_mobile_number"] ?? "",
      piEmailAddress: data["pi_email_address"] ?? "",
      piFatherName: data["pi_father_name"] ?? "",
      piFatherBirthplace: data["pi_father_birthplace"] ?? "",
      piMotherName: data["pi_mother_name"] ?? "",
      piMotherBirthplace: data["pi_mother_birthplace"] ?? "",
      piHeight: data["pi_height"] ?? "",
      piWeight: data["pi_weight"] ?? "",
      ecNameContactPerson: data["ec_name_contact_person"] ?? "",
      ecRelationship: data["ec_relationship"] ?? "",
      ecContactNumber: data["ec_contact_number"] ?? "",
      ecCompleteAddress: data["ec_complete_address"] ?? "",
      epiEducationAttainment: data["epi_education_attainment"] ?? "",
      epiDriverLicense: data["epi_driver_license"] ?? "",
      epiSSSNumber: data["epi_sss_number"] ?? "",
      epiTINNumber: data["epi_tin_number"] ?? "",
    );
  }
}
