import 'package:evently_app/utilis/app_colors.dart';
import 'package:flutter/material.dart';

class EventTabItem extends StatelessWidget {
  String eventName;
  bool isSelected;
  Color selectedBackgroundColor;
  TextStyle selectedTextStyle;
  TextStyle unselectedTextStyle;
  Color? borderColor;

  EventTabItem(
      {required this.eventName,
      required this.isSelected,
      required this.selectedBackgroundColor,
      required this.selectedTextStyle,
      required this.unselectedTextStyle,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.01),
      margin: EdgeInsets.symmetric(horizontal: width * 0.01),
      decoration: BoxDecoration(
        color:
            isSelected ? selectedBackgroundColor : AppColors.transparentColor,
        borderRadius: BorderRadius.circular(46),
        border:
            Border.all(color: borderColor ?? AppColors.whiteColor, width: 1),
      ),
      child: Text(eventName,
          style: isSelected ? selectedTextStyle : unselectedTextStyle),
    );
  }
}
