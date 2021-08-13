import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_shop_app/models/dummy_data.dart';

import 'product_provider.dart';

class ProductListProvider with ChangeNotifier {
  List<ProductProvider> _productList = DUMMY_PRODUCTS;

/* APP -WIDE FILTER -WE DO NOT WANT-WE NEED LOCAL FILTER SO COMMENTED OUT
  bool _isShowOnlyFavourites = false;

  void setIsShowOnlyFavourites({bool isShowFavourites = false}) {
    _isShowOnlyFavourites = isShowFavourites;
    notifyListeners();
  }

  UnmodifiableListView<ProductProvider> get productList {
    if (_isShowOnlyFavourites) {
      return UnmodifiableListView(
        _productList.where((product) => product.isFavourite),
      );
    } else {
      return UnmodifiableListView(_productList);
    }
  }
*/
  UnmodifiableListView<ProductProvider> get productList =>
      UnmodifiableListView(_productList);

  UnmodifiableListView<ProductProvider> get favouriteProductList {
    return UnmodifiableListView(
      _productList.where((product) => product.isFavourite),
    );
  }

  void addProduct({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required double price,
  }) {
    _productList.add(
      ProductProvider(
          title: title,
          description: description,
          imageUrl: imageUrl,
          price: price),
    );

    notifyListeners();
  }

  removeProduct(int index) {
    _productList.removeAt(index);
    notifyListeners();
  }

  ProductProvider findFirsMatching({required String productID}) {
    return _productList.firstWhere((element) => element.id == productID);
  }
}
