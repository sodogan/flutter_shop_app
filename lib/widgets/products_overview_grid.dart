import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/providers/product_list_provider.dart';
import 'package:provider/provider.dart';
import 'product_item.dart';

class ProductsOverviewGrid extends StatelessWidget {
  final bool isShowOnlyFavourites;

  const ProductsOverviewGrid({Key? key, required this.isShowOnlyFavourites})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Rebuilding ProductsOverview Grid');
    //Read the list from the provider
    final productsProvider =
        Provider.of<ProductListProvider>(context, listen: false);
    final productList = isShowOnlyFavourites == true
        ? productsProvider.favouriteProductList
        : productsProvider.productList;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: productList[index],
            ),
          ],
          child: const ProductItem(),
        );
      },
      itemCount: productList.length,
    );
  }
}
