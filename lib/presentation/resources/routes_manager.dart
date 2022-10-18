import 'package:clean/app/di.dart';
import 'package:clean/presentation/forgot_password/view/forgot_password_screen.dart';
import 'package:clean/presentation/login/view/login_screen.dart';
import 'package:clean/presentation/main_screen/main_screen.dart';
import 'package:clean/presentation/onboarding/view/onboarding_screen.dart';
import 'package:clean/presentation/register/view/register_screen.dart';
import 'package:clean/presentation/resources/strings_manager.dart';
import 'package:clean/presentation/splash/splash_screen.dart';
import 'package:clean/presentation/store_details/view/store_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splashRoutes = "/";
  static const String loginRoutes = "/login";
  static const String registerRoutes = "/register";
  static const String forgotPasswordRoutes = "/forgotPassword";
  static const String onBoardingRoutes = "/onBoarding";

  static const String mainRoutes = "/main";
  static const String storeDetailsRoutes = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoutes:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case Routes.onBoardingRoutes:
        return MaterialPageRoute(
          builder: (context) => const OnBoardingScreen(),
        );
      case Routes.loginRoutes:
        initLoginModule();
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case Routes.registerRoutes:
        initRegisterModule();
        return MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        );
      case Routes.forgotPasswordRoutes:
        initForgotPasswordModule();
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordScreen(),
        );
      case Routes.mainRoutes:
        initHomeModule();
        return MaterialPageRoute(
          builder: (context) => const MainScreen(),
        );
      case Routes.storeDetailsRoutes:
        initStoreDetailsModule();
        return MaterialPageRoute(
          builder: (context) => const StoreDetailsScreen(),
        );
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.noRouteFound.tr()), // todo move string
        ),
        body: Center(
          child: Text(AppStrings.noRouteFound.tr()),
        ),
      ),
    );
  }
}
