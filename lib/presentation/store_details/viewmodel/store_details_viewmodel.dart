import 'dart:ffi';

import 'package:clean/domain/model/models.dart';
import 'package:clean/domain/usecase/store_details_usecase.dart';
import 'package:clean/presentation/base/base_view_model.dart';
import 'package:clean/presentation/common/state_renderer/state_rendere_impl.dart';
import 'package:clean/presentation/common/state_renderer/state_renderer.dart';
import 'package:rxdart/rxdart.dart';

class StoreDetailsViewModel extends BaseViewModel
    with StoreDetailsViewModelInputs, StoreDetailsViewModelOutputs {
  final _storeDetailsStreamController = BehaviorSubject<StoreDetails>();
  final StoreDetailsUseCase _storeDetailsUseCase;

  StoreDetailsViewModel(this._storeDetailsUseCase);

  @override
  void dispose() {
    _storeDetailsStreamController.close();
    super.dispose();
  }

  @override
  void start() {
    _getStoreDetailsData();
  }

  _getStoreDetailsData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));
    (await _storeDetailsUseCase.execude(Void)).fold((failure) {
      inputState.add(ErrorState(
          StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    }, (storeDetailsData) async {
      inputState.add(ContentState());
      inputStoreDetailsData.add(storeDetailsData);
    });
  }

  @override
  Sink get inputStoreDetailsData => _storeDetailsStreamController.sink;

  @override
  Stream<StoreDetails> get outputStoreDetailsData =>
      _storeDetailsStreamController.stream.map((data) => data);
}

abstract class StoreDetailsViewModelInputs {
  Sink get inputStoreDetailsData;
}

abstract class StoreDetailsViewModelOutputs {
  Stream<StoreDetails> get outputStoreDetailsData;
}
