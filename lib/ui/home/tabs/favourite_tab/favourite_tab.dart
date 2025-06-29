import 'package:evently_app/l10n/app_localizations.dart';
import 'package:evently_app/providers/event_list_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/home/widget/custom_text_field.dart';
import 'package:evently_app/utilis/app_assets.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_tab/event_items.dart';

class FavouriteTab extends StatelessWidget {
  const FavouriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var eventListProvider = Provider.of<EventListProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    if (eventListProvider.favouriteEventList.isEmpty) {
      eventListProvider.getAllFavouriteEvent(userProvider.currentUser!.id);
    }
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.08,
            ),
            CustomTextField(
              borderColor: AppColors.primaryLight,
              hintText: AppLocalizations.of(context)!.search_event,
              hintStyle: AppStyles.bold16Primary,
              prefixIcon: Image.asset(AppAssets.iconSearch),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Expanded(
              child: eventListProvider.favouriteEventList.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .no_favourite_events_founded,
                        style: AppStyles.medium16Black,
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.012),
                            child: EventItems(
                                event:
                                    eventListProvider.favouriteEventList[index])
                            // EventItems(),
                            );
                      },
                      itemCount: eventListProvider.favouriteEventList.length),
            )
          ],
        ),
      ),
    );
  }
}
