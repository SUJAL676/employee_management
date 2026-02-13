import 'package:employee_management/providers/employee_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleSignInService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool isInitialize = false;
  static Future<void> initSignIn() async {
    if (!isInitialize) {
      await _googleSignIn.initialize();
    }
    isInitialize = true;
  }

  static Future<String> signInWithGoogle({
    required BuildContext context,
  }) async {
    try {
      await initSignIn();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;

      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);

      final accessToken = authorization?.accessToken;

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        final DatabaseReference ref = FirebaseDatabase.instance.ref(
          "users/${user.uid}",
        );

        await ref.update({
          "uid": user.uid,
          "name": user.displayName ?? "",
          "email": user.email ?? "",
          "phone": user.phoneNumber ?? "",
          "photoUrl": user.photoURL ?? "",
          "createdAt": DateTime.now().toIso8601String(),
        });
      }

      EmployeeProvider provider = Provider.of<EmployeeProvider>(
        context,
        listen: false,
      );
      provider.initialCredentials(cred: user!);

      return "Sucess";
    } catch (e) {
      print('Error: $e');
      return "Error";
    }
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw e;
    }
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
