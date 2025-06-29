import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  Color? borderColor;
  String? hintText;
  TextStyle? hintStyle;
  Widget? prefixIcon;
  Widget? suffixIcon;
  String? labelText;
  TextStyle? labelStyle;
  int? maxLines;
  TextEditingController? controller;
  String? Function(String?)? validator;
  TextInputType keyboardInputType;
  bool? obscureText;

  CustomTextField(
      {this.borderColor,
      this.controller,
      this.hintText,
      this.hintStyle,
      this.prefixIcon,
      this.labelText,
      this.labelStyle,
      this.suffixIcon,
      this.maxLines,
      this.validator,
      this.keyboardInputType = TextInputType.text,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return TextFormField(
      cursorColor: AppColors.primaryLight,
      maxLines: maxLines ?? 1,
      controller: controller,
      keyboardType: keyboardInputType,
      validator: validator,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: borderColor ?? AppColors.grayColor, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: borderColor ?? AppColors.grayColor, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.redColor, width: 1)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.redColor, width: 1)),
          hintText: hintText,
          hintStyle: hintStyle ?? AppStyles.medium16Gray,
          prefixIcon: prefixIcon,
          labelText: labelText,
          labelStyle: labelStyle ?? AppStyles.medium16Gray,
          suffixIcon: suffixIcon),
    );
  }
}
