// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:pos_kasir/constant.dart';
import 'package:pos_kasir/models/api_response.dart';
import 'package:pos_kasir/services/user_services.dart';
import 'package:http_parser/http_parser.dart';

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

Future<ApiResponse> addProductWithImage(
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

    var request = http.MultipartRequest('POST', Uri.parse(productURL));
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // Add product data
    request.fields['name'] = name;
    request.fields['category'] = category.toString();
    request.fields['desc'] = desc;
    request.fields['priceBuy'] = priceBuy.toString();
    request.fields['priceSell'] = priceSell.toString();
    request.fields['stock'] = stock.toString();
    request.fields['barcode'] = barcode;

    // Add image file
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      image,
      contentType:
          MediaType('image', 'jpeg'), // Adjust the content type as needed
    ));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    // Process the response
    if (response.statusCode == 200) {
      apiResponse.data = jsonDecode(responseBody);
    } else if (response.statusCode == 422) {
      final errors = jsonDecode(responseBody)['errors'];
      apiResponse.error = errors[errors.keys.elementAt(0)][0];
    } else if (response.statusCode == 401) {
      apiResponse.error = unauthorized;
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    print(e.toString());
  }

  return apiResponse;
}

Future<ApiResponse> updateProductWithImage(
  int productId,
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

    var request =
        http.MultipartRequest('POST', Uri.parse('$editProductURL/$productId'));
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // Add product data
    request.fields['name'] = name;
    request.fields['category'] = category.toString();
    request.fields['desc'] = desc;
    request.fields['priceBuy'] = priceBuy.toString();
    request.fields['priceSell'] = priceSell.toString();
    request.fields['stock'] = stock.toString();
    request.fields['barcode'] = barcode;

    // Add image file (only if the image is not empty)
    if (image.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image,
        contentType:
            MediaType('image', 'jpeg'), // Adjust the content type as needed
      ));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    // print(responseBody);

    // Process the response
    if (response.statusCode == 200) {
      apiResponse.data = jsonDecode(responseBody);
    } else if (response.statusCode == 422) {
      final errors = jsonDecode(responseBody)['errors'];
      apiResponse.error = errors[errors.keys.elementAt(0)][0];
      print(apiResponse.error);
    } else if (response.statusCode == 401) {
      apiResponse.error = unauthorized;
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    print(e.toString());
  }

  return apiResponse;
}

Future<ApiResponse> updateProductWithoutImage(
  int productId,
  String name,
  int category,
  String desc,
  int priceBuy,
  int priceSell,
  int stock,
  String barcode,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();

    var request =
        http.MultipartRequest('POST', Uri.parse('$editProductURL/$productId'));
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      // '_method': 'PUT',
    });

    // Add product data
    request.fields['name'] = name;
    request.fields['category'] = category.toString();
    request.fields['desc'] = desc;
    request.fields['priceBuy'] = priceBuy.toString();
    request.fields['priceSell'] = priceSell.toString();
    request.fields['stock'] = stock.toString();
    request.fields['barcode'] = barcode;

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    // print(request.fields['name']);
    // print(response.statusCode);

    // Process the response
    if (response.statusCode == 200) {
      apiResponse.data = jsonDecode(responseBody);
    } else if (response.statusCode == 422) {
      final errors = jsonDecode(responseBody)['errors'];
      apiResponse.error = errors[errors.keys.elementAt(0)][0];
    } else if (response.statusCode == 401) {
      apiResponse.error = unauthorized;
    } else {
      apiResponse.error = somethingWentWrong;
      print(apiResponse.error);
    }
  } catch (e) {
    print(e.toString());
  }

  return apiResponse;
}

Future<ApiResponse> deleteProduct(int productId) async {
  // print('Product ID to be deleted: $productId');
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
        print(apiResponse.error);
        break;
    }
  } catch (e) {
    print(e);
    apiResponse.error = serverError;
  }

  return apiResponse;
}
