import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/providers/cart_provider.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/order_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/products_overview_grid.dart';

enum FilterOptions { onlyFavourites, all }

typedef CallFilter = void Function({required bool isShowFavourites});

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isShowOnlyFavourites = false;

  void onShowFavourites(FilterOptions filterOptions) {
    if (filterOptions == FilterOptions.all) {
      setState(() => _isShowOnlyFavourites = false);
    } else {
      setState(() => _isShowOnlyFavourites = true);
    }
  }

  void onTapHandler(BuildContext context) {
    Navigator.pushNamed(
      context,
      CartScreen.route,
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
            builder: (_, CartProvider cartProvider, pChild) => Badge(
              child: pChild!,
              value: cartProvider.itemCount.toString(),
              color: Colors.indigo,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () => onTapHandler(context),
            ),
          ),
        ],
      ),
      body: ProductsOverviewGrid(
        isShowOnlyFavourites: _isShowOnlyFavourites,
      ),
      drawer: const AppDrawer(),
    );
  }
}
