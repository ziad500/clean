import 'dart:async';

import 'package:clean/domain/model/models.dart';
import 'package:clean/presentation/base/base_view_model.dart';
import 'package:clean/presentation/resources/assets_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../resources/routes_manager.dart';
import '../../resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  //stream controllers outputs
  final StreamController _streamController =
      StreamController<SliderViewObject>();
  //onboarding viewModel inputs
  late final List<SliderObject> _list;
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    //view model start your job
    _list = _getSliderData();
    _postDataToView();
  }

  @override
  int goNext(BuildContext context) {
    int nextIndex = ++_currentPageIndex;
    if (nextIndex == _list.length) {
      Navigator.pushReplacementNamed(context, Routes.loginRoutes);

      // nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = --_currentPageIndex;
    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentPageIndex = index;
    _postDataToView();
  }

  @override
  Sink get inputSliderViewObject => _streamController.sink;

  //onboarding viewModel outputs

  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);

  // OnBoarding Private Function
  List<SliderObject> _getSliderData() => [
        SliderObject(
            ImageAssets.onBoardingLogo1,
            AppStrings.onBoardingSubTitle1.tr(),
            AppStrings.onBoardingTitle1.tr()),
        SliderObject(
            ImageAssets.onBoardingLogo2,
            AppStrings.onBoardingSubTitle2.tr(),
            AppStrings.onBoardingTitle2.tr()),
        SliderObject(
            ImageAssets.onBoardingLogo3,
            AppStrings.onBoardingSubTitle3.tr(),
            AppStrings.onBoardingTitle3.tr()),
        SliderObject(
            ImageAssets.onBoardingLogo4,
            AppStrings.onBoardingSubTitle4.tr(),
            AppStrings.onBoardingTitle4.tr())
      ];

  void _postDataToView() {
    inputSliderViewObject.add(SliderViewObject(
        _currentPageIndex, _list.length, _list[_currentPageIndex]));
  }
}

//inputs mean orders that are view model will receive from view
abstract class OnBoardingViewModelInputs {
  int goNext(BuildContext context);
  int goPrevious();
  void onPageChanged(int index);
  //stream controller input
  Sink get inputSliderViewObject;
}

abstract class OnBoardingViewModelOutputs {
  Stream<SliderViewObject> get outputSliderViewObject;
}
