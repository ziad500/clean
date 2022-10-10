// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean/presentation/resources/language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefKeyLanguage = "prefKeyLanguage";

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(
    this._sharedPreferences,
  );

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(prefKeyLanguage);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.ENGLISH.getValue();
    }
  }
}
