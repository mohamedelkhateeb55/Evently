import 'package:evently_app/l10n/app_localizations.dart';
import 'package:evently_app/model/event.dart';
import 'package:evently_app/providers/event_list_provider.dart';
import 'package:evently_app/providers/language_provider.dart';
import 'package:evently_app/providers/theme_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/home/tabs/home_tab/event_items.dart';
import 'package:evently_app/ui/home/tabs/home_tab/event_tab_item.dart';
import 'package:evently_app/utilis/app_assets.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedIndex = 0;
  List<Event> eventList = [];

  @override
  Widget build(BuildContext context) {
    var eventListProvider = Provider.of<EventListProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    var languageProvider = Provider.of<LanguageProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var isEnglish = languageProvider.currentLocal == 'en';
    eventListProvider.getEventName(context);
    if (eventListProvider.eventList.isEmpty) {
      eventListProvider.getAllEvents(userProvider.currentUser!.id);
    }
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.welcome_back,
                    style: AppStyles.regular14White,
                  ),
                  Text(
                    userProvider.currentUser!.name,
                    style: AppStyles.bold24White,
                  )
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  if (themeProvider.currentTheme == ThemeMode.light) {
                    themeProvider.changeTheme(ThemeMode.dark);
                  } else {
                    themeProvider.changeTheme(ThemeMode.light);
                  }
                },
                child: Image.asset(AppAssets.iconSun),
              ),
              SizedBox(
                width: width * 0.015,
              ),
              InkWell(
                onTap: () {
                  languageProvider.changeLanguage(isEnglish ? 'ar' : 'en');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: width * 0.01, horizontal: height * 0.005),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.whiteColor),
                  child: Text(
                    isEnglish ? 'En' : 'Ar',
                    style: AppStyles.bold20Black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
              height: height * 0.13,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Theme.of(context).primaryColor),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    children: [
                      Image.asset(AppAssets.iconMap),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text(
                        "Cairo, Egypt",
                        style: AppStyles.medium14White,
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  DefaultTabController(
                      length: eventListProvider.eventsName.length,
                      child: TabBar(
                          onTap: (index) {
                            eventListProvider.changeSelectedIndex(
                                index, userProvider.currentUser!.id);
                          },
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          indicatorColor: AppColors.transparentColor,
                          dividerColor: AppColors.transparentColor,
                          labelPadding: EdgeInsets.zero,
                          tabs: eventListProvider.eventsName.map((eventName) {
                            return EventTabItem(
                                selectedTextStyle:
                                    Theme.of(context).textTheme.headlineSmall!,
                                unselectedTextStyle: AppStyles.medium16White,
                                selectedBackgroundColor:
                                    Theme.of(context).focusColor,
                                eventName: eventName,
                                isSelected: eventListProvider.selectedIndex ==
                                    eventListProvider.eventsName
                                        .indexOf(eventName));
                          }).toList()))
                ],
              )),
          Expanded(
            child: eventListProvider.filterList.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.no_events_founded,
                      style: AppStyles.medium16Black,
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025,
                            vertical: height * 0.015),
                        child: EventItems(
                          event: eventListProvider.filterList[index],
                        ),
                      );
                    },
                    itemCount: eventListProvider.filterList.length),
          )
        ],
      ),
    );
  }
}
