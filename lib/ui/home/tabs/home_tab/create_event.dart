import 'package:evently_app/firebase_utilis.dart';
import 'package:evently_app/l10n/app_localizations.dart';
import 'package:evently_app/model/event.dart';
import 'package:evently_app/providers/event_list_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/home/tabs/home_tab/event_tab_item.dart';
import 'package:evently_app/ui/home/tabs/home_tab/pick_location_screen.dart';
import 'package:evently_app/ui/home/widget/custom_elevated_button.dart';
import 'package:evently_app/ui/home/widget/custom_text_field.dart';
import 'package:evently_app/utilis/app_assets.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:evently_app/utilis/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  static const String routeName = 'create_event';
  final Event? existingEvent;

  const CreateEvent({super.key, this.existingEvent});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  int selectedIndex = 0;
  DateTime? selectedDate;
  String formateDate = '';
  TimeOfDay? selectedTime;
  String? formateTime;
  String selectedImage = '';
  String selectedEventName = '';
  String? selectedCity;
  String? selectedCountry;
  LatLng? selectedLatLng;
  TextEditingController titleConroller = TextEditingController();
  TextEditingController descriptionConroller = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String? dateErrorText;
  String? timeErrorText;
  late EventListProvider eventListProvider;
  bool isEditMode = false;

  List<String> eventsName = [];
  List<String> imageSelectedEventList = [
    AppAssets.sportBackground,
    AppAssets.birthdayBackground,
    AppAssets.meetingBackground,
    AppAssets.gamingBackground,
    AppAssets.workShopBackground,
    AppAssets.bookClubBackground,
    AppAssets.exhibitionBackground,
    AppAssets.holidayBackground,
    AppAssets.eatingBackground,
  ];
  Event? editingEvent;
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isLoaded) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    eventsName = [
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

    if (args != null && args is Event) {
      isEditMode = true;
      editingEvent = args;
      _loadExistingData(args);
    } else {
      selectedImage = imageSelectedEventList[selectedIndex];
      selectedEventName = eventsName[selectedIndex];
    }
    isLoaded = true;
  }

  void _loadExistingData(Event event) {
    titleConroller.text = event.title;
    descriptionConroller.text = event.description;
    selectedDate = event.dateTime;
    formateDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
    selectedTime = TimeOfDay.fromDateTime(event.dateTime);
    formateTime = selectedTime!.format(context);
    selectedImage = event.image;
    selectedEventName = event.eventName;
    selectedCity = event.city;
    selectedCountry = event.country;
    selectedLatLng = LatLng(event.lat!, event.lng!);
    selectedIndex = eventsName.indexOf(event.eventName);
  }

  @override
  Widget build(BuildContext context) {
    eventListProvider = Provider.of<EventListProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: height * 0.1,
        centerTitle: true,
        title: Text(
          isEditMode
              ? AppLocalizations.of(context)!.edit_event
              : AppLocalizations.of(context)!.create_event,
          style: AppStyles.medium20Primary,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(selectedImage),
              ),
              SizedBox(height: height * 0.02),
              SizedBox(
                height: height * 0.05,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: eventsName.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      selectedIndex = index;
                      selectedImage = imageSelectedEventList[selectedIndex];
                      selectedEventName = eventsName[selectedIndex];
                      setState(() {});
                    },
                    child: EventTabItem(
                      borderColor: AppColors.primaryLight,
                      selectedTextStyle: AppStyles.medium16White,
                      unselectedTextStyle:
                          Theme.of(context).textTheme.headlineSmall!,
                      eventName: eventsName[index],
                      isSelected: selectedIndex == index,
                      selectedBackgroundColor: AppColors.primaryLight,
                    ),
                  ),
                  separatorBuilder: (_, __) => SizedBox(width: width * 0.01),
                ),
              ),
              SizedBox(height: height * 0.02),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(AppLocalizations.of(context)!.title,
                        style: Theme.of(context).textTheme.labelLarge),
                    SizedBox(height: height * 0.01),
                    CustomTextField(
                      prefixIcon: Image.asset(AppAssets.iconEventTitle),
                      controller: titleConroller,
                      hintText: AppLocalizations.of(context)!.event_title,
                      validator: (text) => text == null || text.isEmpty
                          ? AppLocalizations.of(context)!
                              .please_enter_event_title
                          : null,
                    ),
                    SizedBox(height: height * 0.02),
                    Text(AppLocalizations.of(context)!.description,
                        style: Theme.of(context).textTheme.labelLarge),
                    SizedBox(height: height * 0.01),
                    CustomTextField(
                      maxLines: 6,
                      controller: descriptionConroller,
                      hintText: AppLocalizations.of(context)!.event_description,
                      validator: (text) => text == null || text.isEmpty
                          ? AppLocalizations.of(context)!
                              .please_enter_event_description
                          : null,
                    ),
                    SizedBox(height: height * 0.02),
                    buildDateTimePicker(width),
                    buildLocationPicker(width),
                    SizedBox(height: height * 0.02),
                    CustomElevatedButton(
                      onButtonClick: addOrUpdateEvent,
                      text: isEditMode
                          ? AppLocalizations.of(context)!.update_event
                          : AppLocalizations.of(context)!.add_event,
                    ),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateTimePicker(double width) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              AppAssets.iconEventDate,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            SizedBox(width: width * 0.03),
            Text(AppLocalizations.of(context)!.event_date,
                style: Theme.of(context).textTheme.labelLarge),
            Spacer(),
            TextButton(
              onPressed: chooseDate,
              child: selectedDate == null
                  ? Text(
                      AppLocalizations.of(context)!.choose_date,
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  : Text(
                      formateDate,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(
              AppAssets.iconEventTime,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            SizedBox(width: width * 0.03),
            Text(AppLocalizations.of(context)!.event_time,
                style: Theme.of(context).textTheme.labelLarge),
            Spacer(),
            TextButton(
              onPressed: chooseTime,
              child: selectedTime == null
                  ? Text(
                      AppLocalizations.of(context)!.choose_time,
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  : Text(
                      formateTime ?? '',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildLocationPicker(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.location,
            style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryLight, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Image.asset(AppAssets.iconEventLocation),
                onPressed: () async {
                  final result = await Navigator.of(context)
                      .pushNamed(PickLocationScreen.routeName);
                  if (result != null && result is Map) {
                    setState(() {
                      selectedLatLng = result['latLng'];
                      selectedCity = result['city'];
                      selectedCountry = result['country'];
                    });
                  }
                },
              ),
              SizedBox(width: width * 0.01),
              Expanded(
                child: Text(
                  selectedCity != null && selectedCountry != null
                      ? '$selectedCity, $selectedCountry'
                      : AppLocalizations.of(context)!.choose_event_location,
                  style: AppStyles.medium16Primary,
                ),
              ),
              Icon(Icons.arrow_forward_ios_outlined,
                  size: 18, color: AppColors.primaryLight),
            ],
          ),
        ),
      ],
    );
  }

  void addOrUpdateEvent() async {
    if (!isFormValid()) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final newEvent = Event(
      id: editingEvent?.id ?? '',
      image: selectedImage,
      title: titleConroller.text,
      description: descriptionConroller.text,
      eventName: selectedEventName,
      dateTime: selectedDate!,
      time: formateTime!,
      city: selectedCity ?? '',
      country: selectedCountry ?? '',
      lat: selectedLatLng?.latitude,
      lng: selectedLatLng?.longitude,
    );

    if (isEditMode) {
      await FirebaseUtilis.updateEvent(newEvent, userProvider.currentUser!.id);
    } else {
      await FirebaseUtilis.addEventToFireStore(
          newEvent, userProvider.currentUser!.id);
    }

    Provider.of<EventListProvider>(context, listen: false)
        .getAllEvents(userProvider.currentUser!.id);
    Navigator.pop(context, newEvent);
  }

  bool isFormValid() {
    dateErrorText = null;
    timeErrorText = null;

    if (formKey.currentState?.validate() != true) return false;
    if (selectedDate == null || selectedTime == null) return false;

    return true;
  }

  void chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        formateDate = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void chooseTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        formateTime = picked.format(context);
      });
    }
  }
}
