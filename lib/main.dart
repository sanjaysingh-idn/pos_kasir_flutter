// HAPUS BARIS INI SAAT DEPLOY
import 'dart:io';

import 'package:flutter/material.dart';

import 'screens/loading.dart';

// HAPUS BARIS INI SAAT DEPLOY, INI HANYA UNTUK TESTING PADA SAAT STAGING
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
// HAPUS BARIS INI SAAT DEPLOY INI HANYA UNTUK TESTING PADA SAAT STAGING

void main() {
  // HAPUS BARIS INI SAAT DEPLOY INI HANYA UNTUK TESTING PADA SAAT STAGING
  HttpOverrides.global = MyHttpOverrides();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}
