import 'package:flutter/material.dart';
import 'package:karobar/config/pallete.dart';

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.name})
      : super(key: key);
  final void Function()? onPressed;
  final IconData? icon;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        // style: ButtonStyle(
        //   padding: MaterialStateProperty.all(
        //       EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0)),
        //   backgroundColor: MaterialStateProperty.all(Colors.yellow),
        //   elevation: MaterialStateProperty.all(0.0),
        //   shape: MaterialStateProperty.all(
        //     RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(
        //         Radius.circular(30.0),
        //       ),
        //     ),
        //   ),
        // ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0),
          primary: Pallete.primaryCol,
          onPrimary: Pallete.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))
          )
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "$name".toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Pallete.dark,
              ),
            ),
            const SizedBox(width: 20.0),
            Icon(
              icon,
              size: 18.0,
              color: Pallete.dark,
            )
          ],
        ),
      ),
    );
  }
}
