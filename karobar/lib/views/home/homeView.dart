import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:karobar/controllers/firebaseAuthController.dart';
import 'package:karobar/controllers/transactionController.dart';
import 'package:karobar/controllers/userController.dart';
import 'package:karobar/models/transaction.dart';
import 'package:karobar/widgets/drawerProfile.dart';
import 'package:karobar/widgets/transactionSlideListTile.dart';

class HomeView extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final DbTransactionController dbTransactionController =
      Get.put(DbTransactionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Karobar"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: DrawerProfile(),
            ),
            ListTile(
                title: Text("Sign Out"),
                leading: Icon(Icons.logout),
                onTap: () {
                  Get.find<FirebaseAuthController>().signOut();
                })
          ],
        ),
      ),
      body: GetX<DbTransactionController>(builder: (controller) {
        if (controller.dbTransactionList.length == 0) {
          return Center(
            child: Text("No Transactions"),
          );
        }
        return SafeArea(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 15),
            itemCount: controller.dbTransactionList.length,
            separatorBuilder: (_,i){
              return SizedBox(height: 15,);
            },
            itemBuilder: (_, i) {
              DbTransaction dbTransaction = controller.dbTransactionList[i];
              return TransactionSlideListTile(
                dbTransaction: dbTransaction,
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/addTransaction");
        },
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
  }
}


