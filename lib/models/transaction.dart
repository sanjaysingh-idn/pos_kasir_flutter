// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

Transaction transactionFromJson(String str) =>
    Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
  List<TransactionElement> transaction;

  Transaction({
    required this.transaction,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        transaction: List<TransactionElement>.from(
            json["transaction"].map((x) => TransactionElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transaction": List<dynamic>.from(transaction.map((x) => x.toJson())),
      };
}

class TransactionElement {
  int id;
  int invoiceId;
  String? name;
  int totalItems;
  int totalPrice;
  int? discount;
  int finalPrice;
  int cash;
  int change;
  DateTime createdAt;
  DateTime updatedAt;
  List<TransactionDetail> transactionDetails;
  String getFormattedCreatedAt() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt);
  }

  TransactionElement({
    required this.id,
    required this.invoiceId,
    required this.name,
    required this.totalItems,
    required this.totalPrice,
    required this.discount,
    required this.finalPrice,
    required this.cash,
    required this.change,
    required this.createdAt,
    required this.updatedAt,
    required this.transactionDetails,
  });

  factory TransactionElement.fromJson(Map<String, dynamic> json) =>
      TransactionElement(
        id: json["id"],
        invoiceId: json["invoice_id"],
        name: json["name"],
        totalItems: json["total_items"],
        totalPrice: json["total_price"],
        discount: json["discount"],
        finalPrice: json["final_price"],
        cash: json["cash"],
        change: json["change"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        transactionDetails: List<TransactionDetail>.from(
            json["transaction_details"]
                .map((x) => TransactionDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_id": invoiceId,
        "name": name,
        "total_items": totalItems,
        "total_price": totalPrice,
        "discount": discount,
        "final_price": finalPrice,
        "cash": cash,
        "change": change,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "transaction_details":
            List<dynamic>.from(transactionDetails.map((x) => x.toJson())),
      };
}

class TransactionDetail {
  String productName;
  int productPrice;
  int qty;
  DateTime createdAt;
  DateTime updatedAt;

  TransactionDetail({
    required this.productName,
    required this.productPrice,
    required this.qty,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) =>
      TransactionDetail(
        productName: json["product_name"],
        productPrice: json["product_price"],
        qty: json["qty"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_price": productPrice,
        "qty": qty,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
