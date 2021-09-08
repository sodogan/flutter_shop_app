import 'package:flutter/material.dart';
import '../models/providers/product_list_provider.dart';
import '../models/common.dart';
import '../screens/edit_product_screen.dart';

class ManageProductItem extends StatefulWidget {
  final ProductListProvider productListProvider;
  final int index;

  const ManageProductItem({
    Key? key,
    required this.productListProvider,
    required this.index,
  }) : super(key: key);

  @override
  State<ManageProductItem> createState() => _ManageProductItemState();
}

class _ManageProductItemState extends State<ManageProductItem> {
  bool _isDeleting = false;

  void onDeleteHandler(BuildContext context, int index) async {
    try {
      setState(() {
        _isDeleting = true;
      });
      await widget.productListProvider.removeProduct(index: index);
      setState(() {
        _isDeleting = false;
      });
    } catch (err) {
      //show alert dialog
      await showDialog(
          context: context,
          builder: (cntx) {
            return AlertDialog(
              title: const Text('Smth went wrong'),
              content: Text(err.toString()),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('index is ${widget.index}');
    final product =
        widget.productListProvider.productList.toList()[widget.index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                product.imageUrl,
              ),
            ),
            title: Text(product.title),
            trailing: Container(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          EditProductScreen.route,
                          arguments: ModeArgs(
                              mode: Mode.editProduct, product: product),
                        );
                      }),
                  _isDeleting
                      ? const CircularProgressIndicator()
                      : IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              onDeleteHandler(context, widget.index)),
                ],
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
