// ignore_for_file: prefer_final_fields

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_kasir/constant.dart';

import 'package:image_picker/image_picker.dart';
import 'package:pos_kasir/models/api_response.dart';
import 'package:pos_kasir/services/product_services.dart';
import 'package:pos_kasir/services/user_services.dart';

import 'login.dart';

class ProdukForm extends StatefulWidget {
  const ProdukForm({super.key});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController _namaProduk = TextEditingController();
  TextEditingController _kategori = TextEditingController();
  TextEditingController _deskripsi = TextEditingController();
  TextEditingController _priceBuy = TextEditingController();
  TextEditingController _priceSell = TextEditingController();
  TextEditingController _stock = TextEditingController();
  TextEditingController _barcode = TextEditingController();

  File? imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _addProduct() async {
    String? image = imageFile == null ? null : getStringImage(imageFile);

    int category = int.parse(_kategori.text);
    int priceBuy = int.parse(_priceBuy.text);
    int priceSell = int.parse(_priceSell.text);
    int stock = int.parse(_stock.text);

    ApiResponse response = await addProduct(
      _namaProduk.text,
      category,
      _deskripsi.text,
      image!,
      priceBuy,
      priceSell,
      stock,
      _barcode.text,
    );

    if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else if (response.error == null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {});
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
                image: imageFile == null
                    ? null
                    : DecorationImage(
                        image: FileImage(imageFile ?? File('')),
                        fit: BoxFit.contain)),
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
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _kategori,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Kategori tidak boleh kosong";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      labelStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
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
                        borderRadius: BorderRadius.circular(10.0),
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
                        borderRadius: BorderRadius.circular(10.0),
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
                        borderRadius: BorderRadius.circular(10.0),
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
                        borderRadius: BorderRadius.circular(10.0),
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Barcode tidak boleh kosong";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Barcode',
                      labelStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                  ),
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
