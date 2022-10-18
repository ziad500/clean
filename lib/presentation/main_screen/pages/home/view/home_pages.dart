import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean/domain/model/models.dart';
import 'package:clean/presentation/common/state_renderer/state_rendere_impl.dart';
import 'package:clean/presentation/main_screen/pages/home/viewmodel/home_viewmodel.dart';
import 'package:clean/presentation/resources/color_manager.dart';
import 'package:clean/presentation/resources/routes_manager.dart';
import 'package:clean/presentation/resources/strings_manager.dart';
import 'package:clean/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../app/di.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _viewModel = instance<HomeViewModel>();
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
    return Center(
      child: SingleChildScrollView(
        child: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _viewModel.start();
                }) ??
                _getContentWidget();
          },
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    return StreamBuilder<HomeViewObject>(
      stream: _viewModel.outputHomeData,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getBannersWidget(snapshot.data?.banners),
            if (snapshot.data?.banners != null &&
                snapshot.data?.services != null &&
                snapshot.data?.stores != null)
              _getSection(AppStrings.services.tr()),
            _getServicesWidget(snapshot.data?.services),
            if (snapshot.data?.banners != null &&
                snapshot.data?.services != null &&
                snapshot.data?.stores != null)
              _getSection(AppStrings.stores.tr()),
            _getStoresWidget(snapshot.data?.stores)
          ],
        );
      },
    );
  }

  Widget _getBannersWidget(List<Banners>? banners) {
    if (banners != null) {
      return CarouselSlider(
          items: banners
              .map((banner) => SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: AppSize.s1_5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s12),
                          side: BorderSide(
                              color: ColorManager.primary, width: AppSize.s1)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.s12),
                        child: Image.network(
                          banner.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
              height: AppSize.s190,
              autoPlay: true,
              enableInfiniteScroll: true,
              enlargeCenterPage: true));
    } else {
      return Container();
    }
  }

  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
          top: AppPadding.p12,
          left: AppPadding.p12,
          right: AppPadding.p12,
          bottom: AppPadding.p2),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  Widget _getServicesWidget(List<Service>? services) {
    if (services != null) {
      return Padding(
        padding:
            const EdgeInsets.only(left: AppPadding.p12, right: AppPadding.p12),
        child: Container(
          height: AppSize.s160,
          margin: const EdgeInsets.symmetric(vertical: AppMargin.m12),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: services
                .map((service) => Card(
                      elevation: AppSize.s4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s12),
                          side: BorderSide(
                              color: ColorManager.primary, width: AppSize.s1)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSize.s12),
                            child: Image.network(
                              service.image,
                              fit: BoxFit.cover,
                              width: AppSize.s120,
                              height: AppSize.s120,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: AppPadding.p8),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  service.title,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.center,
                                )),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getStoresWidget(List<Stores>? stores) {
    if (stores != null) {
      return Padding(
        padding: const EdgeInsets.only(
            left: AppPadding.p12, right: AppPadding.p12, top: AppPadding.p12),
        child: Flex(direction: Axis.vertical, children: [
          GridView.count(
            crossAxisCount: AppSize.s2,
            crossAxisSpacing: AppSize.s8,
            mainAxisSpacing: AppSize.s8,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(stores.length, (index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.storeDetailsRoutes);
                },
                child: Card(
                  elevation: AppSize.s4,
                  child: Image.network(
                    stores[index].image,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
          )
        ]),
      );
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
