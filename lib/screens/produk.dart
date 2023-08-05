// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/edit_product.dart';
import '../screens/home.dart';

import '../constant.dart';
import '../models/api_response.dart';
import 'add_produk.dart';
import '../models/produk.dart';
import '../services/product_services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  String _searchQuery = "";
  List<Produk> _dataList = []; // Initialize the list as an empty list
  List<Produk> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _fetchProductData(); // Fetch products when the widget is initialized
  }

  Future<void> _fetchProductData() async {
    ApiResponse response = await getProduct();
    if (response.error == null) {
      Map<String, dynamic>? responseData =
          response.data as Map<String, dynamic>?;
      List<dynamic>? productList = responseData?['products'] as List<dynamic>?;
      if (productList != null) {
        setState(() {
          _dataList = parseProductList(productList);
          _handleSearch(
              _searchQuery); // Update search results after fetching products
        });
      } else {
        // Handle the case when the 'products' key is not present in the response
      }
    } else {
      // Handle error case
      // You can show an error message to the user if needed
    }
  }

  void _handleSearch(String query) {
    List<Produk> results = [];
    if (query.isNotEmpty) {
      results = _dataList
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      _searchQuery = query;
      _searchResults = results;
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: _handleSearch,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    final int itemCount =
        _searchQuery.isEmpty ? _dataList.length : _searchResults.length;
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(15.0),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final product =
              _searchQuery.isEmpty ? _dataList[index] : _searchResults[index];
          // String imageUrl = '$getImageURL${product.image}';

          // print("Product Image URL: $imageUrl");
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              leading: product.image != null
                  ? CachedNetworkImage(
                      imageUrl: "$imageUrl${product.image}",
                      width: 50,
                      height: 50,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : CachedNetworkImage(
                      imageUrl: "http://via.placeholder.com/200x150",
                      width: 50,
                      height: 50,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
              title: Row(
                children: [
                  Expanded(
                    // Wrap the Row with Expanded
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Category: ${product.category?.name ?? ''}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp. ${NumberFormat('#,##0').format(product.priceSell)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        // Add more text widgets here...
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(product.name),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         EditProductForm(product: product),
                      //   ),
                      // ).then((result) {
                      //   // You can handle any result from the EditProductForm page if needed.
                      // });
                    },
                    child: const Icon(
                      Icons.edit_document,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      deleteProduct(product.id).then((value) {
                        setState(() {
                          _fetchProductData();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product berhasil dihapus'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    },
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              // Rest of the ListTile code...
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Produk'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildProductList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ProdukForm()),
          );
        },
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
