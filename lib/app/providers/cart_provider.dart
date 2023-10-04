import 'package:happiness_club_merchant/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../src/features/screens/products_by_business/usecase/get_all_products.dart';

class CartProvider extends ChangeNotifier {
  List<ProductData> items = [];
  int totalItems = 0;

  void cacheCartItems(ProductData item) {
    dp("Items is ?", items.any((element) => element.id == item.id));

    if (items.any((element) => element.id == item.id)) {
      notifyListeners();
      Fluttertoast.showToast(
        msg: "Item already exists",
      );
      return;
    }

    Fluttertoast.showToast(msg: "Item added to cart");

    items.add(item);

    totalItems = items.length;

    notifyListeners();
  }

  double getSubTotal() {
    final double total = items.fold(
        0.0, (double sum, item) => sum + (item.sellingPrice * item.quantity));
    return total;
  }

  double getTotalAfterDiscount() {
    final double total = items.fold(
        0.0, (double sum, item) => sum + (item.offerRate * item.quantity));
    return total;
  }
}
