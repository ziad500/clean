import 'dart:async';

import 'package:clean/app/app_preferences.dart';
import 'package:clean/presentation/resources/assets_manager.dart';
import 'package:clean/presentation/resources/color_manager.dart';
import 'package:clean/presentation/resources/constants_manager.dart';
import 'package:clean/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';

import '../../app/di.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() async {
    _appPreferences.isUserLooggedInSuccessfully().then((isUserLooggedIn) {
      if (isUserLooggedIn) {
        Navigator.pushReplacementNamed(context, Routes.mainRoutes);
      } else {
        _appPreferences
            .isOnBoardingScreenViewd()
            .then((isOnBoardingScreenViewd) {
          if (isOnBoardingScreenViewd) {
            Navigator.pushReplacementNamed(context, Routes.loginRoutes);
          } else {
            Navigator.pushReplacementNamed(context, Routes.onBoardingRoutes);
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: const Center(
        child: Image(image: AssetImage(ImageAssets.splashLogo)),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
