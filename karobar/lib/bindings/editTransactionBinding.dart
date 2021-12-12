import 'package:get/get.dart';
import 'package:karobar/controllers/editTransactionController.dart';

class EditTransactionBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<EditTransactionController>(EditTransactionController());
  }
}
