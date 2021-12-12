import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:karobar/config/pallete.dart';
import 'package:karobar/controllers/transactionController.dart';
import 'package:karobar/models/transaction.dart';
import 'package:karobar/utilities/utils.dart';
import 'package:karobar/widgets/transactionCardTile.dart';

class TransactionSlideListTile extends StatelessWidget {
  const TransactionSlideListTile({Key? key, required this.dbTransaction})
      : super(key: key);
  final DbTransaction dbTransaction;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<DbTransactionController>(builder: (controller) {
        return Slidable(
          key: key,
          actionPane: SlidableStrechActionPane(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: IconSlideAction(
                caption: 'To Pay',
                color: Pallete.danger,
                icon: FontAwesomeIcons.moneyBill,
                onTap: () {
                  var toPayAmount = TextEditingController();
                  Utils.amountDialog(
                    tcontroller: toPayAmount,
                    onPressed: () {
                      controller.receive(
                          dbTransaction, double.parse(toPayAmount.text));
                      Get.back();
                    },
                    title: "To Pay",
                    labelText: "Enter Amount to Pay",
                    btnName: "Ok",
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: IconSlideAction(
                caption: 'To Receive',
                color: Pallete.success,
                icon: FontAwesomeIcons.moneyCheck,
                onTap: () {
                  var toReceiveAmount = TextEditingController();
                  Utils.amountDialog(
                    tcontroller: toReceiveAmount,
                    onPressed: () {
                      controller.pay(
                          dbTransaction, double.parse(toReceiveAmount.text));
                      Get.back();
                    },
                    title: "To Receive",
                    labelText: "Enter Amount to Receive",
                    btnName: "Ok",
                  );
                },
              ),
            ),
          ],
          secondaryActions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: IconSlideAction(
                caption: 'Edit',
                color: Pallete.info,
                icon: Icons.edit,
                onTap: () {
                  Get.toNamed("/editTransaction/${dbTransaction.id}");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ),
              child: IconSlideAction(
                caption: 'Delete',
                color: Pallete.danger,
                icon: Icons.delete,
                onTap: () {
                  controller.deleteDbTransaction(dbTransaction.id!);
                },
              ),
            ),
          ],
          child: TransactionCardTile(
            dbTransaction: dbTransaction,
          ),
        );
      }),
    );
  }
}