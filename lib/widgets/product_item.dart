import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/providers/product_provider.dart';
import '../models/providers/cart_provider.dart';
import '/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  void onTapHandler(BuildContext context, String productID) {
    final args = {'product_id': productID};
    Navigator.pushNamed(
      context,
      ProductDetailsScreen.route,
      arguments: args,
    );
  }

//Add to the Cart
  void addToCartHandler(CartProvider cartProvider,
      ProductProvider productProvider, BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Added to the Cart'),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          cartProvider.undoAddToCart(productProvider.id);
        },
      ),
    );

    cartProvider.addToCart(productProvider.id,
        title: productProvider.title,
        description: productProvider.description,
        price: productProvider.price);

//Hide the current snackbar!
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<ProductProvider>(
            builder: (context, productProvider, child) => IconButton(
              icon: productProvider.isFavourite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              onPressed: () =>
                  productProvider.toggleFavouriteStatus(id: productProvider.id),
              color: Theme.of(context).accentColor,
            ),
          ),
          backgroundColor: Colors.black54.withOpacity(0.3),
          title: Text(
            productProvider.title,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<CartProvider>(
            builder: (context, cartProvider, child) => IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () => addToCartHandler(
                cartProvider,
                productProvider,
                context,
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => onTapHandler(context, productProvider.id),
          child: Image.network(
            productProvider.imageUrl,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
