import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karobar/config/pallete.dart';
import 'package:karobar/controllers/firebaseAuthController.dart';
import 'package:karobar/models/transaction.dart';
import 'package:karobar/services/firebaseService.dart';
import 'package:karobar/utilities/utils.dart';

class EditTransactionController extends GetxController {
  var transactionId = "".obs;
  var username = "".obs;

  var name = TextEditingController().obs;
  var description = TextEditingController().obs;
  var amount = TextEditingController().obs;

  var dbTransactionFormKey = GlobalKey<FormState>().obs;
  var submitting = false.obs;

  @override
  void onInit() async {
    username.value =
        Utils.getUsername(Get.find<FirebaseAuthController>().user!.email!);
    transactionId.value = Get.parameters['id']!;
    final DbTransaction? dbTransaction =
        await FirebaseService.getDbTransactionById(
            username.value, transactionId.value);
    name.value.text = dbTransaction!.name;
    description.value.text = dbTransaction.description;
    amount.value.text = dbTransaction.amount.toString();
    super.onInit();
  }

  Future<void> editDbTransaction() async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      Get.snackbar("Check Your Internet Connection!", "Try again later");
    } else {
      if (dbTransactionFormKey.value.currentState!.validate()) {
        submitting.value = true;

        DbTransaction dbTransaction = DbTransaction(
          id: transactionId.value,
          name: name.value.text,
          userId: username.value,
          amount: double.parse(amount.value.text),
          description: description.value.text,
          updateDate: Timestamp.now(),
        );

        FirebaseService.updateDbTransaction(username.value, dbTransaction).then(
          (value) {
            Get.snackbar(
              "Successfull!!",
              "Your Transaction is Updated",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Pallete.info,
            );
          },
        );
        onClear();
      }
    }
    submitting.value = false;
    Get.back();
    update();
  }

  void onClear() {
    name.value.text = "";
    description.value.text = "";
    amount.value.text = "";
  }

  @override
  void dispose() {
    name.value.dispose();
    description.value.dispose();
    amount.value.dispose();
    super.dispose();
  }
}
