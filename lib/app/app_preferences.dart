// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean/presentation/resources/language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefKeyLanguage = "prefKeyLanguagee";
const String prefKeyOnBoardingScreenViewd = "OnBoardingScreenViewd";
const String prefKeyIsUserLooggedInSuccessfully = "IsUserLooggedInSuccessfully";

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(
    this._sharedPreferences,
  );

  Future clear() async {
    _sharedPreferences.setBool(prefKeyIsUserLooggedInSuccessfully, false);
  }

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(prefKeyLanguage);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.ENGLISH.getValue();
    }
  }

  //on boarding
  Future<void> setOnBoardingScreenViewd() async {
    _sharedPreferences.setBool(prefKeyOnBoardingScreenViewd, true);
  }

  Future<bool> isOnBoardingScreenViewd() async {
    return _sharedPreferences.getBool(prefKeyOnBoardingScreenViewd) ?? false;
  }

// User Loogged In Successfully
  Future<void> setUserLooggedInSuccessfully() async {
    _sharedPreferences.setBool(prefKeyIsUserLooggedInSuccessfully, true);
  }

  Future<bool> isUserLooggedInSuccessfully() async {
    return _sharedPreferences.getBool(prefKeyIsUserLooggedInSuccessfully) ??
        false;
  }
}
