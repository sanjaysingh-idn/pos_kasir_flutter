// ignore_for_file: unused_local_variable, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_kasir/screens/produk.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../models/category.dart';
import '../models/produk.dart';
import '../services/category_services.dart';
import '../services/product_services.dart';
import '../services/user_services.dart';
import 'login.dart';

class EditProductForm extends StatefulWidget {
  final Produk product;
  const EditProductForm({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _priceBuy = TextEditingController();
  final TextEditingController _priceSell = TextEditingController();
  final TextEditingController _stock = TextEditingController();
  final TextEditingController _barcode = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  int? selectedCategoryId;
  List<Category>? categories;

  @override
  void initState() {
    super.initState();
    _name.text = widget.product.name;
    _desc.text = widget.product.desc;
    _priceBuy.text = widget.product.priceBuy.toString();
    _priceSell.text = widget.product.priceSell.toString();
    _stock.text = widget.product.stock.toString();
    _barcode.text = widget.product.barcode;
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    ApiResponse response = await getCategory();
    if (response.error == null) {
      Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
      List<dynamic> categoryList = responseData['categories'];
      setState(() {
        categories = categoryList
            .map((json) => Category.fromJson(json))
            .cast<Category>()
            .toList();
        selectedCategoryId = widget.product.category?.id;
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

  void _updateProduct() async {
    // Validate the form before proceeding
    if (!formkey.currentState!.validate()) {
      return;
    }

    int categoryId = selectedCategoryId ?? 0;
    int priceBuy = int.parse(_priceBuy.text);
    int priceSell = int.parse(_priceSell.text);
    int stock = int.parse(_stock.text);
    String barcode = _barcode.text;

    try {
      ApiResponse response = await updateProductWithImage(
        widget.product.id,
        _name.text,
        categoryId,
        _desc.text,
        imageFile!.path, // Use the selected image path
        priceBuy,
        priceSell,
        stock,
        barcode,
      );

      print(response);

      if (response.error == unauthorized) {
        // Handle unauthorized error
        logout().then((value) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
          );
        });
      } else if (response.error == null) {
        // print("sampe sini");
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Product()),
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
      // Handle any exceptions or errors that occur during the API call
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while updating the product'),
        ),
      );
    }
  }

  void _updateProductWithoutImage() async {
    // Validate the form before proceeding
    if (!formkey.currentState!.validate()) {
      return;
    }

    int categoryId = selectedCategoryId ?? 0;
    int priceBuy = int.parse(_priceBuy.text);
    int priceSell = int.parse(_priceSell.text);
    int stock = int.parse(_stock.text);
    String barcode = _barcode.text;

    try {
      int productId = widget.product.id;
      ApiResponse response = await updateProductWithoutImage(
        productId,
        _name.text,
        categoryId,
        _desc.text,
        priceBuy,
        priceSell,
        stock,
        barcode,
      );

      // print(response.statuw); // Print status code
      print(response.data); // Print response data
      print(response.error);

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
          MaterialPageRoute(builder: (context) => const Product()),
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
      // Handle any exceptions or errors that occur during the API call
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while updating the product'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Produk'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Product(),
              ),
            );
          },
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
                      image: FileImage(
                        File(imageFile!.path),
                      ),
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
                    controller: _name,
                    onChanged: (value) {
                      // Update the product name whenever it changes in the form
                      setState(() {
                        widget.product.name = value;
                      });
                    },
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
                    controller: _desc,
                    onChanged: (value) {
                      // Update the product name whenever it changes in the form
                      setState(() {
                        widget.product.desc = value;
                      });
                    },
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
                    onChanged: (value) {
                      // Update the product name whenever it changes in the form
                      setState(() {
                        widget.product.priceBuy = value as int;
                      });
                    },
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
                    onChanged: (value) {
                      // Update the product name whenever it changes in the form
                      setState(() {
                        widget.product.priceSell = value as int;
                      });
                    },
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
                    onChanged: (value) {
                      // Update the product name whenever it changes in the form
                      setState(() {
                        widget.product.stock = value as int;
                      });
                    },
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
                    onChanged: (value) {
                      // Update the product name whenever it changes in the form
                      setState(() {
                        widget.product.barcode = value;
                      });
                    },
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
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        if (imageFile == null) {
                          // No image selected, call _updateProductWithoutImage()
                          _updateProductWithoutImage();
                          setState(() {});
                        } else {
                          // Image selected, call _updateProduct()
                          _updateProduct();
                          setState(() {});
                        }
                      }
                    },
                    child: const Text('Simpan Perubahan'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
