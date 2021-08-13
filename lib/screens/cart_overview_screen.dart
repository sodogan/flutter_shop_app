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
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final List<CartItem> cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Shop'),
      ),
      body: cartItems.isEmpty ? Text('No items') : CartItemList(),
    );
  }
}
