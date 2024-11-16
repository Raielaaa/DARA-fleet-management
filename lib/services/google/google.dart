import 'dart:convert';

import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/view/shared/info_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';

import '../../model/account/user_role.dart';
import '../../view/shared/loading.dart';
import '../firebase/firestore.dart';

class GoogleLogin {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      PeopleServiceApi.userBirthdayReadScope
    ]
  );

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      debugPrint("checkpoint-1");
      if (googleSignInAccount == null) {
        // Handle case where sign-in was canceled
        LoadingDialog().dismiss();
        InfoDialog().show(context: context, content: "Google sign-in was canceled", header: "Warning");
        return null;
      }
      debugPrint("checkpoint-2");
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final String? accessToken = googleSignInAuthentication.accessToken;
      debugPrint("Access-token: $accessToken");
      final String? idToken = googleSignInAuthentication.idToken;
      debugPrint("checkpoint-3");
      if (accessToken == null || idToken == null) {
        // Handle case where tokens are null
        InfoDialog().show(context: context, content: "Failed to retrieve authentication tokens", header: "Warning");
        return null;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      debugPrint("checkpoint-4");
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      PersistentData().googleAccount = googleSignInAccount;

      // Retrieve the email of the signed-in user
      final User? user = userCredential.user;
      List<UserRoleLocal> _userRoleLocal = await Firestore().getUserRoleInfo();
      bool userFound = false;

      for (int i = 0; i < _userRoleLocal.length; i++) {
        debugPrint("email1: ${_userRoleLocal[i].email}.....email2: ${user?.email}");
        debugPrint("role1: ${_userRoleLocal[i].chosenRole}.....role2: ${PersistentData().userType}");
        if (_userRoleLocal[i].email == user?.email && _userRoleLocal[i].chosenRole == PersistentData().userType) {
          userFound = true;
          break;
        }
      }

      if (!userFound) {
        LoadingDialog().dismiss();
        InfoDialog().show(
            context: context,
            content: "An account with the selected role does not exist. Please ensure you selected the correct role during registration.",
            header: "Warning"
        );
        return null;
      }
      // debugPrint("checkpoint-5");
      // final GoogleAuthClient httpClient = GoogleAuthClient({'Authorization': 'Bearer $accessToken'});
      // PeopleServiceApi peopleApi = PeopleServiceApi(httpClient);
      // debugPrint("checkpoint-6");
      // final Person person = await peopleApi.people.get(
      //   'people/me',
      //   personFields: 'birthdays'
      // );
      //
      // debugPrint("checkpoint-7");
      // /// Birthdate
      // debugPrint("Date: ${person.birthdays}");
      // final date = person.birthdays![0].date!;
      // PersistentData().birthdayFromGoogleSignIn = date.toString();
      // debugPrint("google.dart-birthday: $date");

      return userCredential.user;
    } catch (e) {
      LoadingDialog().dismiss();
      InfoDialog().show(context: context, content: "Google sign-in error: ${e.toString()}", header: "Warning");
      debugPrint("Google sign-in error: ${e.toString()}");
    }
    return null;
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
