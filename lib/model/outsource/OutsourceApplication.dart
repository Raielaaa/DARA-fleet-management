class OutsourceApplication {
  String userType;
  String userID;
  String userFirstName;
  String userLastName;
  String userEmail;
  String userDateRegistered;
  String userNumber;
  String viCarModel;
  String viCarBrand;
  String viManufacturingYear;
  String viNumber;
  String ppFirstName;
  String ppMiddleName;
  String ppLastName;
  String ppBirthday;
  String ppAge;
  String ppBirthPlace;
  String ppCitizenship;
  String ppCivilStatus;
  String ppMotherName;
  String ppContactNumber;
  String ppEducationalAttainment;
  String ppEmailAddress;
  String ppAddress;
  String ppYearsStayed;
  String ppHouseStatus;
  String ppTinNumber;
  String eiCompanyName;
  String eiAddress;
  String eiTelephoneNumber;
  String eiPosition;
  String eiLengthOfStay;
  String eiMonthlySalary;
  String biBusinessName;
  String biCompleteAddress;
  String biYearsOfOperation;
  String biBusinessContactNumber;
  String biBusinessEmailAddress;
  String biPosition;
  String biMonthlyIncomeGross;
  String rentalAgreementOptions;
  String applicationStatus;

  OutsourceApplication({
    required this.userType,
    required this.userID,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    required this.userDateRegistered,
    required this.userNumber,
    required this.viCarModel,
    required this.viCarBrand,
    required this.viManufacturingYear,
    required this.viNumber,
    required this.ppFirstName,
    required this.ppMiddleName,
    required this.ppLastName,
    required this.ppEducationalAttainment,
    required this.ppBirthday,
    required this.ppAge,
    required this.ppBirthPlace,
    required this.ppCitizenship,
    required this.ppCivilStatus,
    required this.ppMotherName,
    required this.ppContactNumber,
    required this.ppEmailAddress,
    required this.ppAddress,
    required this.ppYearsStayed,
    required this.ppHouseStatus,
    required this.ppTinNumber,
    required this.eiCompanyName,
    required this.eiAddress,
    required this.eiTelephoneNumber,
    required this.eiPosition,
    required this.eiLengthOfStay,
    required this.eiMonthlySalary,
    required this.biBusinessName,
    required this.biCompleteAddress,
    required this.biYearsOfOperation,
    required this.biBusinessContactNumber,
    required this.biBusinessEmailAddress,
    required this.biPosition,
    required this.biMonthlyIncomeGross,
    required this.rentalAgreementOptions,
    required this.applicationStatus,
  });

  Map<String, String> getModelData() {
    return {
      "user_type": userType,
      "user_id": userID,
      "user_first_name": userFirstName,
      "user_last_name": userLastName,
      "user_email": userEmail,
      "user_date_registered": userDateRegistered,
      "user_number": userNumber,
      "vi_car_model": viCarModel,
      "vi_car_brand": viCarBrand,
      "vi_manufacturing_year": viManufacturingYear,
      "vi_number": viNumber,
      "pp_first_name": ppFirstName,
      "pp_middle_name": ppMiddleName,
      "pp_last_name": ppLastName,
      "pp_birthday": ppBirthday,
      "pp_age": ppAge,
      "pp_birth_place": ppBirthPlace,
      "pp_citizenship": ppCitizenship,
      "pp_civil_status": ppCivilStatus,
      "pp_educational_attainment": ppEducationalAttainment,
      "pp_mother_name": ppMotherName,
      "pp_contact_number": ppContactNumber,
      "pp_email_address": ppEmailAddress,
      "pp_address": ppAddress,
      "pp_years_stayed": ppYearsStayed,
      "pp_house_status": ppHouseStatus,
      "pp_tin_number": ppTinNumber,
      "ei_company_name": eiCompanyName,
      "ei_address": eiAddress,
      "ei_telephone_number": eiTelephoneNumber,
      "ei_position": eiPosition,
      "ei_length_of_stay": eiLengthOfStay,
      "ei_monthly_salary": eiMonthlySalary,
      "bi_business_name": biBusinessName,
      "bi_complete_address": biCompleteAddress,
      "bi_years_of_operation": biYearsOfOperation,
      "bi_business_contact_number": biBusinessContactNumber,
      "bi_business_email_address": biBusinessEmailAddress,
      "bi_position": biPosition,
      "bi_monthly_income_gross": biMonthlyIncomeGross,
      "rental_agreement_options": rentalAgreementOptions,
      "application_status": applicationStatus
    };
  }

  factory OutsourceApplication.fromFirestore(Map<String, dynamic> data) {
    return OutsourceApplication(
      userType: data["user_type"] ?? "",
      userID: data["user_id"] ?? "",
      userFirstName: data["user_first_name"] ?? "",
      userLastName: data["user_last_name"] ?? "",
      userEmail: data["user_email"] ?? "",
      userDateRegistered: data["user_date_registered"] ?? "",
      userNumber: data["user_number"] ?? "",
      viCarModel: data["vi_car_model"] ?? "",
      viCarBrand: data["vi_car_brand"] ?? "",
      viManufacturingYear: data["vi_manufacturing_year"] ?? "",
      viNumber: data["vi_number"] ?? "",
      ppFirstName: data["pp_first_name"] ?? "",
      ppMiddleName: data["pp_middle_name"] ?? "",
      ppLastName: data["pp_last_name"] ?? "",
      ppBirthday: data["pp_birthday"] ?? "",
      ppAge: data["pp_age"] ?? "",
      ppBirthPlace: data["pp_birth_place"] ?? "",
      ppCitizenship: data["pp_citizenship"] ?? "",
      ppCivilStatus: data["pp_civil_status"] ?? "",
      ppMotherName: data["pp_mother_name"] ?? "",
      ppEducationalAttainment: data["pp_educational_attainment"] ?? "",
      ppContactNumber: data["pp_contact_number"] ?? "",
      ppEmailAddress: data["pp_email_address"] ?? "",
      ppAddress: data["pp_address"] ?? "",
      ppYearsStayed: data["pp_years_stayed"] ?? "",
      ppHouseStatus: data["pp_house_status"] ?? "",
      ppTinNumber: data["pp_tin_number"] ?? "",
      eiCompanyName: data["ei_company_name"] ?? "",
      eiAddress: data["ei_address"] ?? "",
      eiTelephoneNumber: data["ei_telephone_number"] ?? "",
      eiPosition: data["ei_position"] ?? "",
      eiLengthOfStay: data["ei_length_of_stay"] ?? "",
      eiMonthlySalary: data["ei_monthly_salary"] ?? "",
      biBusinessName: data["bi_business_name"] ?? "",
      biCompleteAddress: data["bi_complete_address"] ?? "",
      biYearsOfOperation: data["bi_years_of_operation"] ?? "",
      biBusinessContactNumber: data["bi_business_contact_number"] ?? "",
      biBusinessEmailAddress: data["bi_business_email_address"] ?? "",
      biPosition: data["bi_position"] ?? "",
      biMonthlyIncomeGross: data["bi_monthly_income_gross"] ?? "",
      rentalAgreementOptions: data["rental_agreement_options"] ?? "",
      applicationStatus: data["application_status"] ?? "",
    );
  }
}
