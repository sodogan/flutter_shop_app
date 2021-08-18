import 'package:flutter/material.dart';
import '/models/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item_list.dart';

class CartOverviewScreen extends StatelessWidget {
  static const String route = '/cart';

  const CartOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Need to get the cart information!
    final cartProvider = Provider.of<CartProvider>(context, listen: true);

    final List<CartItem> cartItems = cartProvider.items;

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
                      label: Text('\$ ${cartProvider.totalAmount}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .title
                                  ?.color)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    if (cartProvider.totalAmount > 0)
                      TextButton(
                        onPressed: () {},
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
            const CartItemList(),
          ],
        ));
  }
}
