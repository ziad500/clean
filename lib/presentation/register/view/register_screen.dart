import 'dart:io';

import 'package:clean/app/app_preferences.dart';
import 'package:clean/presentation/common/state_renderer/state_rendere_impl.dart';
import 'package:clean/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:clean/presentation/resources/color_manager.dart';
import 'package:clean/presentation/resources/values_manager.dart';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/di.dart';
import '../../resources/assets_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/strings_manager.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final countryPicker = const FlCountryCodePicker();

  CountryCode? countryCode =
      const CountryCode(name: "Egypt", code: 'EG', dialCode: "+20");

  _bind() {
    _viewModel.start();
    _userNameController.addListener(() {
      _viewModel.setUserName(_userNameController.text);
    });
    _mobileNumberController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberController.text);
    });
    _passwordController.addListener(() {
      _viewModel.setPassword(_passwordController.text);
    });
    _emailController.addListener(() {
      _viewModel.setEmail(_emailController.text);
    });
    _viewModel.isUserRegisteredInSuccessfullyStreamController.stream
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
      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.register();
              }) ??
              _getContentWidget();
          ;
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      color: ColorManager.white,
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Center(
                child: Image(image: AssetImage(ImageAssets.splashLogo))),
            const SizedBox(
              height: AppSize.s12,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p28,
                right: AppPadding.p28,
              ),
              child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorUserName,
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: _userNameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: AppStrings.userName,
                        labelText: AppStrings.userName,
                        errorText: snapshot.data),
                  );
                },
              ),
            ),
            const SizedBox(
              height: AppSize.s18,
            ),
            Center(
                child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppPadding.p28,
                      right: AppPadding.p28,
                    ),
                    child: Row(children: [
                      Expanded(
                          flex: 1,
                          child: StreamBuilder<bool>(
                            stream: _viewModel.outputCountryCode,
                            builder: (context, snapshot) {
                              return InkWell(
                                  onTap: () async {
                                    //TODO:ASDASASD
                                    final code = await countryPicker.showPicker(
                                        context: context);

                                    if (code != null) {
                                      countryCode = code;
                                    } else {
                                      countryCode = countryCode;
                                    }
                                    _viewModel.setCountryCode(
                                        countryCode?.dialCode ?? "");
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 35,
                                        child: countryCode != null
                                            ? countryCode!.flagImage
                                            : null,
                                      ),
                                    ],
                                  ));
                            },
                          )),
                      Expanded(
                        flex: 5,
                        child: StreamBuilder<String?>(
                          stream: _viewModel.outputErrorMobileNumber,
                          builder: (context, snapshot) {
                            return TextFormField(
                              controller: _mobileNumberController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: AppStrings.mobileNumber,
                                  labelText: AppStrings.mobileNumber,
                                  errorText: snapshot.data),
                            );
                          },
                        ),
                      )
                    ]))),
            const SizedBox(
              height: AppSize.s18,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p28,
                right: AppPadding.p28,
              ),
              child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorEmail,
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: AppStrings.email,
                        labelText: AppStrings.email,
                        errorText: snapshot.data),
                  );
                },
              ),
            ),
            const SizedBox(
              height: AppSize.s18,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p28,
                right: AppPadding.p28,
              ),
              child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorPassword,
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        hintText: AppStrings.password,
                        labelText: AppStrings.password,
                        errorText: snapshot.data),
                  );
                },
              ),
            ),
            const SizedBox(
              height: AppSize.s18,
            ),
            Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: Container(
                  height: AppSize.s40,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(AppSize.s8)),
                      border: Border.all(color: ColorManager.grey)),
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: _getMediaWidget(),
                  ),
                )),
            const SizedBox(
              height: AppSize.s40,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p28,
                right: AppPadding.p28,
              ),
              child: StreamBuilder<bool>(
                stream: _viewModel.outputAreAllInputsValid,
                builder: (context, snapshot) {
                  return SizedBox(
                    width: double.infinity,
                    height: AppSize.s40,
                    child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () {
                                _viewModel.register();
                              }
                            : null,
                        child: const Text(AppStrings.register)),
                  );
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28,
                    right: AppPadding.p28,
                    top: AppPadding.p18),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.loginRoutes);
                      },
                      child: Text(
                        AppStrings.alreadyHaveAnAccount,
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                )),
          ],
        ),
      )),
    );
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: [
            ListTile(
              trailing: const Icon(Icons.arrow_forward),
              leading: const Icon(Icons.image),
              title: const Text(AppStrings.photoGallary),
              onTap: () {
                _imageFromGallary();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              trailing: const Icon(Icons.arrow_forward),
              leading: const Icon(Icons.camera_alt),
              title: const Text(AppStrings.photoCamera),
              onTap: () {
                _imageFromCamera();
                Navigator.of(context).pop();
              },
            )
          ],
        ));
      },
    );
  }

  _imageFromGallary() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(child: Text(AppStrings.profilePicture)),
          Flexible(
              child: StreamBuilder<File>(
            stream: _viewModel.outputProfilePicture,
            builder: (context, snapshot) {
              return _imagePickedByUser(snapshot.data);
            },
          )),
          Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIcon))
        ],
      ),
    );
  }

  Widget _imagePickedByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      //return image
      return Image.file(image);
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
