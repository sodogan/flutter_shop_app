import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'product_provider.dart';
import '../../utility/firebase_utility.dart' as firebase;

mixin ListFunctions {}

abstract class ListProvider {
  void addProduct({
    required String title,
    required String description,
    required String imageUrl,
    required double price,
  });

  void updateExistingProduct({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required double price,
  });

  removeProduct({required int index});
}

class ProductListProvider extends ListProvider with ChangeNotifier {
  List<ProductProvider> _productList = [];

  String? authToken;
  String? userId;

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

  Future<void> fetchAndSetProducts({bool isUserBased = false}) async {
    try {
      List<ProductProvider> _loadedProducts = [];
      Map<String, dynamic> _products;
      if (isUserBased) {
        _products = await firebase.FirebaseUtility()
            .fetchAllProductsFirebaseAsync(
                authToken: authToken!, userId: userId);
      } else {
        _products = await firebase.FirebaseUtility()
            .fetchAllProductsFirebaseAsync(authToken: authToken!);
      }

      _products.forEach((productID, value) {
        //check if already exists
        value['id'] = productID;
        final _product = ProductProvider.fromJSON(value);
        // to read the isFavourite
        _product.isFavourite = value['isFavourite'];
        _loadedProducts.add(_product);
      });
      _productList = _loadedProducts;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> addProduct({
    required String title,
    required String description,
    required String imageUrl,
    required double price,
  }) async {
//Need to use the firebaseutil
    try {
      final _json = {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavourite': false
      };
      final _id = await firebase.FirebaseUtility()
          .productFirebaseAsyncPost(jsonData: _json);
      //set the generated id
      final _newProduct = ProductProvider(
          id: _id,
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl);
      _productList.add(_newProduct);
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> updateExistingProduct({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required double price,
  }) async {
    print('Updating Product id: $id');
    //find the matching product!
    final _index =
        _productList.indexWhere((ProductProvider product) => product.id == id);
    assert(_index != -1, 'Failed to find the matching Product ID');

    final _jsonData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
    try {
      await firebase.FirebaseUtility()
          .updateFirebaseAsync(id: id, jsonData: _jsonData);

      //update the product
      _productList[_index] = ProductProvider(
          id: id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          price: price);

      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  @override
  removeProduct({required int index}) async {
    assert(index != -1, 'Index can not be -1');
    final _product = productList[index];

    //removing an item
    try {
      await firebase.FirebaseUtility().deleteFirebaseAsync(id: _product.id);
      //remove the item

      _productList.removeAt(index);
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  void clearList() {
    _productList.clear();
    notifyListeners();
  }

  ProductProvider findFirsMatching({required String productID}) {
    return _productList.firstWhere((element) => element.id == productID);
  }

  bool checkExists({required String productID}) {
    return _productList.any((element) => element.id == productID);
  }
}
