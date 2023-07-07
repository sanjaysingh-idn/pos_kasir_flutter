// ignore_for_file: prefer_final_fields, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_kasir/constant.dart';

import 'package:image_picker/image_picker.dart';
import 'package:pos_kasir/models/api_response.dart';
import 'package:pos_kasir/screens/produk.dart';
import 'package:pos_kasir/services/product_services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../models/category.dart';
import '../services/category_services.dart';
import '../services/user_services.dart';

import 'login.dart';

class ProdukForm extends StatefulWidget {
  const ProdukForm({super.key});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _namaProduk = TextEditingController();
  TextEditingController _deskripsi = TextEditingController();
  TextEditingController _priceBuy = TextEditingController();
  TextEditingController _priceSell = TextEditingController();
  TextEditingController _stock = TextEditingController();
  TextEditingController _barcode = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  int? selectedCategoryId;
  List<Category>? categories;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    ApiResponse response = await getCategory();
    if (response.error == null) {
      Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
      // print(responseData['categories']);
      List<dynamic> categoryList = responseData['categories'];
      setState(() {
        categories =
            categoryList.map((json) => Category.fromJson(json)).toList();
      });
    } else {
      // Handle error case
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  void _addProduct() async {
    if (imageFile == null) {
      // Handle the case when no image is selected
      return;
    }

    String? image = imageFile!.path;

    int category = selectedCategoryId ?? 0;
    int priceBuy = int.parse(_priceBuy.text);
    int priceSell = int.parse(_priceSell.text);
    int stock = int.parse(_stock.text);

    try {
      ApiResponse response = await addProductWithImage(
        _namaProduk.text,
        category,
        _deskripsi.text,
        image,
        priceBuy,
        priceSell,
        stock,
        _barcode.text,
      );

      if (response.error == unauthorized) {
        // Handle unauthorized error
        logout().then((value) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
          );
        });
      } else if (response.error == null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Produk()),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully'),
          ),
        );
      } else {
        // Show error message to the user
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}')),
        );
        setState(() {});
      }
    } catch (e) {
      // Handle any exceptions or errors that occur
      print('Error: $e');
      // Display error message to the user
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while adding the product'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Tambah Produk'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      body: ListView(
        children: [
          // ignore: sized_box_for_whitespace
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: BoxDecoration(
              image: imageFile != null
                  ? DecorationImage(
                      image: FileImage(File(imageFile!.path)),
                      fit: BoxFit.contain,
                    )
                  : null,
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.image_rounded,
                  color: Colors.lightBlue,
                ),
                iconSize: 50,
                onPressed: () {
                  getImage();
                },
              ),
            ),
          ),
          Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaProduk,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nama Produk tidak boleh kosong";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Nama Produk',
                      labelStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    items: categories?.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    iconEnabledColor: Colors.lightBlue,
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _deskripsi,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Deskripsi tidak boleh kosong";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      labelStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _priceBuy,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Harga Beli tidak boleh kosong";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Harga Beli',
                      labelStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _priceSell,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Harga Jual tidak boleh kosong";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Harga Jual',
                      labelStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _stock,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Stok tidak boleh kosong";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Stok',
                      labelStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _barcode,
                    decoration: const InputDecoration(
                      labelText: 'Barcode',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String barcodeScanResult =
                          await FlutterBarcodeScanner.scanBarcode(
                              '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
                      setState(() {
                        _barcode.text = barcodeScanResult;
                      });
                    },
                    child: const Text('Scan Barcode'),
                  ),
                  // TextFormField(
                  //   controller: _barcode,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Barcode tidak boleh kosong";
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //     labelText: 'Barcode',
                  //     labelStyle: const TextStyle(fontSize: 12),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(20.0),
                  //     ),
                  //     contentPadding: const EdgeInsets.symmetric(
                  //         vertical: 8.0, horizontal: 12.0),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  kTextButton('Tambah Produk', () {
                    if (formkey.currentState!.validate()) {
                      _addProduct();
                      setState(() {});
                    }
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
