import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karobar/config/pallete.dart';
import 'package:karobar/controllers/transactionController.dart';

class AddTransactionView extends StatelessWidget {
  const AddTransactionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Add Transaction'),
      ),
      body: Stack(
        children: [
          Container(
            height: Get.height * 0.15,
            width: Get.width,
            decoration: BoxDecoration(
              color: Pallete.primaryCol,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
          ),
          AddTransactionForm(),
        ],
      ),
    );
  }
}

class AddTransactionForm extends StatelessWidget {
  const AddTransactionForm({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 70, left: 25, right: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Pallete.secondaryCol,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        "Add new transaction",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GetBuilder<DbTransactionController>(builder: (controller) {
                        return Form(
                          key: controller.dbTransactionFormKey.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty)
                                    return "*Name can't be empty.";
                                  return null;
                                },
                                controller: controller.name.value,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                  labelText: "Name",
                                ),
                                onFieldSubmitted: (val) {
                                  controller.name.value.text = val;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                maxLines: 3,
                                validator: (val) {
                                  if (val!.isEmpty)
                                    return "*Description can't be empty.";
                                  return null;
                                },
                                controller: controller.description.value,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                  labelText: "Short Description",
                                ),
                                onFieldSubmitted: (val) {
                                  controller.description.value.text = val;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              // Text(
                              //   "Enter Amount",
                              //   style: TextStyle(
                              //       fontSize: 15, fontWeight: FontWeight.w600),
                              // ),
                              // SizedBox(
                              //   height: 10.0,
                              // ),
                              // TextFormField(
                              //   validator: (val) {
                              //     if (val!.isEmpty)
                              //       return "*Amount can't be empty.";
                              //     return null;
                              //   },
                              //   controller: controller.amount.value,
                              //   textInputAction: TextInputAction.next,
                              //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                              //   decoration: InputDecoration(
                              //       border: OutlineInputBorder(
                              //         borderSide: BorderSide(),
                              //       ),
                              //       labelText: "Amount"),
                              //   onFieldSubmitted: (val) {
                              //     controller.amount.value.text = val;
                              //   },
                              // ),
                              // SizedBox(
                              //   height: 10.0,
                              // ),
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: !controller.submitting.value
                                      ? controller.addDbTransactionToDb
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                      primary: Pallete.primaryCol,
                                      onPrimary: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                                  child: Text("Submit"),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}