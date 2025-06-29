import 'package:evently_app/firebase_utilis.dart';
import 'package:evently_app/model/event.dart';
import 'package:evently_app/providers/event_list_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/home/tabs/home_tab/create_event.dart';
import 'package:evently_app/ui/home/tabs/home_tab/event_details/event_description.dart';
import 'package:evently_app/ui/home/tabs/home_tab/event_details/event_details_header.dart';
import 'package:evently_app/ui/home/tabs/home_tab/event_details/event_details_location_map.dart';
import 'package:evently_app/utilis/app_assets.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class EventDetailsScreen extends StatefulWidget {
  static const String routeName = 'event_details';
  final Event event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Event event;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text("Event Details",
            style: TextStyle(
              color: AppColors.primaryLight,
            )),
        actions: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final updatedEvent = await Navigator.pushNamed(
                        context,
                        CreateEvent.routeName,
                        arguments: event,
                      );

                      if (updatedEvent != null && updatedEvent is Event) {
                        setState(() {
                          event = updatedEvent;
                        });
                      }
                    },
                    child: Image.asset(AppAssets.edit),
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  InkWell(
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Event'),
                            content: Text(
                                'Are you sure you want to delete this event?'),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text('Cancel')),
                              TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete')),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          await FirebaseUtilis.deleteEvent(
                              widget.event.id, userProvider.currentUser!.id);
                          Provider.of<EventListProvider>(context, listen: false)
                              .getAllEvents(userProvider.currentUser!.id);
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset(AppAssets.recycle)),
                ],
              ))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventDetailsHeader(event: event),
            SizedBox(height: height * 0.03),
            EventDetailsLocationMap(latLng: LatLng(event.lat!, event.lng!)),
            SizedBox(height: height * 0.03),
            EventDescription(description: event.description),
          ],
        ),
      ),
    );
  }
}
