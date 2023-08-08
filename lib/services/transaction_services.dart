// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../models/api_response.dart';
import '../models/transaction.dart';
import 'user_services.dart';

Future<ApiResponse> getTransactionToday() async {
  ApiResponse apiResponse = ApiResponse();
  List<Transaction> transactionList = [];
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(transactionTodayURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    // for debug in console
    // print(json.decode(response.body));

    switch (response.statusCode) {
      case 200:
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

Future<ApiResponse> getTransactionWeek() async {
  ApiResponse apiResponse = ApiResponse();
  List<Transaction> transactionList = [];
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(transactionWeekURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    // for debug in console
    // print(json.decode(response.body));

    switch (response.statusCode) {
      case 200:
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

Future<ApiResponse> getTransactionMonth() async {
  ApiResponse apiResponse = ApiResponse();
  List<Transaction> transactionList = [];
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(transactionMonthURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    // for debug in console
    // print(json.decode(response.body));

    switch (response.statusCode) {
      case 200:
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

Future<ApiResponse> getTransactionYear() async {
  ApiResponse apiResponse = ApiResponse();
  List<Transaction> transactionList = [];
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(transactionYearURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    // for debug in console
    // print(json.decode(response.body));

    switch (response.statusCode) {
      case 200:
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

Future<ApiResponse> addTransaction(
  String customerName,
  int totalItems,
  int totalPrice,
  int cash,
  int change,
  int finalPrice,
  List<TransactionDetail> transactionDetails,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(transactionURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'name': customerName,
        'total_items': totalItems.toString(),
        'total_price': totalPrice.toString(),
        'cash': cash.toString(),
        'change': change.toString(),
        'final_price': finalPrice.toString(),
        // Save the transaction details as JSON array
        'transaction_details': jsonEncode(
          transactionDetails.map((detail) => detail.toJson()).toList(),
        ),
      },
    );
    // print(response.body);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.errors![errors.keys.elementAt(0)] = [
          errors.values.elementAt(0)[0]
        ];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print('error: $e');
    print(apiResponse.error);
  }

  return apiResponse;
}

Future<ApiResponse> getLaporan() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(getTotalURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print(response.body);
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

Future<ApiResponse> getLaporanByDate({
  required DateTime startDate,
  required DateTime endDate,
}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(transactionByDateURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      }),
    );

    print(response.body);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body));
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
