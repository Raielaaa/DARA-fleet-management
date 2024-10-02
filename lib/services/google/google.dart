import 'dart:convert';

import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/view/shared/info_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';

class GoogleLogin {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      "email",
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/user.birthday.read',
      PeopleServiceApi.userBirthdayReadScope
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

      final GoogleAuthClient httpClient = GoogleAuthClient({'Authorization': 'Bearer $accessToken'});
      PeopleServiceApi peopleApi = PeopleServiceApi(httpClient);

      final Person person = await peopleApi.people.get(
        'people/me',
        personFields:
        'birthdays,genders', // add more fields with comma separated and no space
      );

      /// Birthdate
      final date = person.birthdays![0].date!;
      PersistentData().birthdayFromGoogleSignIn = date.toString();
    debugPrint("google.dart-birthday: $date");
      final DateTime birthdayDateTime = DateTime(
        date.year ?? 0,
        date.month ?? 0,
        date.day ?? 0,
      );

      return userCredential.user;
    } catch (e) {
      InfoDialog().show(context: context, content: "Google sign-in error: ${e.toString()}", header: "Warning");
      debugPrint("Google sign-in error: ${e.toString()}");
      return null;
    }
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
