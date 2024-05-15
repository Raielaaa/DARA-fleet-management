class RegisterModel {
  String id;
  String firstName;
  String lastName;
  String birthday;
  String email;
  String number;

  RegisterModel(
    {
      required this.id,
      required this.firstName,
      required this.lastName,
      required this.birthday,
      required this.email,
      required this.number
    }
  );

  Map<String, String> getModelData() {
    return {
      "user_id" : id,
      "user_firstname" : firstName,
      "user_lastname" : lastName,
      "user_birthday" : birthday,
      "user_email" : email,
      "user_number" : number
    };
  }
}