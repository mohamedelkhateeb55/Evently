import 'package:evently_app/model/event.dart';
import 'package:evently_app/utilis/app_assets.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailsHeader extends StatelessWidget {
  final Event event;

  const EventDetailsHeader({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(event.image, fit: BoxFit.cover),
        ),
        const SizedBox(height: 12),
        Text(
          event.title,
          style: AppStyles.medium20Primary,
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsetsGeometry.symmetric(
              horizontal: width * 0.02, vertical: height * 0.01),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryLight)),
          child: Row(
            children: [
              Image.asset(AppAssets.DateAndTime),
              SizedBox(
                width: width * 0.03,
              ),
              Column(
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy').format(event.dateTime),
                    style: AppStyles.medium16Primary,
                  ),
                  Text(
                    event.time,
                    style: AppStyles.medium16Black,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
        Container(
          padding: EdgeInsetsGeometry.symmetric(
              horizontal: width * 0.02, vertical: height * 0.01),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryLight)),
          child: Row(
            children: [
              Image.asset(AppAssets.LocationDetails),
              const SizedBox(width: 8),
              Text(
                event.city ?? '',
                style: AppStyles.medium16Primary,
              ),
              const SizedBox(width: 4),
              Text(', '),
              Text(
                event.country ?? '',
                style: AppStyles.medium16Primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
