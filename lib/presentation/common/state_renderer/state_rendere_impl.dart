import 'package:clean/app/constants.dart';
import 'package:clean/presentation/common/state_renderer/state_renderer.dart';
import 'package:clean/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}
//loading state (popup,full Screen)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String? message;
  LoadingState(
      {required this.stateRendererType, String messsage = AppStrings.loading});
  @override
  String getMessage() => message ?? AppStrings.loading;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

//success state

class SuccessState extends FlowState {
  String message;
  SuccessState(this.message);
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.POPUP_SUCCESS_STATE;
}

//error state (popup,full Screen)

class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;
  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

//content state (popup,full Screen)

class ContentState extends FlowState {
  ContentState();
  @override
  String getMessage() => Constants.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.CONTENT_STATE;
}

//empty state (popup,full Screen)

class EmptyState extends FlowState {
  String message;
  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.FULL_SCREEN_EMPTY_STATE;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.POPUP_LOADING_STATE) {
            //show popup loading
            showPopup(context, getStateRendererType(), getMessage());
            //show content of screen
            return contentScreenWidget;
          } else {
            //full screen loading
            return StateRenderer(
              retryActionFunction: retryActionFunction,
              stateRendererType: getStateRendererType(),
              message: getMessage(),
            );
          }
        }
      case SuccessState:
        {
          dismissDialog(context);
          showPopup(
              context, StateRendererType.POPUP_SUCCESS_STATE, getMessage(),
              title: AppStrings.success);
          return contentScreenWidget;
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendererType() == StateRendererType.POPUP_ERROR_STATE) {
            //show popup error
            showPopup(context, getStateRendererType(), getMessage());
            //show content of screen
            return contentScreenWidget;
          } else {
            //full screen error
            return StateRenderer(
              retryActionFunction: retryActionFunction,
              stateRendererType: getStateRendererType(),
              message: getMessage(),
            );
          }
        }
      case EmptyState:
        {
          return StateRenderer(
            retryActionFunction: () {},
            stateRendererType: getStateRendererType(),
            message: getMessage(),
          );
        }
      case ContentState:
        dismissDialog(context);
        return contentScreenWidget;
      default:
        dismissDialog(context);
        return contentScreenWidget;
    }
  }

  _isCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = Constants.empty}) {
    WidgetsBinding.instance /* ? */ .addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => StateRenderer(
          retryActionFunction: () {},
          stateRendererType: stateRendererType,
          title: title,
          message: message,
        ),
      );
    });
  }
}
