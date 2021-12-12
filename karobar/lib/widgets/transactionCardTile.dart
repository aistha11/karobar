import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karobar/config/constant.dart';
import 'package:karobar/config/pallete.dart';
import 'package:karobar/models/transaction.dart';
import 'package:karobar/utilities/utils.dart';

class TransactionCardTile extends StatelessWidget {
  TransactionCardTile({Key? key, required this.dbTransaction})
      : super(key: key);
  final DbTransaction dbTransaction;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        height: 155,
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
              height: 155,
              color:
                  dbTransaction.amount.isNegative ? Pallete.danger:  Pallete.success,
              child: RotatedBox(
                quarterTurns: 3,
                child: Center(
                  child: Text(
                    "${Utils.getDate(dbTransaction.updateDate.toDate())}",
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "${dbTransaction.name}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 50,
                              child: IconButton(
                                onPressed: () async {
                                  Get.toNamed(
                                      "/editTransaction/${dbTransaction.id}");
                                },
                                color: Pallete.link,
                                icon: Icon(Icons.edit),
                                iconSize: 20,
                              ),
                            ),
                            Container(
                              width: 50,
                              child: IconButton(
                                onPressed: () async {
                                  dbTransactionController.deleteDbTransaction(dbTransaction.id!);
                                },
                                color: Pallete.danger,
                                icon: Icon(Icons.delete),
                                iconSize: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "${dbTransaction.description}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Amount: "),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${dbTransaction.amount.abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: dbTransaction.amount.isNegative
                                    ? Pallete.danger
                                    : Pallete.success,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    primary: Pallete.light,
                                    backgroundColor: Pallete.dangerAccent,
                                    side: BorderSide(
                                      width: 2,
                                      color: Pallete.danger,
                                    ),
                                  ),
                                  child: Text("PAID"),
                                  onPressed: () {
                                    var payAmount = TextEditingController();
                                    Utils.amountDialog(
                                      tcontroller: payAmount,
                                      onPressed: (){
                                         dbTransactionController.pay(
                                                  dbTransaction,
                                                  double.parse(
                                                      payAmount.text));
                                          Get.back();
                                      },
                                      title: "Paid",
                                      labelText: "Enter Paid Amount",
                                      btnName: "Paid",
                                    );
                                   
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Pallete.secondaryCol,
                                    side: BorderSide(
                                      width: 2,
                                      color: Pallete.success,
                                    ),
                                  ),
                                  child: Text("RECEIVED"),
                                  onPressed: () {
                                    var receiveAmount = TextEditingController();
                                    Utils.amountDialog(
                                      tcontroller: receiveAmount,
                                      onPressed: (){
                                         dbTransactionController.receive(
                                                  dbTransaction,
                                                  double.parse(
                                                      receiveAmount.text));
                                          Get.back();
                                      },
                                      title: "Received",
                                      labelText: "Enter Received Amount",
                                      btnName: "Received",
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}