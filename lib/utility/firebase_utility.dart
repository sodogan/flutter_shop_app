import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/providers/order_provider.dart';
import 'http_exception.dart';

class FirebaseUtility {
  static const fireBaseURL = 'flutter-eshop-c6583-default-rtdb.firebaseio.com';
  static const fireBaseProductsJsonPath = 'products.json';
  static const fireBaseOrdersJsonPath = 'orders.json';
  static const fireBaseProductsCollection = 'products';

  //POST
  Future<Map<String, dynamic>> fetchAllFirebaseAsync({
    String baseUrl = fireBaseURL,
    String? jsonPath = fireBaseProductsJsonPath,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$jsonPath');

    print('Sending a GET request at $_url');

    final response = await http.get(_url);

    //İn firebase if no data response.body return "null"
    //This will be-if there is no data then needs to throw exception too
    if (response.statusCode == 200 && response.body != "null") {
      return jsonDecode(response.body);
    } else if (response.statusCode == 200 && response.body == "null") {
      throw HttpException(
        requestType: RequestType.get,
        message: 'No data is found in  ${jsonPath}',
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
    required OrderListProvider orderListProvider,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$jsonPath');

    print('Sending a POST request at $_url');
    final response =
        await http.post(_url, body: jsonEncode(orderListProvider.toJson()));

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
}
