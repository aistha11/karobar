import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karobar/bindings/editTransactionBinding.dart';
import 'package:karobar/views/home/addTransactionView.dart';
import 'package:karobar/views/home/editTransactionView.dart';
import 'package:karobar/views/wrapper.dart';

import 'bindings/initialBinding.dart';
import 'config/pallete.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Karobar",
      initialBinding: InitialBinding(),
      theme: ThemeData(
        primaryColor: Pallete.primaryCol,
        backgroundColor: Pallete.backgroundColor,
        appBarTheme: AppBarTheme(
          color: Pallete.primaryCol
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Pallete.secondaryCol,
        ),
      ),
      initialRoute: "/",
      getPages: [
        GetPage(
          name: "/",
          page: () => Wrapper(),
        ),
        GetPage(name: "/addTransaction", page: () => AddTransactionView()),
        GetPage(
          name: "/editTransaction/:id",
          page: () => EditTransactionView(),
          binding: EditTransactionBinding(),
        ),
      ],
    );
  }
}
