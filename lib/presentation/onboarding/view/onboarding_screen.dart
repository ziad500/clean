import 'package:clean/presentation/onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:clean/presentation/resources/color_manager.dart';
import 'package:clean/presentation/resources/constants_manager.dart';
import 'package:clean/presentation/resources/routes_manager.dart';
import 'package:clean/presentation/resources/strings_manager.dart';
import 'package:clean/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/model/models.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  final OnBoardingViewModel _viewModel = OnBoardingViewModel();
  _bind() {
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
      stream: _viewModel.outputSliderViewObject,
      builder: (context, snapshot) => _getContentWidget(snapshot.data),
    );
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject) {
    if (sliderViewObject == null) {
      return Container();
    } else {
      return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ColorManager.white,
              statusBarIconBrightness: Brightness.dark),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: sliderViewObject.numOfSlides,
          onPageChanged: (index) {
            _viewModel.onPageChanged(index);
          },
          itemBuilder: (context, index) {
            return OnBoardingPage(sliderViewObject.sliderObject);
          },
        ),
        bottomSheet: Container(
          color: ColorManager.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(
                    AppStrings.skip,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.loginRoutes);
                  },
                ),
              ),
              _getButtomSheetWidget(sliderViewObject)
            ],
          ),
        ),
      );
    }
  }

  Widget _getButtomSheetWidget(SliderViewObject sliderViewObject) {
    return Container(
      color: ColorManager.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //left arrow
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
                onTap: () {
                  _pageController.animateToPage(_viewModel.goPrevious(),
                      duration: const Duration(
                          milliseconds: AppConstants.sliderAnimationTime),
                      curve: Curves.bounceInOut);
                },
                child: SizedBox(
                    width: AppSize.s20,
                    height: AppSize.s20,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: ColorManager.white,
                    ) /* SvgPicture.asset(ImageAssets.leftArrowIcon) */)),
          ),
          //circle indicator
          Row(
            children: [
              for (int i = 0; i < sliderViewObject.numOfSlides; i++)
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  child: _getProperCircle(i, sliderViewObject),
                )
            ],
          ),

          //right arrow
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
                onTap: () {
                  _pageController.animateToPage(_viewModel.goNext(),
                      duration: const Duration(
                          milliseconds: AppConstants.sliderAnimationTime),
                      curve: Curves.bounceInOut);
                },
                child: SizedBox(
                    width: AppSize.s20,
                    height: AppSize.s20,
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: ColorManager.white,
                    ) /* SvgPicture.asset(ImageAssets.rightArrowIcon) */)),
          )
        ],
      ),
    );
  }

  _getProperCircle(int index, SliderViewObject sliderViewObject) {
    if (index == sliderViewObject.currentIndex) {
      return Icon(
        Icons.circle_outlined,
        color: ColorManager.white,
        size: 13,
      ) /* SvgPicture.asset(ImageAssets.hollowCircleIcon) */;
    } else {
      return Icon(
        Icons.circle,
        color: ColorManager.white,
        size: 10,
      ) /* SvgPicture.asset(ImageAssets.solidCircleIcon) */;
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject _sliderObject;
  const OnBoardingPage(this._sliderObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppSize.s40,
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.subTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(
          height: AppSize.s60,
        ),
        Padding(
            padding: const EdgeInsets.all(AppPadding.p8),
            child: SvgPicture.asset(_sliderObject.image))
      ],
    );
  }
}
