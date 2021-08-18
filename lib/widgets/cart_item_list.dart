import 'package:flutter/material.dart';
import '/models/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'cart_item_widget.dart';

class CartItemList extends StatelessWidget {
  const CartItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Need to get the cart information!
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final List<CartItem> cartItems = cartProvider.items;

    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) => CartItemWidget(
              cartItem: cartItems[index],
              index: index,
              removeFromCartdeleteHandler: cartProvider.removeFromCart,
            ),
            itemCount: cartItems.length,
          ),
        ),
      ),
    );
  }
}
