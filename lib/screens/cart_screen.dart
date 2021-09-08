import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../models/providers/order_provider.dart';
import '/screens/order_screen.dart';
import '../models/providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  static const String route = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  void navigateToOrderScreen(
    BuildContext context,
    CartProvider cartProvider,
    OrderListProvider orderListProvider,
  ) async {
    //add the cartitems to the OrderList
    try {
      await orderListProvider.addToOrderList(cartItems: cartProvider.items);
      //clear the Cart
      cartProvider.clearCart();
    } catch (err) {
      //Error dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    //Need to get the cart information!
    final cartProvider = Provider.of<CartProvider>(context, listen: true);
    final List<CartItem> cartItems = cartProvider.items;

    final orderListProvider =
        Provider.of<OrderListProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(12),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                          '\$ ${cartProvider.totalAmount.toStringAsFixed(
                            2,
                          )}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .title
                                  ?.color)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    if (cartProvider.totalAmount > 0)
                      TextButton(
                        onPressed: () => navigateToOrderScreen(
                            context, cartProvider, orderListProvider),
                        child: Text(
                          'ORDER NOW',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemBuilder: (context, index) => CartItemWidget(
                      cartItem: cartItems[index],
                      index: index,
                      removeFromCartDeleteHandler: cartProvider.removeFromCart,
                    ),
                    itemCount: cartItems.length,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
