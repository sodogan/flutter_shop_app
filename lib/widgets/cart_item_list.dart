import 'package:flutter/material.dart';
import '/models/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItemList extends StatelessWidget {
  const CartItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Need to get the cart information!
    final cartProvider = Provider.of<CartProvider>(context, listen: true);

    final List<CartItem> cartItems = cartProvider.items;

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(12),
            child: Text(
              'Total',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(12),
            child: Chip(
              label: Text(
                cartProvider.totalPrice.toString(),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (cartItems.isEmpty) {
              return Container(
                child: Text('No Items in the Cart'),
              );
            } else {
              final cartItem = cartItems[index];

              return ListTile(
                leading: CircleAvatar(
                  child: Text((index + 1).toString()),
                ),
                title: Text(cartItem.title),
                subtitle: Row(
                  children: [
                    Text('Quantity:'),
                    Chip(
                      label: Text(
                        cartItem.quantity.toString(),
                      ),
                    ),
                  ],
                ),
                trailing: Chip(
                  label: Text(
                    cartItem.price.toString(),
                  ),
                ),
              );
            }
          },
          itemCount: cartItems.length,
        ),
      ),
    ]);
  }
}
