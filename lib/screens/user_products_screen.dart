import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../models/providers/product_list_provider.dart';
import '../models/common.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String route = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  /*
  @override
  initState() {
    super.initState();

    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 3), () {
      Provider.of<ProductListProvider>(context, listen: false)
          .fetchAndSetProducts(isUserBased: true);
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  
}
*/

  Future<void> _onRefreshProducts({required BuildContext context}) async {
    try {
      //Need to uncomment it out!
      await Provider.of<ProductListProvider>(context, listen: false)
          .fetchAndSetProducts(isUserBased: true);
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
        title: const Text('User Products'),
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
      body: FutureBuilder(
        future: _onRefreshProducts(context: context),
        builder: (context, asyncSnapshot) {
          return asyncSnapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _onRefreshProducts(context: context),
                  child: Consumer<ProductListProvider>(
                    builder: (context, productListProvider, chld) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: productListProvider.productList.length,
                          itemBuilder: (context, index) {
                            return UserProductItem(
                              productListProvider: productListProvider,
                              index: index,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
