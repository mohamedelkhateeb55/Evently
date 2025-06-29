import 'package:evently_app/model/event.dart';
import 'package:evently_app/providers/event_list_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/home/tabs/home_tab/event_details/event_details.dart';
import 'package:evently_app/utilis/app_assets.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventItems extends StatelessWidget {
  Event event;

  EventItems({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    var eventListProvider = Provider.of<EventListProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, EventDetailsScreen.routeName,
            arguments: event);
      },
      child: Container(
        height: height * 0.25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryLight),
            image: DecorationImage(
                image: AssetImage(event.image), fit: BoxFit.fill)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.whiteColor),
                child: Column(
                  children: [
                    Text(
                      event.dateTime.day.toString(),
                      style: AppStyles.bold20Primary,
                    ),
                    Text(
                      DateFormat("MMM").format(event.dateTime),
                      style: AppStyles.bold16Primary,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.whiteColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(event.title, style: AppStyles.bold14black)),
                    IconButton(
                        onPressed: () {
                          eventListProvider.updateIsFavouriteEvents(
                              event, userProvider.currentUser!.id);
                        },
                        icon: event.isFavourite == true
                            ? Image.asset(AppAssets.selectedFav)
                            : Image.asset(AppAssets.unselectedFav))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
