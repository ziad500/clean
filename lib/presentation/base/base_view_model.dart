import 'dart:async';

import 'package:clean/presentation/common/state_renderer/state_rendere_impl.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  // shared variables
  final StreamController _inputStreamController =
      StreamController<FlowState>.broadcast();

  @override
  Sink get inputState => _inputStreamController.sink;

  @override
  Stream<FlowState> get outputState =>
      _inputStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _inputStreamController.close();
  }
}

abstract class BaseViewModelInputs {
  // start view model job
  void start();
  //will be called when view model dies
  void dispose();

  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  // will be implemented later
  Stream<FlowState> get outputState;
}
