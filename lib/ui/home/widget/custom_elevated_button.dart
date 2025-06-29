import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  Function onButtonClick;
  String? text;
  Color? backgroundColor;
  TextStyle? textStyle;
  Widget? widget;

  CustomElevatedButton(
      {required this.onButtonClick,
      this.text,
      this.backgroundColor,
      this.textStyle,
      this.widget});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primaryLight,
            padding: EdgeInsets.symmetric(vertical: height * 0.015),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.primaryLight),
              borderRadius: BorderRadius.circular(16),
            )),
        onPressed: () {
          onButtonClick();
        },
        child: widget ??
            Text(
              text ?? "",
              style: textStyle ?? AppStyles.medium20White,
            ));
  }
}
