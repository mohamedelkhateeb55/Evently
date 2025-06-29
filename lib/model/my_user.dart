class MyUser {
  static const String collectionName = 'Users';
  String id;
  String name;
  String email;

  MyUser({required this.id, required this.name, required this.email});

  MyUser.fromFireStore(Map<String, dynamic> date)
      : this(id: date['id'], name: date['name'], email: date['email']);

  Map<String, dynamic> toFireStore() {
    return {'id': id, 'name': name, 'email': email};
  }
}
