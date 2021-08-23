import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/order_item_widget.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../models/providers/order_provider.dart' as order;

class OrderScreen extends StatelessWidget {
  static const String route = '/orders';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderListProvider =
        Provider.of<order.OrderListProvider>(context, listen: false);
    final list = orderListProvider.orderList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: list.isEmpty
          ? Column(children: [
              Card(
                  elevation: 6,
                  margin: const EdgeInsets.all(12),
                  child: Text(
                    'No Orders yet',
                    style: const TextStyle(fontSize: 18),
                  )),
            ])
          : ListView.builder(
              itemBuilder: (context, index) {
                return OrderItemWidget(
                  orderItem: list[index],
                );
              },
              itemCount: list.length,
            ),
      drawer: const AppDrawer(),
    );
  }
}
