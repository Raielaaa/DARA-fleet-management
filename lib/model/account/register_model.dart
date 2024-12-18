class RegisterModel {
  String id;
  String firstName;
  String lastName;
  String birthday;
  String email;
  String number;
  String role;
  String status;
  String dateCreated;
  String totalAmountSpent;
  String longestRentalDate;
  String favorite;
  String rentalCount;

  RegisterModel(
    {
      required this.id,
      required this.firstName,
      required this.lastName,
      required this.birthday,
      required this.email,
      required this.number,
      required this.role,
      required this.status,
      required this.dateCreated,
      required this.totalAmountSpent,
      required this.longestRentalDate,
      required this.favorite,
      required this.rentalCount,
    }
  );

  Map<String, String> getModelData() {
    return {
      "user_id" : id,
      "user_firstname" : firstName,
      "user_lastname" : lastName,
      "user_birthday" : birthday,
      "user_email" : email,
      "user_number" : number,
      "user_role" : role,
      "user_status" : status,
      "user_date_created": dateCreated,
      "user_total_amount_spent": totalAmountSpent,
      "user_longest_rental_date": longestRentalDate,
      "user_favorite": favorite,
      "user_rental_count": rentalCount,
    };
  }

  factory RegisterModel.fromFirestore(Map<String, dynamic> data) {
    return RegisterModel(
      id: data["user_id"] ?? "",
      firstName: data["user_firstname"] ?? "",
      lastName: data["user_lastname"] ?? "",
      birthday: data["user_birthday"] ?? "",
      email: data["user_email"] ?? "",
      number: data["user_number"] ?? "",
      role: data["user_role"] ?? "",
      status: data["user_status"] ?? "",
      dateCreated: data["user_date_created"] ?? "",
      totalAmountSpent: data["user_total_amount_spent"] ?? "",
      longestRentalDate: data["user_longest_rental_date"] ?? "",
      favorite: data["user_favorite"] ?? "",
      rentalCount: data["user_rental_count"] ?? "",
    );
  }
}