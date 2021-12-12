import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karobar/controllers/firebaseAuthController.dart';

import 'authController.dart';
import 'signInView.dart';
import 'signUpView.dart';

class AuthView extends GetView<FirebaseAuthController> {
  final AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => authController.isSignIn.value
          ? SignInView(
              handleSignIn: (email, password) async {
                await controller.signIn(email, password);
              },
            )
          : SignUpView(
              handleSignUp: (name, email, password) async {
                await controller.signUp(name, email, password);
              },
            ),
    );
  }
}