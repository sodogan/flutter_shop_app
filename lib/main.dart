import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/user_products_screen.dart';
import 'package:flutter_shop_app/screens/order_screen.dart';
import 'package:provider/provider.dart';
import '/screens/product_details_screen.dart';
import '/screens/product_overview_screen.dart';
import '/screens/auth_screen.dart';
import 'models/providers/product_list_provider.dart';
import 'models/providers/cart_provider.dart';
import 'models/providers/order_provider.dart';
import 'models/providers/auth_provider.dart';
import './widgets/splash_screen.dart';

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
          update: (cntx, auth, updatedProductListProvider) {
            print(
                'Main screen setting the authtoken for productlistprovider is called***');
            updatedProductListProvider?.authToken = auth.idToken;
            updatedProductListProvider?.userId = auth.userID;
            return updatedProductListProvider!;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderListProvider>(
          create: (cntx) => OrderListProvider(),
          update: (cntx, auth, updated) {
            print('Update is called***');
            updated?.authToken = auth.idToken;
            updated?.userId = auth.userID;
            return updated!;
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
                : FutureBuilder(
                    future: Future.delayed(Duration(seconds: 3),
                        () => authprovider.tryAutoLogin()),
                    builder: (context, asyncSnapshot) {
                      return asyncSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : const AuthScreen();
                    }),
            ProductOverviewScreen.route: (context) =>
                const ProductOverviewScreen(),
            ProductDetailsScreen.route: (context) =>
                const ProductDetailsScreen(),
            CartScreen.route: (context) => const CartScreen(),
            OrderScreen.route: (context) => const OrderScreen(),
            UserProductsScreen.route: (_) => const UserProductsScreen(),
            EditProductScreen.route: (_) => const EditProductScreen(),
          },
        );
      }),
    );
  }
}
