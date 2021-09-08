import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/providers/cart_provider.dart';
import 'package:flutter_shop_app/models/providers/product_list_provider.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/products_overview_grid.dart';

enum FilterOptions { onlyFavourites, all }

typedef CallFilter = void Function({required bool isShowFavourites});

class ProductOverviewScreen extends StatefulWidget {
  static const String route = '/overview';

  const ProductOverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isShowOnlyFavourites = false;
  bool _isInit = true;
  bool _isLoading = false;

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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('Did change dependencies called!');
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      //Fetch all the products
      Provider.of<ProductListProvider>(context).fetchAllProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((err) {
        showDialog(
            context: context,
            builder: (cntx) {
              return AlertDialog(
                title: const Text('Fetch Failed'),
                content: Text(err.toString()),
                actions: [
                  TextButton(
                    child: const Text('Okay'),
                    onPressed: () {
                      Navigator.of(cntx).pop();
                    },
                  )
                ],
              );
            });
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
  }

  void onRefreshHandler() async {
    //Fetch all the products
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ProductListProvider>(context, listen: false)
          .fetchNewProducts();

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      showDialog(
          context: context,
          builder: (cntx) {
            return AlertDialog(
              title: const Text('Fetch Failed'),
              content: Text(err.toString()),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () => Navigator.of(cntx).pop(),
                )
              ],
            );
          }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuilding ProductsOverview Screen');

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () => onRefreshHandler(),
          ),
          PopupMenuButton(
            onSelected: onShowFavourites,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.onlyFavourites,
              ),
              const PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.all,
              ),
            ],
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ProductsOverviewGrid(
              isShowOnlyFavourites: _isShowOnlyFavourites,
            ),
      drawer: const AppDrawer(),
    );
  }
}
