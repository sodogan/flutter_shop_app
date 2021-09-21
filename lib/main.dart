import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/manage_products_screen.dart';
import 'package:flutter_shop_app/screens/order_screen.dart';
import 'package:provider/provider.dart';
import '/screens/product_details_screen.dart';
import '/screens/product_overview_screen.dart';
import '/screens/auth_screen.dart';
import 'models/providers/product_list_provider.dart';
import 'models/providers/cart_provider.dart';
import 'models/providers/order_provider.dart';
import 'models/providers/auth_provider.dart';

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
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductListProvider>(
          create: (cntx) => ProductListProvider(),
          update: (cntx, auth, previous) {
            print('Update is called***');
            previous?.authToken = auth.idToken;
            return previous!;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderListProvider>(
          create: (cntx) => OrderListProvider(),
          update: (cntx, auth, previous) {
            print('Update is called***');
            previous?.authToken = auth.idToken;
            return previous!;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        Provider(
          create: (_) => 'Simple text message from the provider',
        ),
      ],
      child: Consumer<AuthProvider>(builder: (cntx, authprovider, child) {
        return MaterialApp(
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
            '/': (ctx) => authprovider.isAuthenticated
                ? const ProductOverviewScreen()
                : const AuthScreen(),
            ProductOverviewScreen.route: (context) =>
                const ProductOverviewScreen(),
            ProductDetailsScreen.route: (context) =>
                const ProductDetailsScreen(),
            CartScreen.route: (context) => const CartScreen(),
            OrderScreen.route: (context) => const OrderScreen(),
            ManageProductsScreen.route: (_) => const ManageProductsScreen(),
            EditProductScreen.route: (_) => const EditProductScreen(),
          },
        );
      }),
    );
  }
}
