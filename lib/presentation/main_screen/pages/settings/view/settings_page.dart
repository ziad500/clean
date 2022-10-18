import 'package:clean/app/app_preferences.dart';
import 'package:clean/data/data_source/local_data_source.dart';
import 'package:clean/presentation/resources/assets_manager.dart';
import 'package:clean/presentation/resources/language_manager.dart';
import 'package:clean/presentation/resources/routes_manager.dart';
import 'package:clean/presentation/resources/strings_manager.dart';
import 'package:clean/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import '../../../../../app/di.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(AppPadding.p8),
        children: [
          ListTile(
            leading: SvgPicture.asset(ImageAssets.changeLanguageIcon,
                width: AppSize.s25),
            title: Text(
              AppStrings.changeLanguage.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
              child: SvgPicture.asset(ImageAssets.settingsArrowIcon),
            ),
            onTap: () {
              _changeLanguage();
            },
          ),
          ListTile(
            leading:
                SvgPicture.asset(ImageAssets.contactUsIcon, width: AppSize.s25),
            title: Text(
              AppStrings.contactUs.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
              child: SvgPicture.asset(ImageAssets.settingsArrowIcon),
            ),
            onTap: () {
              _contactUs();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.inviteFriendsIcon,
                width: AppSize.s25),
            title: Text(
              AppStrings.inviteYOurFriends.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
              child: SvgPicture.asset(ImageAssets.settingsArrowIcon),
            ),
            onTap: () {
              _inviteFriends();
            },
          ),
          ListTile(
            leading:
                SvgPicture.asset(ImageAssets.logoutIcon, width: AppSize.s25),
            title: Text(
              AppStrings.logout.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
              child: SvgPicture.asset(ImageAssets.settingsArrowIcon),
            ),
            onTap: () {
              _logout();
            },
          )
        ],
      ),
    );
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL;
  }

  _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  _contactUs() {}

  _inviteFriends() {}

  _logout() {
    _appPreferences.logout();
    _localDataSource.clearCache();
    Navigator.pushReplacementNamed(context, Routes.loginRoutes);
  }
}
