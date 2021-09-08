import 'dart:collection';

import 'package:flutter/foundation.dart';
import './cart_provider.dart';
import '../../utility/firebase_utility.dart' as firebase;

typedef AmountBuilderDef = double Function(List<CartItem>);

abstract class IOrder {
//add to the List
  void addToOrderList(
      {required List<CartItem> cartItems, AmountBuilderDef? amountBuilder});
//remove from the List
  void removeFromOrderList(int index);
//get items
  UnmodifiableListView<OrderItem> get orderList;
}

abstract class OrderItemBase {
  final String _id = DateTime.now().toString();
  final DateTime _dateTime;

  OrderItemBase(this._dateTime);

  DateTime get dateTime;

  List<CartItem> get cartItems;
}

class OrderItem extends OrderItemBase {
  final List<CartItem> _cartItems;
  final double totalAmount;

  OrderItem(this._cartItems, {required this.totalAmount})
      : assert(_cartItems.isNotEmpty, 'List can not be empty'),
        assert(totalAmount > 0, 'O amount can not be order'),
        super(
          DateTime.now(),
        );

  List<Map<String, dynamic>> toJson() {
    final result = cartItems.map((item) {
      return item.toJson();
    }).toList();

    return result;
  }

  @override
  List<CartItem> get cartItems => [..._cartItems];

  @override
  DateTime get dateTime => _dateTime;
}

class OrderListProvider with ChangeNotifier implements IOrder {
  List<OrderItem> _orderList = [];
  final Function defaultBuilder = (items) => items.fold(
      0.00, (previousValue, item) => (previousValue as double) + item.price);

  List<List<Map<String, dynamic>>> toJson() {
    final result = _orderList.map((OrderItem item) {
      return item.toJson();
    }).toList();

    return result;
  }

//add to the List
  @override
  Future<void> addToOrderList(
      {required List<CartItem> cartItems,
      AmountBuilderDef? amountBuilder}) async {
    assert(cartItems.isNotEmpty, 'Cart should not be empty');

    final _builder = amountBuilder ?? defaultBuilder;

    final _totalAmount = _builder(cartItems);

    //
    try {
      await firebase.FirebaseUtility()
          .orderFirebaseAsyncPost(orderListProvider: this);
      _orderList.add(
        OrderItem(cartItems, totalAmount: _totalAmount),
      );
    } catch (err) {
      rethrow;
    }

    notifyListeners();
  }

//remove from the List
  @override
  void removeFromOrderList(int index) {
    assert(index >= 0, 'Index must be 0 or more');
    _orderList.removeAt(index);
    notifyListeners();
  }

  @override
  UnmodifiableListView<OrderItem> get orderList =>
      UnmodifiableListView(_orderList);
}
