import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

typedef AddToCartFunc = void Function(
  String productID, {
  required String title,
  required String description,
  required double price,
});

typedef RemoveFromCartFunc = void Function({required int index});

typedef CostBuilderFunc = double Function(double, int);

mixin builder {
  CostBuilderFunc? defaultCostBuilder =
      (priceVal, quantityVal) => priceVal * quantityVal;
}

abstract class CartItemBase with builder implements Comparable<CartItemBase> {
  final String _id = const Uuid().v1();
  final String _title;
  final String _description;
  final double _price;
  int quantity;
  CostBuilderFunc? costBuilder;

  CartItemBase(
    this._title,
    this._description,
    this._price, [
    this.quantity = 1,
  ]) {
    this.costBuilder = costBuilder ?? defaultCostBuilder;
  }

  String get id => _id;
  String get title => _title;
  String get description => _description;
  double get price => _price;

  double get cost;

  @override
  String toString() {
    return "id: $_id"
        "title: $_title"
        "description: $_description"
        "price: $_price";
  }
}

class CartItem extends CartItemBase {
  final String productID;

  CartItem({
    required this.productID,
    required String title,
    required String description,
    required double price,
  }) : super(title, description, price, 1);

  @override
  double get cost => costBuilder!(price, quantity);

  @override
  String toString() {
    return super.toString() + "product ID: $productID" + "quantity: $quantity";
  }

  @override
  int compareTo(CartItemBase other) {
    return (_price - other._price).toInt();
  }
}

abstract class CartBase {
  void addToCart(String productID,
      {required String title,
      required String description,
      required double price});
  void removeFromCart({required int index});
  void clearCart();
  int get itemCount;
  double get totalAmount;
}

class CartProvider extends CartBase with ChangeNotifier {
  List<CartItem> _cartItems = [];

//add to Cart
  @override
  void addToCart(String productID,
      {required String title,
      required String description,
      required double price}) {
    print('Trying to add $title');
    final item = _cartItems.firstWhereOrNull((CartItem item) {
      return item.productID == productID;
    });
    if (item == null) {
      _cartItems.add(
        CartItem(
            productID: productID,
            title: title,
            description: description,
            price: price),
      );
    } else {
      item.quantity = item.quantity + 1;
    }

    notifyListeners();
  }

//remove from Cart
  @override
  void removeFromCart({required int index}) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

//Clear the Cart
  @override
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  List<CartItem> get items => [..._cartItems];

  @override
  get itemCount => _cartItems.length;

  @override
  double get totalAmount {
    return _cartItems.fold(
        0.0,
        (previousItem, CartItem currentItem) =>
            previousItem + currentItem.cost);
  }
}
