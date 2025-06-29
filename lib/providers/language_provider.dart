import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String currentLocal = 'en';

  void changeLanguage(String newLocal) {
    if (currentLocal == newLocal) {
      return;
    }
    currentLocal = newLocal;
    notifyListeners();
  }
}
