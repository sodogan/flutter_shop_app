import './providers/product_provider.dart';

//The screen has two modes-either Add new product mode or edit product mode
enum Mode {
  addNewProduct,
  editProduct,
}

class ModeArgs {
  final Mode mode;
  final ProductProvider? product;

  ModeArgs({required this.mode, this.product});
}

const Map<String, Mode> _addModeArgs = {
  'mode': Mode.addNewProduct,
};
