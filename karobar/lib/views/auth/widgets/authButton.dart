import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  AuthButton({
    Key? key,
    required this.onPressed,
    required this.name,
    required this.color,
    required this.icon,
  }) : super(key: key);
  final void Function()? onPressed;
  final String name;
  final Color color;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      icon: Icon(
        icon,
        size: 18.0,
        color: color,
      ),
      label: Text(
        name,
        style: TextStyle(color: color),
      ),
      onPressed: onPressed,
    );
  }
}
