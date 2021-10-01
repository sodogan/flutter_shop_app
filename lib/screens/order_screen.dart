import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/order_item_widget.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../models/providers/order_provider.dart' as order;

class OrderScreen extends StatefulWidget {
  static const String route = '/orders';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;

//  Future getOrderData =

  @override
  void initState() {
    super.initState();

    //try to load all the orders from the URL
    Future.delayed(Duration.zero, () async {
      setState(() {
        _isLoading = true;
      });
      final _orderListProvider =
          Provider.of<order.OrderListProvider>(context, listen: false);

      try {
        _orderListProvider.fetchAllOrders().then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (err) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<order.OrderListProvider>(
              builder: (cntx, orderListProvider, child) {
                final list = orderListProvider.orderList;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return OrderItemWidget(
                      orderItem: list[index],
                    );
                  },
                  itemCount: list.length,
                );
              },
            ),
      drawer: const AppDrawer(),
    );
  }
}
