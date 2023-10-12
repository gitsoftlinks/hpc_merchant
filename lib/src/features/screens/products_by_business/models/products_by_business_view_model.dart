// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happiness_club_merchant/src/features/screens/products_by_business/usecase/get_all_products.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import '../../../../../app/providers/account_provider.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../utils/router/app_state.dart';
import '../../../../../utils/router/models/page_action.dart';
import '../../../../../utils/router/models/page_config.dart';
import '../../../../../utils/router/ui_pages.dart';
import '../../signin_screen/usecases/send_login.dart';

class ProductsByBusinessViewModel extends ChangeNotifier {
  final GetAllProducts _getAllProducts;
  final AppState _appState;
  ProductsByBusinessViewModel(
      {required GetAllProducts getAllProducts,
      required final AppState appState})
      : _getAllProducts = getAllProducts,
        _appState = appState;

  List<BusinessProduct> products = [];
  ValueChanged<String>? errorMessages;
  ValueChanged<String>? successMessage;
  bool isLoading = false;
  UserData user = GetIt.I.get<AccountProvider>().user;
  void onTapProduct(int id, List<BusinessProduct> productList) {
    _appState.currentAction = PageAction(
        state: PageState.addPage,
        page: PageConfiguration.withArguments(ProductDetailScreenConfig, {
          'productId': id,
          'productList':
              productList.where((element) => element.id != id).toList()
        }));

    return;
  }

  void handleError(Either<Failure, dynamic> either) {
    isLoading = false;
    notifyListeners();
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  Future<void> getProducts(businessId) async {
    isLoading = true;
    notifyListeners();
    var params = GetAllProductsParams(accessToken: '', businessId: businessId!);
    var getProductsEither = await _getAllProducts.call(params);
    if (getProductsEither.isLeft()) {
      handleError(getProductsEither);
      return;
    }
    products = getProductsEither
        .toOption()
        .toNullable()!
        .businessProducts
        .reversed
        .toList();
    isLoading = false;
    notifyListeners();
    return;
  }
}
