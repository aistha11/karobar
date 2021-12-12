import 'package:get/get.dart';
import 'package:karobar/controllers/firebaseAuthController.dart';
import 'package:karobar/models/dbUser.dart';
import 'package:karobar/services/firebaseService.dart';
import 'package:karobar/utilities/utils.dart';

class UserController extends GetxController {
  Rx<DbUser> dbUser = Rx<DbUser>(
    DbUser(
      name: "IT e-Service",
      username: "074bcsit012.bijay",
      profilePhoto: "",
      email: "074bcsit012.bijay@scst.edu.np",
    ),
  );

  getDbUser(String username)async{
    dbUser.value = await FirebaseService.getDbUserById(username);
    print("DbUser: ${dbUser.value.name}");
    update();
  }

  @override
  void onInit() {
    String username = Utils.getUsername(Get.find<FirebaseAuthController>().user!.email!);
    getDbUser(username);
    super.onInit();
  }
}