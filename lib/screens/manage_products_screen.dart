import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../models/providers/product_list_provider.dart';
import '../models/common.dart';
import '../widgets/app_drawer.dart';
import '../widgets/manage_product_item.dart';

class ManageProductsScreen extends StatefulWidget {
  static const String route = '/manage-products';

  const ManageProductsScreen({Key? key}) : super(key: key);

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  Future<void> onRefreshHandler() async {
    try {
      await Provider.of<ProductListProvider>(context, listen: false)
          .fetchNewProducts();
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
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.add,
                size: 32,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.route,
                  arguments: ModeArgs(mode: Mode.addNewProduct),
                );
              }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefreshHandler,
        child: Consumer<ProductListProvider>(
          builder: (context, productListProvider, chld) {
            return ListView.builder(
              itemCount: productListProvider.productList.length,
              itemBuilder: (context, index) {
                return ManageProductItem(
                  productListProvider: productListProvider,
                  index: index,
                );
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
