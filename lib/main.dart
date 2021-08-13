import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/cart_overview_screen.dart';
import 'package:provider/provider.dart';
import '/screens/product_details_screen.dart';
import '/screens/products_overview_screen.dart';
import 'models/providers/product_list_provider.dart';
import 'models/providers/cart_provider.dart';

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
        ChangeNotifierProvider(
          create: (context) => ProductListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        Provider(
          create: (_) => 'Hello from the provider',
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
          '/': (ctx) => const ProductsOverviewScreen(),
          ProductDetailsScreen.route: (context) => const ProductDetailsScreen(),
          CartOverviewScreen.route: (context) => const CartOverviewScreen(),
        },
      ),
    );
  }
}
