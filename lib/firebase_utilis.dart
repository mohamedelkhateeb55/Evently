import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/model/event.dart';
import 'package:evently_app/model/my_user.dart';

class FirebaseUtilis {
  static CollectionReference<Event> getEventCollection(String uId) {
    return getUserCollection()
        .doc(uId)
        .collection(Event.collectionName)
        .withConverter<Event>(
            fromFirestore: (snapshot, options) =>
                Event.fromFireStore(snapshot.data()!),
            toFirestore: (event, options) => event.toFireStore());
  }

  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
          fromFirestore: (snapshot, options) =>
              MyUser.fromFireStore(snapshot.data()!),
          toFirestore: (myUser, options) => myUser.toFireStore(),
        );
  }

  static Future<MyUser?> readFromFireStore(String id) async {
    var querySnapshot = await getUserCollection().doc(id).get();
    return querySnapshot.data();
  }

  static Future<void> addEventToFireStore(Event event, String uId) {
    var eventsCollections = getEventCollection(uId);
    DocumentReference<Event> docRef = eventsCollections.doc();
    event.id = docRef.id;
    return docRef.set(event);
  }

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUserCollection().doc(myUser.id).set(myUser);
  }

  static Future<void> deleteEvent(String eventId, String userId) async {
    final docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection(Event.collectionName)
        .doc(eventId);

    await docRef.delete();
  }

  static Future<void> updateEvent(Event event, String userId) async {
    final docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection(Event.collectionName)
        .doc(event.id);

    await docRef.set(event.toFireStore());
  }
}
