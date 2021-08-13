import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/providers/cart_provider.dart';
import 'package:flutter_shop_app/screens/cart_overview_screen.dart';
import 'package:flutter_shop_app/widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/products_overview_grid.dart';

enum FilterOptions { onlyFavourites, all }

typedef CallFilter = void Function({required bool isShowFavourites});

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _isShowOnlyFavourites = false;

  void onShowFavourites(FilterOptions filterOptions) {
    if (filterOptions == FilterOptions.all) {
      setState(() => _isShowOnlyFavourites = false);
    } else {
      setState(() => _isShowOnlyFavourites = true);
    }
  }

  void onTapHandler(BuildContext context) {
    //final args = {'product_id': productID};
    Navigator.pushNamed(
      context,
      CartOverviewScreen.route,
      //arguments: args,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuilding ProductsOverview Screen');

    List<PopupMenuEntry<FilterOptions>> Function(BuildContext) builder =
        (context) => [
              const PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.onlyFavourites,
              ),
              const PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.all,
              ),
            ];
    return Scaffold(
        appBar: AppBar(
          title: const Text('E-Shop'),
          actions: [
            PopupMenuButton(
              onSelected: onShowFavourites,
              icon: const Icon(Icons.more_vert),
              itemBuilder: builder,
            ),
            Consumer<CartProvider>(
              builder: (context, CartProvider cartProvider, ch) => Badge(
                child: ch!,
                value: cartProvider.itemCount.toString(),
                color: Colors.indigo,
              ),
              child: GestureDetector(
                onTap: () => onTapHandler(context),
                child: const Icon(
                  Icons.shopping_cart,
                ),
              ),
            ),
          ],
        ),
        body: ProductsOverviewGrid(
          isShowOnlyFavourites: _isShowOnlyFavourites,
        ));
  }
}
