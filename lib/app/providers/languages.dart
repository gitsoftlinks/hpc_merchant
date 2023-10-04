import 'package:flutter/material.dart';
import 'package:happiness_club_merchant/app/models/language.dart';


class LanguageProvider with ChangeNotifier {
  /// loading languages data from json
  /// setting up listeners

  // setter and getter for languages
  List<Language> _languages = [];
  List<Language> get languages => _languages;

  // setter and getter for selected language
  Language _selectedLanguage = Language.US;
  Language get selectedLanguage => _selectedLanguage;
  set selectedLanguage(Language value) {
    _selectedLanguage = value;
    notifyListeners();
  }

  // setter and getter for search results
  List<Language> _searchResults = [];
  List<Language> get searchResults => _searchResults;
  set searchResults(List<Language> value) {
    _searchResults = value;
    notifyListeners();
  }

  Future loadLanguagesFromJSON(Locale locale) async {
    try {
      if (languages.isEmpty) {
        _languages = Language.ALL;
      }

      var languageList =  _languages.where((element) => element.languageCode == locale.toString().replaceFirst('_', '-')).toList();
      selectedLanguage = languageList.isEmpty ? Language.US : languageList.first;
      searchResults = _languages;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }
}
