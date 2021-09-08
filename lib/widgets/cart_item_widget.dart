import 'package:flutter/material.dart';
import '../models/providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final RemoveFromCartFunc removeFromCartDeleteHandler;
  final int index;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
    required this.removeFromCartDeleteHandler,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) => removeFromCartDeleteHandler(index: index),
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
      ),
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  '\$${cartItem.price.toString()}',
                ),
              ),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Row(
            children: [
              const Text('Quantity:'),
              Chip(
                label: Text(
                  '${cartItem.quantity.toString()}x',
                ),
              ),
            ],
          ),
          trailing: FittedBox(
            fit: BoxFit.scaleDown,
            child: Chip(
              label: Text(
                '\$${cartItem.cost.toString()}',
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
      ),
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (cntx) {
            return AlertDialog(
              title: const Text(
                'Are you sure?',
              ),
              content: const Text(
                'Do you want to remove the item from the cart?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(cntx).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(cntx).pop(true),
                  child: const Text('Yes'),
                )
              ],
            );
          },
        );
      },
    );
  }
}
