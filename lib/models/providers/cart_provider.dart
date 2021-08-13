import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

abstract class BaseCart {
  void addToCart(String productID,
      {required String title,
      required String description,
      required double price});
  void removeFromCart({required int index});
  int get itemCount;
  int get totalQuantity;
  double get totalPrice;
}

class CartItem {
  final String productID;
  final String id = const Uuid().v1();
  final String title;
  final String description;
  final double price;
  int quantity = 0;

  CartItem({
    required this.productID,
    required this.title,
    required this.description,
    required this.price,
    this.quantity = 1,
  });
  double get cost => price * quantity;

  @override
  String toString() {
    return "id: $id"
        "productid: $productID"
        "title: $title"
        "description: $description"
        "price: $price"
        "quantity: $quantity";
  }
}

class CartProvider extends BaseCart with ChangeNotifier {
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

  List<CartItem> get items => [..._cartItems];

  @override
  get itemCount => _cartItems.length;

  @override
  int get totalQuantity {
    return _cartItems.isEmpty
        ? 0
        : _cartItems.fold(
            0,
            (int previousItem, CartItem currentItem) =>
                previousItem + currentItem.quantity);
  }

  @override
  double get totalPrice {
    return _cartItems.fold(
        0.0,
        (previousItem, CartItem currentItem) =>
            previousItem + currentItem.cost);
  }
}
