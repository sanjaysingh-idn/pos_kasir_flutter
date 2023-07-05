// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:pos_kasir/constant.dart';
import 'package:pos_kasir/models/api_response.dart';
import 'package:pos_kasir/services/user_services.dart';

import 'package:http/http.dart' as http;

Future<ApiResponse> getProduct() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(productURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    // for debug in console
    // print(json.decode(response.body));

    switch (response.statusCode) {
      case 200:
        // print(jsonDecode(response.body));
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> addProduct(
  String name,
  int category,
  String desc,
  String image,
  int priceBuy,
  int priceSell,
  int stock,
  String barcode,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(productURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'name': name,
      'category': category,
      'desc': desc,
      'image': image,
      'priceBuy': priceBuy,
      'priceSell': priceSell,
      'stock': stock,
      'barcode': barcode,
    });
    // if icon not upload then only insert name
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    // apiResponse.error = serverError;
    print(e.toString());
    // print(apiResponse.error);
  }

  return apiResponse;
}

Future<ApiResponse> deleteProduct(int productId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$productURL/$productId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}
