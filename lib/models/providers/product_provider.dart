import 'package:flutter/cupertino.dart';
import '../../utility/firebase_utility.dart' as firebase;

mixin Favourite on BaseProduct {
  void toggleFavourite() {
    _isFavourite = !isFavourite;
  }

  bool get isFavourite => _isFavourite;
  set isFavourite(bool value) {
    _isFavourite = value;
  }
}

abstract class BaseProduct implements Comparable<ProductProvider> {
  final String _id;
  final String _title;
  final String _description;
  final double _price;
  bool _isFavourite = false;

  BaseProduct(
    this._id,
    this._title,
    this._description,
    this._price,
  );

  @override
  int compareTo(ProductProvider other) {
    return (_price - other._price).toInt();
  }

  @override
  String toString() {
    return "id: $_id"
        "title: $_title"
        "description: $_description"
        "price: $_price"
        "isFavourite: $_isFavourite";
  }

  String get id => _id;
  String get title => _title;
  String get description => _description;
  double get price => _price;
}

class ProductProvider extends BaseProduct with Favourite, ChangeNotifier {
  final String imageUrl;

  ProductProvider({
    required String id,
    required String title,
    required String description,
    required double price,
    required this.imageUrl,
  }) : super(id, title, description, price);

  ProductProvider.empty()
      : imageUrl = '',
        super('', '', '', 0.00);

//Need to update the favourite using http
  void toggleFavouriteStatus({required String id}) async {
    //optimistic update
    toggleFavourite();

    try {
      await firebase.FirebaseUtility().updateFirebaseAsync(id: id, jsonData: {
        'isFavourite': _isFavourite,
      });
    } catch (err) {
      //rollback
      toggleFavourite();
    }

    notifyListeners();
  }

  factory ProductProvider.fromJSON(Map<String, dynamic> json) {
    assert((json['id'] as String).isNotEmpty, 'ID can not be empty!');
    return ProductProvider(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'] is int ? json['price'].toDouble() : json['price'],
    );
  }

  ProductProvider copyWith(
      {String? anyID,
      String? anyTitle,
      String? anyDescription,
      double? anyPrice,
      String? anyImageUrl}) {
    return ProductProvider(
        id: anyID ?? id,
        title: anyTitle ?? title,
        description: anyDescription ?? description,
        price: anyPrice ?? price,
        imageUrl: anyImageUrl ?? imageUrl);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
      };

  @override
  String toString() {
    return super.toString() + "image URL: $imageUrl";
  }
}
