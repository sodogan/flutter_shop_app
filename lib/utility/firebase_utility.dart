import 'package:flutter_shop_app/models/providers/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'http_exception.dart';

class FirebaseUtility {
  static const fireBaseURL = 'flutter-eshop-c6583-default-rtdb.firebaseio.com';
  static const productsFireBaseURL =
      'https://flutter-eshop-c6583-default-rtdb.firebaseio.com/products.json';
  static const ordersFireBaseURL =
      'https://flutter-eshop-c6583-default-rtdb.firebaseio.com/orders.json';
  static const fireBaseProductsJsonPath = 'products.json';
  static const fireBaseOrdersJsonPath = 'orders.json';
  static const fireBaseProductsCollection = 'products';

  //GET all the products
  Future<Map<String, dynamic>> fetchAllProductsFirebaseAsync(
      {String baseUrl = productsFireBaseURL, required String idToken}) async {
    final Uri _url = Uri.parse('$baseUrl?auth=$idToken');

    print('Sending a GET request at $_url');

    final response = await http.get(_url);

    //İn firebase if no data response.body return "null"
    //This will be-if there is no data then needs to throw exception too
    if (response.statusCode == 200 && response.body != "null") {
      return jsonDecode(response.body);
    } else if (response.statusCode == 200 && response.body == "null") {
      throw HttpException(
        requestType: RequestType.get,
        message: 'No data is found in  ${baseUrl}',
        stackTrace: StackTrace.fromString(
          response.statusCode.toString(),
        ),
      );
    } else {
      //return Future.error(
      //    "This is the error", StackTrace.fromString("This is its trace"));
      throw HttpException(
        requestType: RequestType.get,
        message: 'Failed with ${response.statusCode}',
        stackTrace: StackTrace.fromString(
          'Ensure the path is correct',
        ),
      );
    }
  }

  //GET all the products
  Future<Map<String, dynamic>> fetchAllOrdersFirebaseAsync({
    String baseUrl = ordersFireBaseURL,
    required String idToken,
  }) async {
    final Uri _url = Uri.parse('$baseUrl?auth=$idToken');

    print('Sending a GET request at $_url');

    final response = await http.get(_url);

    //İn firebase if no data response.body return "null"
    //This will be-if there is no data then needs to throw exception too
    if (response.statusCode == 200 && response.body != "null") {
      return jsonDecode(response.body);
    } else if (response.statusCode == 200 && response.body == "null") {
      throw HttpException(
        requestType: RequestType.get,
        message: 'No data is found in',
        stackTrace: StackTrace.fromString(
          response.statusCode.toString(),
        ),
      );
    } else {
      //return Future.error(
      //    "This is the error", StackTrace.fromString("This is its trace"));
      throw HttpException(
        requestType: RequestType.get,
        message: 'Failed with ${response.statusCode}',
        stackTrace: StackTrace.fromString(
          'Ensure the path is correct',
        ),
      );
    }
  }

  //POST
  Future<String> productFirebaseAsyncPost({
    String baseUrl = fireBaseURL,
    String? jsonPath = fireBaseProductsJsonPath,
    required Map<String, dynamic> jsonData,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$jsonPath');

    print('Sending a POST request at $_url');

    final response = await http.post(_url, body: jsonEncode(jsonData));

    //This will be
    if (response.statusCode == 200) {
      var _decoded = jsonDecode(response.body);
      final String id = _decoded['name'];
      return id;
    } else {
      //return Future.error(
      //    "This is the error", StackTrace.fromString("This is its trace"));
      throw HttpException(
        requestType: RequestType.post,
        message: 'Failed with ${response.statusCode}',
        stackTrace: StackTrace.fromString(
          'Ensure the path is correct',
        ),
      );
    }
  }

//POST
  Future<String> orderFirebaseAsyncPost({
    String baseUrl = fireBaseURL,
    String? jsonPath = fireBaseOrdersJsonPath,
    required List<CartItem> cartItems,
    required double totalAmount,
    required DateTime dateTime,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$jsonPath');

    print('Sending a POST request at $_url');

    final _newOrderJson = {
      'totalAmount': totalAmount,
      'dateTime': dateTime.toIso8601String(),
      'products': cartItems.map((item) {
        return {
          'productID': item.productID,
          'title': item.title,
          'description': item.description,
          'price': item.price,
        };
      }).toList()
    };
    print(_newOrderJson);

    final response = await http.post(_url, body: jsonEncode(_newOrderJson));

    //This will be
    if (response.statusCode == 200) {
      var _decoded = jsonDecode(response.body);
      final String id = _decoded['name'];
      print(id);
      return id;
    } else {
      throw HttpException(
        requestType: RequestType.post,
        message: 'Failed with exception}',
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    }
  }

//PATCH
  Future<dynamic> updateFirebaseAsync({
    String baseUrl = fireBaseURL,
    String? baseCollection = fireBaseProductsCollection,
    required String id,
    required Map<String, dynamic> jsonData,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$baseCollection/$id.json');

    print('Sending a PATCH request at $_url');
    final response = await http.patch(_url, body: jsonEncode(jsonData));

    //This will be
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(result);
      return result;
    } else {
      throw HttpException(
        requestType: RequestType.patch,
        message: 'Failed with exception}',
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    }
  }

//PATCH
  Future<dynamic> deleteFirebaseAsync({
    String baseUrl = fireBaseURL,
    String? baseCollection = fireBaseProductsCollection,
    required String id,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$baseCollection/$id.json');

    print('Sending a DELETE request at $_url');
    final response = await http.delete(_url);

    //This will be
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result;
    } else {
      throw HttpException(
        requestType: RequestType.delete,
        message: 'Failed with exception}',
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    }
  }

//SIGNUP
  Future<Map<String, dynamic>> signUpUser(
      {required String emailAddress, required String password}) async {
    const _apiKey = 'AIzaSyAw5wSKdN7afzcdUvBh8_HucVoU_CgLFBo';
    final _url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey');

    //Now do a POST to the firebase.
    final _json = jsonEncode({
      'email': emailAddress,
      'password': password,
      'returnSecureToken': true
    });

    final response = await http.post(_url, body: _json);
    final _decoded = jsonDecode(response.body);

//This will be
    if (response.statusCode == 200) {
      return _decoded;
    } else if (response.statusCode == 400 && _decoded['error'] != null) {
      final String _error_code = _decoded['error']['message'];
      String _error_msg;
      if (_error_code.contains('EMAIL_EXISTS')) {
        _error_msg = 'This email address already exists';
      } else if (_error_code.contains('INVALID_EMAIL')) {
        _error_msg = 'Invalid email address';
      } else if (_error_code.contains('WEAK_PASSWORD')) {
        _error_msg = 'Weak password';
      } else if (_error_code.contains('INVALID_PASSWORD')) {
        _error_msg = 'Invalid password';
      } else if (_error_code.contains('EMAIL_NOT_FOUND')) {
        _error_msg = 'Email not found';
      } else {
        _error_msg = 'Unknown error';
      }
      throw HttpException(
        requestType: RequestType.post,
        message: _error_msg,
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    } else {
      throw HttpException(
        requestType: RequestType.post,
        message: 'Failed with exception}',
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    }
  }

//SIGNIN
  Future<Map<String, dynamic>> signInUser(
      {required String emailAddress, required String password}) async {
    const _apiKey = 'AIzaSyAw5wSKdN7afzcdUvBh8_HucVoU_CgLFBo';
    final _url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey');

    //Now do a POST to the firebase.
    final _json = jsonEncode({
      'email': emailAddress,
      'password': password,
      'returnSecureToken': true
    });

    final response = await http.post(_url, body: _json);

//This will be
    final _decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return _decoded;
    } else if (response.statusCode == 400 && _decoded['error'] != null) {
      final String _error_code = _decoded['error']['message'];
      String _error_msg;
      if (_error_code.contains('EMAIL_EXISTS')) {
        _error_msg = 'This email address already exists';
      } else if (_error_code.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        _error_msg = 'Too many attemps please try later';
      } else if (_error_code.contains('INVALID_PASSWORD')) {
        _error_msg = 'Wrong password';
      } else {
        _error_msg = 'Unknown error';
      }

      throw HttpException(
        requestType: RequestType.post,
        message: _error_msg,
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    } else {
      throw HttpException(
        requestType: RequestType.post,
        message: 'Failed with exception}',
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    }
  }
}
