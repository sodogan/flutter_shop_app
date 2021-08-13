import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

mixin Favourite on BaseProduct {
  bool _isFavourite = false;
  void toggleFavouriteStatus();
}

abstract class BaseProduct implements Comparable<ProductProvider> {
  final String _id = const Uuid().v1();
  final String _title;
  final String _description;
  final double _price;

  BaseProduct(this._title, this._description, this._price);
  @override
  int compareTo(ProductProvider other) {
    return (_price - other._price).toInt();
  }

  @override
  String toString() {
    return "id: $_id"
        "title: $_title"
        "description: $_description"
        "isFavourite: $isFavourite"
        "price: $_price";
  }

  bool get isFavourite;

  String get id => _id;
  String get title => _title;
  String get description => _description;
  double get price => _price;
}

class ProductProvider extends BaseProduct with Favourite, ChangeNotifier {
  final String imageUrl;

  ProductProvider({
    required String title,
    required String description,
    required double price,
    required this.imageUrl,
  }) : super(title, description, price);

  @override
  void toggleFavouriteStatus() {
    this._isFavourite = !this._isFavourite;
    notifyListeners();
  }

  @override
  bool get isFavourite => this._isFavourite;

  factory ProductProvider.fromJSON(Map<String, dynamic> json) {
    return ProductProvider(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'] is int ? json['price'].toDouble() : json['price'],
    );
  }

  @override
  String toString() {
    return super.toString() + "image URL: $imageUrl";
  }
}
