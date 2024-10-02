import 'dart:convert';

import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/view/shared/info_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      "email",
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/user.birthday.read', // Request birthday scope
    ]
  );

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // Handle case where sign-in was canceled
        InfoDialog().show(context: context, content: "Google sign-in was canceled", header: "Warning");
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final String? accessToken = googleSignInAuthentication.accessToken;
      final String? idToken = googleSignInAuthentication.idToken;

      if (accessToken == null || idToken == null) {
        // Handle case where tokens are null
        InfoDialog().show(context: context, content: "Failed to retrieve authentication tokens", header: "Warning");
        return null;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Fetch birthday using People API
      final response = await http.get(
        Uri.parse('https://people.googleapis.com/v1/people/me?personFields=birthdays'),
        headers: await googleSignInAccount.authHeaders,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var birthdays = data['birthdays'];

        if (birthdays != null && birthdays.isNotEmpty) {
          debugPrint('Birthday: ${birthdays}');
          PersistentData().birthdayFromGoogleSignIn = birthdays;
        } else {
          debugPrint('Birthday is not available');
          PersistentData().birthdayFromGoogleSignIn = ""; // Handle null case
        }
      } else {
        debugPrint('Failed to fetch birthday data. Status code: ${response.statusCode}');
      }

      return userCredential.user;
    } catch (e) {
      InfoDialog().show(context: context, content: "Google sign-in error: ${e.toString()}", header: "Warning");
      debugPrint("Google sign-in error: ${e.toString()}");
      return null;
    }
  }
}
