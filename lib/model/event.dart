import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  static String collectionName = 'Events';

  String id;
  String image;
  String title;
  String description;
  String eventName;
  DateTime dateTime;
  String time;
  bool isFavourite;
  double? lat;
  double? lng;
  String? city;
  String? country;

  Event({
    this.id = '',
    required this.image,
    required this.title,
    required this.description,
    required this.eventName,
    required this.dateTime,
    required this.time,
    this.isFavourite = false,
    this.lat,
    this.lng,
    this.city,
    this.country,
  });

  Event.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data['id'],
          image: data['image'],
          title: data['title'],
          description: data['description'],
          eventName: data['eventName'],
          dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
          time: data['time'],
          isFavourite: data['isFavourite'] ?? false,
          lat: data['lat'],
          lng: data['lng'],
          city: data['city'],
          country: data['country'],
        );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'description': description,
      'eventName': eventName,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'time': time,
      'isFavourite': isFavourite,
      'lat': lat,
      'lng': lng,
      'city': city,
      'country': country,
    };
  }

  LatLng? get location =>
      (lat != null && lng != null) ? LatLng(lat!, lng!) : null;
}
