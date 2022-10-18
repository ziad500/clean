// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean/presentation/resources/language_manager.dart';
import 'package:flutter/cupertino.dart';
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

  Future<void> changeAppLanguage() async {
    String currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.ENGLISH.getValue()) {
      //set arabic
      _sharedPreferences.setString(
          prefKeyLanguage, LanguageType.ARABIC.getValue());
    } else {
      //set english
      _sharedPreferences.setString(
          prefKeyLanguage, LanguageType.ENGLISH.getValue());
    }
  }

  Future<Locale> getLocal() async {
    String currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.ENGLISH.getValue()) {
      return ENGLISH_LOCAL;
    } else {
      return ARABIC_LOCAL;
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

  Future<void> logout() async {
    _sharedPreferences.remove(prefKeyIsUserLooggedInSuccessfully);
  }
}
