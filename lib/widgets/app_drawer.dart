import 'package:flutter/material.dart';
import '/screens/order_screen.dart';
import '/screens/manage_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          AppBar(
            title: const Text('Home'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrderScreen.route);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, ManageProductsScreen.route);
            },
          ),
        ],
      ),
    );
  }
}
