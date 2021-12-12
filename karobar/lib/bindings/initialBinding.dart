import 'package:get/get.dart';
import 'package:karobar/controllers/firebaseAuthController.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FirebaseAuthController>(FirebaseAuthController());
  }
}