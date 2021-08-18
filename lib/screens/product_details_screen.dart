import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/providers/product_list_provider.dart';
import '/models/providers/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;

    final productID = args['product_id'] as String;

    final productsProvider = Provider.of<ProductListProvider>(
      context,
      listen: false,
    );

    //read the list and find the matching id
    final product = productsProvider.findFirsMatching(productID: productID);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.id),
      ),
      body: ProductDetails(
        product: product,
      ),
    );
  }
}

class ProductDetails extends StatelessWidget {
  final ProductProvider product;
  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
