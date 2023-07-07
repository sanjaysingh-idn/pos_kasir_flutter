import 'package:flutter/material.dart';

// URL untuk android real device -> Ip sesuai ipv4
// php artisan serve --host=192.168.42.125 --port=8000
const baseURL = 'http://192.168.42.125:8000/api';
const imageUrl = 'http://192.168.42.125:8000/storage/';

// URL emulator
// php artisan serve
// const baseURL = 'http://10.0.2.2:8000/api';
// const imageUrl = 'http://10.0.2.2:8000/storage/';

const loginURL = '$baseURL/login';

const userURL = '$baseURL/user';
const profileURL = '$baseURL/profile';
const addUserURL = '$baseURL/add_user';
const logoutURL = '$baseURL/logout';

const categoryURL = '$baseURL/category';
const productURL = '$baseURL/product';

// Error
const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again';

// Get Image
class AppAssets {
  static const String defaultImg = "assets/img_default/default.jpg";
}

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

// body: FutureBuilder(
//           future: getCategory(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return const Text('data oke');
//             } else {
//               return const Text('data error');
//             }
//           }),
//       drawer: const Sidebar(),
