import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/l10n/app_localizations.dart';
import 'package:evently_app/model/event.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/toast_utils.dart';
import 'package:flutter/material.dart';

import '../firebase_utilis.dart';

class EventListProvider extends ChangeNotifier {
  List<Event> eventList = [];
  List<Event> filterList = [];
  List<String> eventsName = [];
  int selectedIndex = 0;
  List<Event> favouriteEventList = [];

  List<String> getEventName(BuildContext context) {
    return eventsName = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.sport,
      AppLocalizations.of(context)!.birthday,
      AppLocalizations.of(context)!.meeting,
      AppLocalizations.of(context)!.gaming,
      AppLocalizations.of(context)!.workshop,
      AppLocalizations.of(context)!.book_club,
      AppLocalizations.of(context)!.exhibition,
      AppLocalizations.of(context)!.holiday,
      AppLocalizations.of(context)!.eating,
    ];
  }

  void getAllEvents(String uId) async {
    QuerySnapshot<Event> querySnapshot =
        await FirebaseUtilis.getEventCollection(uId).get();
    eventList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    filterList = eventList;

    filterList.sort((Event event1, Event event2) {
      return event1.dateTime.compareTo(event2.dateTime);
    });
    notifyListeners();
  }

  void getFilterEvents() {
    filterList = eventList.where((event) {
      return event.eventName == eventsName[selectedIndex];
    }).toList();
    notifyListeners();
  }

  void getFilterEventFromFireStore(String uId) async {
    var querySnapshot = await FirebaseUtilis.getEventCollection(uId)
        .where('eventName', isEqualTo: eventsName[selectedIndex])
        .orderBy('dateTime')
        .get();
    filterList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
  }

  void updateIsFavouriteEvents(Event event, String uId) async {
    FirebaseUtilis.getEventCollection(uId)
        .doc(event.id)
        .update({'isFavourite': !event.isFavourite}).timeout(
      Duration(milliseconds: 500),
      onTimeout: () {
        selectedIndex == 0 ? getAllEvents(uId) : getFilterEvents();
        ToastUtils.toastMSG(
            backgroundColor: AppColors.primaryLight,
            textColor: AppColors.whiteColor,
            msg: "Added to Favourite");
        selectedIndex == 0
            ? getAllEvents(uId)
            : getFilterEventFromFireStore(uId);
        getAllFavouriteEvent(uId);
      },
    );
    notifyListeners();
  }

  void getAllFavouriteEvent(String uId) async {
    var querySnapshot = await FirebaseUtilis.getEventCollection(uId)
        .where('isFavourite', isEqualTo: true)
        .orderBy('dateTime')
        .get();
    favouriteEventList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    notifyListeners();
  }

  void changeSelectedIndex(int newSelectedIndex, String uId) {
    selectedIndex = newSelectedIndex;
    selectedIndex == 0 ? getAllEvents(uId) : getFilterEvents();
  }
}
