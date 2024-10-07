class UserRoleLocal {
  String userID;
  String firstName;
  String lastName;
  String chosenRole;
  String email;

  UserRoleLocal({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.chosenRole,
    required this.email
  });

  Map<String, String> getModelData() {
    return {
      "user_id" : userID,
      "user_firstname" : firstName,
      "user_lastname" : lastName,
      "user_role" : chosenRole,
      "user_email": email
    };
  }

  factory UserRoleLocal.fromFirestore(Map<String, dynamic> data) {
    return UserRoleLocal(
        userID: data["user_id"] ?? "",
        firstName: data["user_firstname"] ?? "",
        lastName: data["user_lastname"] ?? "",
        chosenRole: data["user_role"] ?? "",
        email: data["user_email"] ?? ""
    );
  }
}