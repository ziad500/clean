abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  // shared variables
}

abstract class BaseViewModelInputs {
  // start view model job
  void start();
  //will be called when view model dies
  void dispose();
}

abstract class BaseViewModelOutputs {
  // will be implemented later
}
