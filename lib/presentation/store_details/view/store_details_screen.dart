import 'package:clean/domain/model/models.dart';
import 'package:clean/presentation/store_details/viewmodel/store_details_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../../app/di.dart';
import '../../common/state_renderer/state_rendere_impl.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({Key? key}) : super(key: key);

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  final StoreDetailsViewModel _viewModel = instance<StoreDetailsViewModel>();
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
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<FlowState>(
                stream: _viewModel.outputState,
                builder: (context, snapshot) {
                  return snapshot.data
                          ?.getScreenWidget(context, _getContentWidget(), () {
                        _viewModel.start();
                      }) ??
                      _getContentWidget();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    return StreamBuilder<StoreDetails>(
      stream: _viewModel.outputStoreDetailsData,
      builder: (context, snapshot) {
        return _getItems(snapshot.data);
      },
    );
  }

  Widget _getItems(StoreDetails? storeDetails) {
    if (storeDetails != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getImage(storeDetails.image),
          _getSection(AppStrings.details),
          _getArticle(storeDetails.details),
          _getSection(AppStrings.services),
          _getArticle(storeDetails.services),
          _getSection(AppStrings.aboutStore),
          _getArticle(storeDetails.about)
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _getImage(String image) {
    return Center(
        child: Image.network(
      image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 250,
    ));
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

  Widget _getArticle(String article) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppPadding.p12, right: AppPadding.p12, bottom: AppPadding.p2),
      child: Text(
        article,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
