import 'package:clean/app/di.dart';
import 'package:clean/presentation/common/state_renderer/state_rendere_impl.dart';
import 'package:clean/presentation/forgot_password/viewmodel/forget_password_viewmodel.dart';
import 'package:clean/presentation/resources/assets_manager.dart';
import 'package:clean/presentation/resources/color_manager.dart';
import 'package:clean/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

import '../../resources/strings_manager.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final ForgetPasswordViewModel _viewModel =
      instance<ForgetPasswordViewModel>();

  final _formKey = GlobalKey<FormState>();
  _bind() {
    _viewModel.start();
    _emailController.addListener(() {
      _viewModel.setEmail(_emailController.text);
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
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
          iconTheme: IconThemeData(color: ColorManager.black),
        ),
        body: StreamBuilder<FlowState>(
            stream: _viewModel.outputState,
            builder: (context, snapshot) {
              return snapshot.data
                      ?.getScreenWidget(context, _getContentWidget(), () {}) ??
                  _getContentWidget();
            }));
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
              child: Center(
                  child: Image(image: AssetImage(ImageAssets.splashLogo))),
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
                  stream: _viewModel.outIsEmailValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: AppStrings.email,
                          labelText: AppStrings.email,
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.userNameError),
                    );
                  },
                )),
            const SizedBox(
              height: AppSize.s28,
            ),
            Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: AppSize.s40,
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outIsEmailValid,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  print(
                                      '.........................${_emailController.text}');
                                  _viewModel.resetPassword();
                                }
                              : null,
                          child: const Text(AppStrings.resetPassword));
                    },
                  ),
                )),
            const SizedBox(
              height: AppSize.s28,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    AppStrings.didntResieveEmail,
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
