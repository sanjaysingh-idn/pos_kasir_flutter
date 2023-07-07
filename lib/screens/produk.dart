// ignore_for_file: avoid_print
// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_kasir/models/api_response.dart';
import 'package:pos_kasir/screens/detail_produk.dart';
import 'package:pos_kasir/services/product_services.dart';

// import '../constant.dart';
import 'add_produk.dart';

class Produk extends StatefulWidget {
  const Produk({super.key});

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  Color backgroundColor = Colors.lightBlue;
  TextStyle greenBoldTextStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      body: FutureBuilder<ApiResponse>(
        future: getProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
          } else {
            if (snapshot.hasData) {
              ApiResponse apiResponse = snapshot.data!;
              if (apiResponse.error != null) {
                return const Text('Data error');
              } else {
                List<dynamic> products =
                    (apiResponse.data as Map<String, dynamic>)['products'];
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var item = products[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Card(
                        color: Colors.white,
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.asset(
                                  "assets/img_default/default.jpg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        'Rp. 12,000',
                                        style: greenBoldTextStyle,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${item['name']}',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(item['category']['name']),
                                    const SizedBox(height: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Rp. ${NumberFormat('#,##0').format(item['priceSell'])}',
                                          style: greenBoldTextStyle,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Stok: ${item['stock']}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProdukDetail(product: item)));
                                },
                                child: const Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  // int productId = item['id'] as int;
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         edit_produk(productId: productId),
                                  //   ),
                                  // );
                                },
                                child: const Icon(
                                  Icons.edit_document,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  deleteProduct(item['id']).then((value) {
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar;
                                  });
                                },
                                child: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return const Text('No data available');
            }
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProdukForm()));
        },
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
