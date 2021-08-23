import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../models/providers/order_provider.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;

  const OrderItemWidget({Key? key, required this.orderItem}) : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _isExpanded = false;

  void toggleDetailOnOff() {
    print('Toggle detail');
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _dateFormatted =
        DateFormat('dd-MM-yyyy hh:mm a').format(widget.orderItem.dateTime);
    return Card(
      elevation: 6,
      child: Column(
        children: [
          Container(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    label: Text(
                      '\$${widget.orderItem.totalAmount.toString()}',
                      softWrap: true,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                _dateFormatted,
              ),
              trailing: IconButton(
                icon: _isExpanded
                    ? const Icon(Icons.expand_less)
                    : const Icon(Icons.expand_more),
                onPressed: toggleDetailOnOff,
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              height: min(widget.orderItem.cartItems.length * 30 + 10, 150),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.white12,
                Colors.white54,
                Colors.pink.shade100,
              ])),
              child: ListView.builder(
                itemBuilder: (_, index) {
                  final _cartItem = widget.orderItem.cartItems[index];
                  return Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Chip(
                            label: Text(
                              _cartItem.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.white10,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text('${(index + 1).toString()}'),
                            ),
                          ),
                          Text('${_cartItem.quantity} x \$${_cartItem.price}')
                        ]),
                  );
                },
                itemCount: widget.orderItem.cartItems.length,
              ),
            )
        ],
      ),
    );
  }
}
