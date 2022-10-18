import 'dart:async';
import 'dart:ffi';

import 'package:clean/domain/model/models.dart';
import 'package:clean/domain/usecase/home_usecase.dart';
import 'package:clean/presentation/base/base_view_model.dart';
import 'package:clean/presentation/common/state_renderer/state_rendere_impl.dart';
import 'package:clean/presentation/common/state_renderer/state_renderer.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  final _homeDataStreamController = BehaviorSubject<HomeViewObject>();

  final HomeUseCase _homeUseCase;
  HomeViewModel(this._homeUseCase);

  //--inputs

  _getHomeData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));
    (await _homeUseCase.execude(Void)).fold((failure) {
      inputState.add(ErrorState(
          StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    }, (homeObject) {
      inputState.add(ContentState());
      inputHomeData.add(HomeViewObject(homeObject.data.banners,
          homeObject.data.services, homeObject.data.stores));
    });
  }

  @override
  void dispose() {
    _homeDataStreamController.close();
    super.dispose();
  }

  @override
  void start() {
    _getHomeData();
  }

  @override
  Sink get inputHomeData => _homeDataStreamController.sink;

  //--outputs

  @override
  Stream<HomeViewObject> get outputHomeData =>
      _homeDataStreamController.stream.map((homeData) => homeData);
}

abstract class HomeViewModelInputs {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeData;
}

class HomeViewObject {
  List<Banners> banners;
  List<Service> services;
  List<Stores> stores;

  HomeViewObject(this.banners, this.services, this.stores);
}
