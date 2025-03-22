// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resort_automation_app/core/model_classes/sign_in_model.dart';
import 'package:resort_automation_app/core/model_classes/sign_up_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static AuthService? _authService;

  final FirebaseAuth auth;
  AuthService._internal({required this.auth});
  factory AuthService({required FirebaseAuth auth}) {
    return _authService ??= AuthService._internal(auth: auth);
  }

  Future<User?> createUserWithEmailAndPassword(SignUpModel model) async {
    final userCredentials = await auth.createUserWithEmailAndPassword(
        email: model.email, password: model.password);
    return userCredentials.user;
  }

  Future<User?> userSigin({required SignInModel signInModel}) async {
    log('email:${signInModel.email.toString()} password:${signInModel.password.toString()}');
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: signInModel.email,
      password: signInModel.password,
    );
    return userCredential.user;
  }

  Future<User?> userGoogleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    } else {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;
      return user;
    }
  }

  Future<void> appleSignIn() async {
    AuthorizationCredentialAppleID credentials =
        await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ]);
    log(credentials.toString());
  }

  changeUserPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
