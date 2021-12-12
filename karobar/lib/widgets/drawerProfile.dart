import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karobar/config/pallete.dart';
import 'package:karobar/controllers/firebaseAuthController.dart';
import 'package:karobar/controllers/userController.dart';
import 'package:karobar/models/dbUser.dart';
import 'package:karobar/utilities/utils.dart';

class DrawerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String email = Get.find<FirebaseAuthController>().user!.email!;
    return Container(
      child: GetX<UserController>(builder: (controller){
        DbUser user = controller.dbUser.value;
        return Column(
        children: [
          user.profilePhoto != ""
              ? CircleAvatar(
                  radius: 40,
                  foregroundImage:
                      CachedNetworkImageProvider(user.profilePhoto),
                )
              : Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Pallete.primaryCol,
                  ),
                  child: Center(
                    child: Text(
                      Utils.getInitials(user.name),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // color: UniversalVariables.lightBlueColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 150.0,
                child: Text(
                  "${user.name}",
                  maxLines: 2,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 3.0,
              ),
              Text(
                "$email",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      );
      }),
    );
  }
}