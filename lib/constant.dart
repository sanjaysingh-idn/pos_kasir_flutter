import 'package:flutter/material.dart';

// URL untuk android real device -> Ip sesuai ipv4
// php artisan serve --host=192.168.42.125 --port=8000
// const baseURL = 'http://192.168.42.125:8000/api';
// const imageUrl = 'http://192.168.42.125:8000/storage/';

// CATATAN PENTING UNTUK GAMBAR
// KALAU STAGING, IMAGE DIUBAH SEPERTI INI YA
// imageUrl: "https://tigertobacco.online/storage/${product.image}",

// KALAU PRODUCTIONSEPERTI INI
//  imageUrl: "http://via.placeholder.com/200x150"

// URL emulator
// php artisan serve
const baseURL = 'http://10.0.2.2:8000/api';
const imageUrl = 'http://10.0.2.2:8000/storage/';

const loginURL = '$baseURL/login';

const userURL = '$baseURL/user';
const profileURL = '$baseURL/profile';
const addUserURL = '$baseURL/add_user';
const logoutURL = '$baseURL/logout';

const categoryURL = '$baseURL/category';
const productURL = '$baseURL/product';
const transactionURL = '$baseURL/transaction';
const transactionTodayURL = '$baseURL/transaction-today';
const transactionMonthURL = '$baseURL/transaction-month';
const transactionYearURL = '$baseURL/transaction-year';
const getTotalURL = '$baseURL/total';

// Error
const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again';

// Input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.lightBlueAccent)));
}

// Button

TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.blue),
          padding: MaterialStateProperty.resolveWith(
              (states) => const EdgeInsets.all(10.0))),
      onPressed: () => onPressed(),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ));
}
