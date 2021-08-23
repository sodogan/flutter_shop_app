import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import './cart_provider.dart';

abstract class OrderItemBase {
  final String _id = const Uuid().v1();
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

  @override
  List<CartItem> get cartItems => [..._cartItems];

  @override
  DateTime get dateTime => _dateTime;
}

abstract class IOrder {
//add to the List
  void addToOrderList(List<CartItem> list, double total);
//remove from the List
  void removeFromOrderList(int index);
//get items
  UnmodifiableListView<OrderItem> get orderList;
}

class OrderListProvider with ChangeNotifier implements IOrder {
  List<OrderItem> _orderList = [];

//add to the List
  @override
  void addToOrderList(List<CartItem> items, double total) {
    assert(
        total > 0 && items.isNotEmpty, 'Total Amount has to be greater then 0');

    _orderList.add(
      OrderItem(items, totalAmount: total),
    );

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
