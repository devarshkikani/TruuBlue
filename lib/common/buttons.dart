import 'package:dating/common/colors.dart';
import 'package:dating/theme/textstyle.dart';
import 'package:flutter/material.dart';

Widget nextButton({
  String? title,
  required bool isActive,
  required Function() onTap,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      textStyle: regualrText16.copyWith(color: Colors.white),
      padding: EdgeInsets.symmetric(
        horizontal: 50,
        vertical: 15,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
    child: Text(title ?? 'Next'),
  );
}
