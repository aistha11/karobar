import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karobar/config/pallete.dart';
import 'package:karobar/controllers/firebaseAuthController.dart';
import 'package:karobar/models/transaction.dart';
import 'package:karobar/services/firebaseService.dart';
import 'package:karobar/utilities/utils.dart';

class DbTransactionController extends GetxController {
  var username = "".obs;

  final Rx<List<DbTransaction>> _dbTransactionList =
      Rx<List<DbTransaction>>([]);

  List<DbTransaction> get dbTransactionList => _dbTransactionList.value;

  var name = TextEditingController().obs;
  var description = TextEditingController().obs;
  // var amount = TextEditingController().obs;

  var dbTransactionFormKey = GlobalKey<FormState>().obs;
  var submitting = false.obs;

  @override
  void onInit() {
    username.value =
        Utils.getUsername(Get.find<FirebaseAuthController>().user!.email!);
    _dbTransactionList
        .bindStream(FirebaseService.getAllDbTransaction(username.value));
    super.onInit();
  }

  Future<void> addDbTransactionToDb() async {
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      Get.snackbar("Check Your Internet Connection!", "Try again later");
    } else {
      if (dbTransactionFormKey.value.currentState!.validate()) {
        submitting.value = true;

        DbTransaction dbTransaction = DbTransaction(
          name: name.value.text,
          userId: username.value,
          // amount: double.parse(amount.value.text),
          amount: 0.0,
          description: description.value.text,
          updateDate: Timestamp.now(),
        );

        FirebaseService.createDbTransaction(username.value, dbTransaction).then(
          (value) {
            Get.snackbar(
              "Successfull!!",
              "Your Transaction is Created",
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

  deleteDbTransaction(String id) {
    FirebaseService.deleteDbTransaction(username.value, id);
    update();
  }

  ///
  /**
   *  Future<void> toPay(DbTransaction dbTransaction, double toPayAmount) async { 
        DbTransaction upDbTransaction = DbTransaction(
          id: dbTransaction.id,
          name: dbTransaction.name,
          userId: dbTransaction.userId,
          description: dbTransaction.description,
          amount: dbTransaction.amount - toPayAmount,
          updateDate: Timestamp.now(),
        );
    await FirebaseService.updateDbTransaction(username.value, upDbTransaction);
  }
   */

  Future<void> receive(
      DbTransaction dbTransaction, double receiveAmount) async {
    DbTransaction upDbTransaction = DbTransaction(
      id: dbTransaction.id,
      name: dbTransaction.name,
      userId: dbTransaction.userId,
      description: dbTransaction.description,
      amount: dbTransaction.amount - receiveAmount,
      updateDate: Timestamp.now(),
    );
    await FirebaseService.updateDbTransaction(username.value, upDbTransaction);
  }

  ///
  /**
   * Future<void> toReceive( DbTransaction dbTransaction, double toReceiveAmount) async {
      DbTransaction upDbTransaction = DbTransaction(
        id: dbTransaction.id,
        name: dbTransaction.name,
        userId: dbTransaction.userId,
        description: dbTransaction.description,
        amount: dbTransaction.amount + toReceiveAmount,
        updateDate: Timestamp.now(),
      );
    await FirebaseService.updateDbTransaction(username.value, upDbTransaction);
  }
   */
  Future<void> pay(DbTransaction dbTransaction, double payAmount) async {
    DbTransaction upDbTransaction = DbTransaction(
      id: dbTransaction.id,
      name: dbTransaction.name,
      userId: dbTransaction.userId,
      description: dbTransaction.description,
      amount: dbTransaction.amount + payAmount,
      updateDate: Timestamp.now(),
    );
    await FirebaseService.updateDbTransaction(username.value, upDbTransaction);
  }

  void onClear() {
    name.value.text = "";
    description.value.text = "";
    // amount.value.text = "";
  }
}
