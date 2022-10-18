import 'dart:async';

import 'package:clean/app/functions.dart';
import 'package:clean/domain/usecase/forgot_password_usecase.dart';
import 'package:clean/presentation/base/base_view_model.dart';

import '../../common/state_renderer/state_rendere_impl.dart';
import '../../common/state_renderer/state_renderer.dart';

class ForgetPasswordViewModel extends BaseViewModel
    with ForgetPasswordViewModelInput, ForgetPasswordViewModelOutput {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();

  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  var email = "";

  ForgetPasswordViewModel(this._forgotPasswordUseCase);

  @override
  void dispose() {
    super.dispose();
    _emailStreamController.close();
    _areAllInputsValidStreamController.close();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Stream<bool> get outIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  /* bool _isEmailValid(String email) {
    return email.isNotEmpty;
  } */

  bool _areAllInputsValid() {
    return isEmailValid(email);
  }

  @override
  resetPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _forgotPasswordUseCase.execude(ForgotPasswordUseCaseInput(email)))
        .fold(
            (failure) => {
                  inputState.add(ErrorState(
                      StateRendererType.POPUP_ERROR_STATE, failure.message))
                }, (data) {
      inputState.add(ContentState());
      inputState
          .add(ErrorState(StateRendererType.POPUP_ERROR_STATE, data.support));
      inputState.add(SuccessState(data.support));
    });
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    inputAreAllInputsValid.add(null);
  }

  @override
  Sink get inputAreAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllInputsValidStreamController.stream.map((_) {
        return _areAllInputsValid();
      });
}

abstract class ForgetPasswordViewModelInput {
  setEmail(String email);
  resetPassword();
  Sink get inputEmail;
  Sink get inputAreAllInputsValid;
}

abstract class ForgetPasswordViewModelOutput {
  Stream<bool> get outIsEmailValid;
  Stream<bool> get outAreAllInputsValid;
}
