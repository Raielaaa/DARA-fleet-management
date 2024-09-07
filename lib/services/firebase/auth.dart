import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

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
  Future<UserCredential> createUserWithEmailAndPassword(
    {
      required String email,
      required String password
    }
  ) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
  }

  //  Signs out the current user.
  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}