import 'dart:async';
import 'dart:io';

import 'package:clean/app/functions.dart';
import 'package:clean/domain/usecase/register_usecase.dart';
import 'package:clean/presentation/base/base_view_model.dart';
import 'package:clean/presentation/common/freezed_data_classes.dart';
import 'package:clean/presentation/common/state_renderer/state_rendere_impl.dart';
import 'package:clean/presentation/common/state_renderer/state_renderer.dart';
import 'package:clean/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInputs, RegisterViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();

  final StreamController _mobileNumberStreamController =
      StreamController<String>.broadcast();

  final StreamController _countrycodeController =
      StreamController<String>.broadcast();

  final StreamController _emailStreamController = StreamController.broadcast();

  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();

  final StreamController _profilePictureStreamController =
      StreamController<File>.broadcast();

  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();

  final StreamController isUserRegisteredInSuccessfullyStreamController =
      StreamController<bool>();

  final RegisterUseCase _registerUseCase;
  var registerObject = RegisterObject('', '', '', '', '', '');
  RegisterViewModel(this._registerUseCase);

  @override
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _mobileNumberStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _profilePictureStreamController.close();
    _areAllInputsValidStreamController.close();
    _countrycodeController.close();
    isUserRegisteredInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

//inputs
  @override
  Sink get emailInput => _emailStreamController.sink;

  @override
  Sink get mobileNumberInput => _mobileNumberStreamController.sink;

  @override
  Sink get passwordInput => _passwordStreamController.sink;

  @override
  Sink get profilePictureInput => _profilePictureStreamController.sink;

  @override
  Sink get userNameInput => _userNameStreamController.sink;

  @override
  Sink get areAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  Sink get countryCodeInput => _countrycodeController.sink;

  @override
  setUserName(String userName) {
    userNameInput.add(userName);
    if (_isUserNameValid(userName)) {
      //update register view object
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      // reset userName value in register view object
      registerObject = registerObject.copyWith(userName: "");
    }
    validate();
  }

  @override
  register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _registerUseCase.execude(RegisterUseCaseInputs(
            registerObject.userName,
            registerObject.countryMobileCode,
            registerObject.mobileNumber,
            registerObject.email,
            registerObject.password,
            registerObject.profilePicture)))
        .fold((failure) {
      inputState.add(
          ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message));
    }, (data) {
      inputState.add(ContentState());
      isUserRegisteredInSuccessfullyStreamController.add(true);
    });
  }

  @override
  setCountryCode(String countryCode) {
    countryCodeInput.add(countryCode);
    if (countryCode != null) {
      //update register view object

      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      // reset countryCode value in register view object
      registerObject = registerObject.copyWith(countryMobileCode: "");
    }
    validate();
  }

  @override
  setEmail(String email) {
    emailInput.add(email);
    if (isEmailValid(email)) {
      //update register view object
      registerObject = registerObject.copyWith(email: email);
    } else {
      // reset email value in register view object
      registerObject = registerObject.copyWith(email: "");
    }
    validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    mobileNumberInput.add(mobileNumber);
    if (_isMobileNumberValid(mobileNumber)) {
      //update register view object
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      // reset mobileNumber value in register view object
      registerObject = registerObject.copyWith(mobileNumber: "");
    }
    validate();
  }

  @override
  setPassword(String password) {
    passwordInput.add(password);
    if (_isPasswordValid(password)) {
      //update register view object
      registerObject = registerObject.copyWith(password: password);
    } else {
      // reset password value in register view object
      registerObject = registerObject.copyWith(password: "");
    }
    validate();
  }

  @override
  setProfilePicture(File profilePicture) {
    profilePictureInput.add(profilePicture);
    if (profilePicture.path.isNotEmpty) {
      //update register view object
      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      // reset profilePicture value in register view object
      registerObject = registerObject.copyWith(profilePicture: "");
    }
    validate();
  }

// outputs

  @override
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<String?> get outputErrorUserName => outputIsUserNameValid
      .map((isUserName) => isUserName ? null : AppStrings.userNameError.tr());

  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputErrorEmail => outputIsEmailValid.map(
      (isEmailValid) => isEmailValid ? null : AppStrings.emailInvalid.tr());

  @override
  Stream<bool> get outputIsMobileNumberValid =>
      _mobileNumberStreamController.stream
          .map((mobileNumber) => _isMobileNumberValid(mobileNumber));

  @override
  Stream<String?> get outputErrorMobileNumber =>
      outputIsMobileNumberValid.map((isMobileNumberValid) =>
          isMobileNumberValid ? null : AppStrings.mobileNumberInvalid.tr());

  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<String?> get outputErrorPassword =>
      outputIsPasswordValid.map((isPasswordValid) =>
          isPasswordValid ? null : AppStrings.passwordInvalid.tr());

  @override
  Stream<File> get outputProfilePicture =>
      _profilePictureStreamController.stream.map((file) => file);

  @override
  Stream<bool> get outputAreAllInputsValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  @override
  Stream<bool> get outputCountryCode => _countrycodeController.stream
      .map((countryCode) => _isCountryCodeValid(countryCode));

  // private function
  bool _isCountryCodeValid(String countryCode) {
    return countryCode.isNotEmpty;
  }

  bool _isUserNameValid(String userName) {
    return userName.length >= 8;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 10;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _areAllInputsValid() {
    return registerObject.countryMobileCode.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.profilePicture.isNotEmpty &&
        registerObject.userName.isNotEmpty;
  }

  validate() {
    areAllInputsValid.add(null);
  }
}

abstract class RegisterViewModelInputs {
  Sink get userNameInput;
  Sink get countryCodeInput;

  Sink get mobileNumberInput;
  Sink get emailInput;
  Sink get passwordInput;
  Sink get profilePictureInput;
  Sink get areAllInputsValid;

  register();
  setUserName(String userName);
  setMobileNumber(String mobileNumber);
  setCountryCode(String countryCode);
  setEmail(String email);
  setPassword(String password);
  setProfilePicture(File profilePicture);
}

abstract class RegisterViewModelOutputs {
  Stream<bool> get outputIsUserNameValid;
  Stream<String?> get outputErrorUserName;

  Stream<bool> get outputIsMobileNumberValid;
  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outputCountryCode;

  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;

  Stream<File> get outputProfilePicture;

  Stream<bool> get outputAreAllInputsValid;
}
