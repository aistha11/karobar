import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karobar/config/userState.dart';
import 'package:karobar/controllers/firebaseAuthController.dart';

import 'auth/authView.dart';
import 'home/homeView.dart';

class Wrapper extends GetView<FirebaseAuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.status == Status.AUTHENTICATED) {
        return HomeView();
      } else {
        return AuthView();
      }
    });
  }
}