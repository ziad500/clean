import 'package:clean/app/di.dart';
import 'package:clean/presentation/common/state_renderer/state_rendere_impl.dart';
import 'package:clean/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:clean/presentation/resources/assets_manager.dart';
import 'package:clean/presentation/resources/color_manager.dart';
import 'package:clean/presentation/resources/routes_manager.dart';
import 'package:clean/presentation/resources/strings_manager.dart';
import 'package:clean/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../app/app_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel _viewModel = instance<LoginViewModel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _bind() {
    _viewModel.start();
    _userNameController
        .addListener(() => _viewModel.setUserName(_userNameController.text));
    _passwordController
        .addListener(() => _viewModel.setPassword(_passwordController.text));
    _viewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _appPreferences.setUserLooggedInSuccessfully();
          Navigator.pushReplacementNamed(context, Routes.mainRoutes);
        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.login();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p100),
      color: ColorManager.white,
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Center(
                child: Image(image: AssetImage(ImageAssets.splashLogo))),
            const SizedBox(
              height: AppSize.s28,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p28,
                right: AppPadding.p28,
              ),
              child: StreamBuilder<bool>(
                stream: _viewModel.outIsUserNameValid,
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: _userNameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: AppStrings.userName.tr(),
                        labelText: AppStrings.userName.tr(),
                        errorText: (snapshot.data ?? true)
                            ? null
                            : AppStrings.userNameError),
                  );
                },
              ),
            ),
            const SizedBox(
              height: AppSize.s28,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p28,
                right: AppPadding.p28,
              ),
              child: StreamBuilder<bool>(
                stream: _viewModel.outIsPasswordValid,
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        hintText: AppStrings.password.tr(),
                        labelText: AppStrings.password.tr(),
                        errorText: (snapshot.data ?? true)
                            ? null
                            : AppStrings.passwordError.tr()),
                  );
                },
              ),
            ),
            const SizedBox(
              height: AppSize.s28,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p28,
                right: AppPadding.p28,
              ),
              child: StreamBuilder<bool>(
                stream: _viewModel.outAreAllInputsValid,
                builder: (context, snapshot) {
                  return SizedBox(
                    width: double.infinity,
                    height: AppSize.s40,
                    child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () {
                                _viewModel.login();
                              }
                            : null,
                        child: Text(AppStrings.login.tr())),
                  );
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28,
                    right: AppPadding.p28,
                    top: AppPadding.p8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.forgotPasswordRoutes);
                          },
                          child: Text(
                            AppStrings.forgetPassword.tr(),
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.registerRoutes);
                          },
                          child: Text(
                            AppStrings.registerText.tr(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ))
                    ],
                  ),
                )),
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
