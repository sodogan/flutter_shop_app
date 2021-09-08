import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/providers/product_list_provider.dart';
import 'package:provider/provider.dart';
import '../models/common.dart';
import '../models/providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String route = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _priceFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();

  final _imageURLController = TextEditingController();

  ProductProvider _currentProduct = ProductProvider.empty();
  Mode _mode = Mode.addNewProduct;

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageURLFocusNode.addListener(updateImageURL);
  }

  void updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _imageURLFocusNode.removeListener(updateImageURL);
    _imageURLFocusNode.dispose();
    _imageURLController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final _arguments = ModalRoute.of(context)?.settings.arguments as ModeArgs;
      //need to set the Moe here somehow
      _mode = _arguments.mode;
      if (_mode == Mode.editProduct) {
        _currentProduct = _arguments.product!;
        _imageURLController.text = _currentProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  void saveForm() async {
    final _productListprovider =
        Provider.of<ProductListProvider>(context, listen: false);

    print('Save button is pressed $_currentProduct');
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
      });

      try {
        if (_mode == Mode.addNewProduct) {
          await _productListprovider.addProduct(
            title: _currentProduct.title,
            description: _currentProduct.description,
            imageUrl: _currentProduct.description,
            price: _currentProduct.price,
          );
        } else {
          await _productListprovider.updateExistingProduct(
              id: _currentProduct.id,
              title: _currentProduct.title,
              description: _currentProduct.description,
              imageUrl: _currentProduct.imageUrl,
              price: _currentProduct.price);
        }
      } catch (err) {
        //how do we handle errors here!
        //  ScaffoldMessenger.of(context)
        //      .showSnackBar(SnackBar(content: Text(err.toString())));
        await showDialog(
            context: context,
            builder: (context) {
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
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

//validator-returns Null if its valid!
  String? validator(String? input,
      {required Function errorFunction, bool isNumber = false}) {
    if (input!.isEmpty) {
      return errorFunction();
    }
    if (isNumber) {
      final _parsed = double.tryParse(input);
      if (_parsed == null || _parsed <= 0) {
        return 'Please integers above 0 only!';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _mode == Mode.editProduct
            ? const Text('Edit Product')
            : const Text('Add New Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveForm,
          ),
        ],
      ),
      body: _isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _currentProduct.title,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                          hintText: 'Enter a title',
                        ),
                        onFieldSubmitted: (title) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (title) {
                          //modify the product
                          _currentProduct = ProductProvider(
                            id: _currentProduct.id,
                            title: title!,
                            description: _currentProduct.description,
                            price: _currentProduct.price,
                            imageUrl: _currentProduct.imageUrl,
                          );
                          print('$title->> :$_currentProduct');
                        },
                        validator: (val) => validator(val,
                            errorFunction: () => 'Please provide a title'),
                      ),
                      const Divider(),
                      TextFormField(
                        initialValue: _currentProduct.price.toString(),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Price',
                          hintText: '\$0.0',
                        ),
                        focusNode: _priceFocusNode,
                        validator: (val) => validator(val,
                            errorFunction: () => 'Please provide a price',
                            isNumber: true),
                        onSaved: (price) {
                          //parse the price
                          final priceParsed = double.tryParse(price!);
                          assert(priceParsed != null);
                          //modify the product
                          _currentProduct = ProductProvider(
                            id: _currentProduct.id,
                            title: _currentProduct.title,
                            description: _currentProduct.description,
                            price: priceParsed!,
                            imageUrl: _currentProduct.imageUrl,
                          );
                        },
                      ),
                      const Divider(),
                      TextFormField(
                        initialValue: _currentProduct.description,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                          hintText: 'Enter a desc',
                        ),
                        validator: (val) => validator(val,
                            errorFunction: () =>
                                'Please provide a description'),
                        onSaved: (description) {
                          //Parse the price
                          //modify the product
                          _currentProduct = ProductProvider(
                            id: _currentProduct.id,
                            title: _currentProduct.title,
                            description: description!,
                            price: _currentProduct.price,
                            imageUrl: _currentProduct.imageUrl,
                          );
                        },
                      ),
                      const Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                color: Colors.white24,
                              ),
                              child: _imageURLController.text.isEmpty
                                  ? const Text('Image Preview')
                                  : FittedBox(
                                      fit: BoxFit.cover,
                                      child: Image.network(
                                          _imageURLController.text),
                                    ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              //initialValue: _currentProduct.imageUrl,
                              maxLines: 3,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: 'Image URL',
                              ),
                              controller: _imageURLController,
                              focusNode: _imageURLFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onSaved: (imageUrl) {
                                //Parse the price
                                //modify the product
                                _currentProduct = ProductProvider(
                                  id: _currentProduct.id,
                                  title: _currentProduct.title,
                                  description: _currentProduct.description,
                                  price: _currentProduct.price,
                                  imageUrl: imageUrl!,
                                );
                              },
                              onFieldSubmitted: (url) {
                                saveForm();
                              },

                              validator: (val) => validator(val,
                                  errorFunction: () =>
                                      'Please provide a URL string'),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
