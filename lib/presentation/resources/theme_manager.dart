import 'package:clean/presentation/resources/color_manager.dart';
import 'package:clean/presentation/resources/styles_manager.dart';
import 'package:clean/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

import 'font_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      //main colors
      primaryColor: ColorManager.primary,
      primaryColorLight: ColorManager.lightPrimary,
      primaryColorDark: ColorManager.darkPrimary,
      disabledColor: ColorManager.grey1,
      splashColor: ColorManager.lightPrimary, // ripple effect color
      //cardView theme
      cardTheme: CardTheme(
          color: ColorManager.white,
          shadowColor: ColorManager.grey,
          elevation: AppSize.s4),
      //appbar theme
      appBarTheme: AppBarTheme(
          centerTitle: true,
          color: ColorManager.primary,
          iconTheme: IconThemeData(color: ColorManager.white),
          elevation: AppSize.s4,
          shadowColor: ColorManager.lightPrimary,
          titleTextStyle: getRegularStyle(
              color: ColorManager.white, fontSize: FontSize.s16)),
      //button theme
      buttonTheme: ButtonThemeData(
          shape: const StadiumBorder(),
          disabledColor: ColorManager.grey1,
          buttonColor: ColorManager.primary,
          splashColor: ColorManager.lightPrimary),
      //elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: getRegularStyle(
                  color: ColorManager.white, fontSize: FontSize.s17),
              backgroundColor: ColorManager.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s12)))),
      //text theme
      textTheme: TextTheme(
        headlineLarge: getSemiBoldStyle(
            color: ColorManager.darkGrey, fontSize: FontSize.s16),
        headlineMedium: getRegularStyle(
          color: ColorManager.darkGrey,
          fontSize: FontSize.s14,
        ),
        titleMedium:
            getMediumStyle(color: ColorManager.primary, fontSize: FontSize.s16),
        bodyLarge:
            getRegularStyle(color: ColorManager.grey1, fontSize: FontSize.s14),
        bodySmall: getRegularStyle(color: ColorManager.grey),
        headlineSmall:
            getRegularStyle(color: ColorManager.grey2, fontSize: FontSize.s12),
        titleSmall:
            getRegularStyle(color: ColorManager.white, fontSize: FontSize.s20),
        labelSmall:
            getBoldStyle(color: ColorManager.primary, fontSize: FontSize.s16),
      ),
      //input decoration theme (text form field)
      inputDecorationTheme: InputDecorationTheme(
          //content padding
          contentPadding: const EdgeInsets.all(AppPadding.p8),
          //hint style
          hintStyle:
              getRegularStyle(color: ColorManager.grey, fontSize: FontSize.s14),
          //label style
          labelStyle:
              getMediumStyle(color: ColorManager.grey, fontSize: FontSize.s14),
          //error style
          errorStyle: getRegularStyle(
              color: ColorManager.error, fontSize: FontSize.s14),
          //enable border style
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppSize.s8))),
          //focused border style
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
          ),
          //error border style
          errorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorManager.error, width: AppSize.s1_5),
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppSize.s8))),
          //focused error border style
          focusedErrorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppSize.s8)))));
}
