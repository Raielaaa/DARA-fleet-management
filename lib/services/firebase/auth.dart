import "package:dara_app/model/account/user_role.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:googleapis/dfareporting/v4.dart";
import "package:intl/intl.dart";

import "../../controller/singleton/persistent_data.dart";
import "../../model/account/register_model.dart";
import "../../model/constants/firebase_constants.dart";
import "firestore.dart";

class Auth {
  //  Returns an instance using the default [FirebaseApp].
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Returns the current [User] if they are currently signed-in, or null if not.
  User? get currentUser => _firebaseAuth.currentUser;

  //  Notifies about changes to the user's sign-in state (such as sign-in or sign-out).
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //  Attempts to sign in a user with the given email address and password.
  Future<void> signInWithEmailAndPassword(
    {
      required String email,
      required String password,
      required BuildContext context
    }
  ) async {
    LoadingDialog().show(context: context, content: "Please wait while we verify your crredentials.");
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      User? user = userCredential.user;
      if (user != null) {
        debugPrint("services-firebase-auth.dart/29 - Successfully logged in as: ${user.email}");
        LoadingDialog().dismiss();

        if (context.mounted) {
          Navigator.pushNamed(context, "home_main");
        } else {
          debugPrint("services-firebase-auth.dart/37 - Unmounted context");
        }
      }
    } on FirebaseAuthException catch(e) {
      LoadingDialog().dismiss();
      if (context.mounted) {
        InfoDialog().show(context: context, content: "An error occured: ${e.message}", header: "Warning");
      } else {
        debugPrint("services-firebase-auth.dart/46 - Unmounted context");
      }
    } catch (e) {
      LoadingDialog().dismiss();
      if (context.mounted) {
        InfoDialog().show(context: context, content: "An unknown error occured: ${e.toString()}", header: "Warning");
      } else {
        debugPrint("services-firebase-auth.dart/60 - Unmounted context");
      }
    }
  }

  //  Tries to create a new user account with the given email address and password.
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    try {
      // Create the user and get the UserCredential object
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's UID
      String? userUID = userCredential.user?.uid;

      debugPrint('User UID: $userUID');

      //  insert user info to db
      debugPrint("register checkpoint 1");
      debugPrint("userID 2");
      PersistentData _persistentData = PersistentData();
      _persistentData.userUId = userUID!;
      RegisterModel _userData = RegisterModel(
          id: userUID ?? "empty_userID",
          firstName: _persistentData.getFirstName.toString(),
          lastName: _persistentData.getLastName.toString(),
          birthday: _persistentData.getBirthday.toString(),
          email: _persistentData.getEmail.toString(),
          number: "",
          role: _persistentData.selectedRoleOnRegister.toString(),
          status: "unverified",
          dateCreated: getCurrentDateTime(),
          totalAmountSpent: "",
          longestRentalDate: "",
          favorite: "",
          rentalCount: "",
      );

      //  insert user role db
      UserRoleLocal _userRole = UserRoleLocal(
          userID: userUID,
          firstName: _persistentData.getFirstName.toString(),
          lastName: _persistentData.getLastName.toString(),
          chosenRole: _persistentData.selectedRoleOnRegister.toString(),
          email: _persistentData.getEmail.toString(),
      );
      debugPrint("register checkpoint 2");
      try {
        await Firestore().addUserInfo(
            collectionName: FirebaseConstants.registerCollection,
            documentName: userUID ?? "empty document name",
            data: _userData.getModelData()
        );
        debugPrint("breakpoint-login-credentials-creation");

      } on FirebaseException catch (exception) {
        debugPrint("breakpoint-login-credentials-creation-exeption-1: $exception");
        CustomComponents.showAlertDialog(
          context: context,
          title: ProjectStrings.general_dialog_db_error_header,
          content: "${ProjectStrings.general_dialog_db_error_body}${exception.message}",
          numberOfOptions: 1,
          onPressedPositive: () {
            Navigator.of(context).pop();
          },
        );
      } catch(e) {
        debugPrint("fatal error: $e");
      }
      // insert user role to db
      try {
        await Firestore().addUserInfo(
            collectionName: FirebaseConstants.registerRoleCollection,
            documentName: userUID ?? "empty document name",
            data: _userRole.getModelData()
        );
        debugPrint("breakpoint-user-role");

      } on FirebaseException catch (exception) {
        debugPrint("breakpoint-user-role-creation-exeption-1: $exception");
        CustomComponents.showAlertDialog(
          context: context,
          title: ProjectStrings.general_dialog_db_error_header,
          content: "${ProjectStrings.general_dialog_db_error_body}${exception.message}",
          numberOfOptions: 1,
          onPressedPositive: () {
            Navigator.of(context).pop();
          },
        );
      } catch(e) {
        debugPrint("fatal error: $e");
      }

    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat("MMMM dd, yyyy : hh:mm a");
    return formatter.format(now);
  }


  //  Signs out the current user.
  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}