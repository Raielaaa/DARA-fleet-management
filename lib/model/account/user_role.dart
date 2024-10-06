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
}