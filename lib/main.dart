import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/manage_products_screen.dart';
import 'package:flutter_shop_app/screens/order_screen.dart';
import 'package:provider/provider.dart';
import '/screens/product_details_screen.dart';
import 'screens/product_overview_screen.dart';
import 'models/providers/product_list_provider.dart';
import 'models/providers/cart_provider.dart';
import 'models/providers/order_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductListProvider>(
          create: (context) => ProductListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderListProvider(),
        ),
        Provider(
          create: (_) => 'Simple text message from the provider',
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        debugShowCheckedModeBanner: false,
        //home: ProductsOverviewScreen(),
        initialRoute: '/',
        routes: {
          '/': (ctx) => const ProductOverviewScreen(),
          ProductOverviewScreen.route: (context) =>
              const ProductOverviewScreen(),
          ProductDetailsScreen.route: (context) => const ProductDetailsScreen(),
          CartScreen.route: (context) => const CartScreen(),
          OrderScreen.route: (context) => const OrderScreen(),
          ManageProductsScreen.route: (_) => const ManageProductsScreen(),
          EditProductScreen.route: (_) => const EditProductScreen(),
        },
      ),
    );
  }
}
