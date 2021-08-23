import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/providers/product_list_provider.dart';
import '/models/providers/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String route = '/details';

  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;

    final productID = args['product_id'] as String;

    assert(productID.isNotEmpty, 'product ID can not be null or empty');

    final productsProvider = Provider.of<ProductListProvider>(
      context,
      listen: false,
    );

    //read the list and find the matching id
    final product = productsProvider.findFirsMatching(productID: productID);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              height: 300,
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            product.title,
            style: const TextStyle(fontSize: 18),
            softWrap: true,
          ),
          Text(
            product.description,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).primaryColor,
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text('\$${product.price.toString()}',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).primaryTextTheme.title),
            ),
          ),
        ],
      ),
    );
  }
}
