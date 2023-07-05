import 'package:flutter/material.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../services/category_services.dart';
import 'home.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController namaKategori = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori'),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(right: 20, left: 20, top: 20),
                  child: Text(
                    'Halaman Manajemen Kategori Produk',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Form(
                // Add your form fields here
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: namaKategori,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Nama Kategori tidak boleh kosong";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Nama Kategori',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                            // Add other decoration properties as needed
                            ),
                        // Add validator, controller, onChanged, and other properties as needed
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            kTextButton('Tambah Kategori', () {
                              if (formkey.currentState!.validate()) {
                                addCategory(namaKategori.text);
                                setState(() {});
                              }
                              // formKey.currentState.reset()
                              // ignore: avoid_print
                              // print(namaKategori.text);
                            }),
                          ],
                        ),
                      ),
                      // Add more TextFormField or other form fields as needed
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                FutureBuilder<ApiResponse>(
                  future: getCategory(),
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
                          List<dynamic> categories = (apiResponse.data
                              as Map<String, dynamic>)['categories'];
                          return ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Card(
                                  color: Colors.white,
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          categories[index]['name'] as String,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              deleteCategory(categories[index]
                                                      ['id'] as int)
                                                  .then((value) {
                                                setState(() {});
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      'Produk Berhasil dihapus'),
                                                ));
                                              });
                                            },
                                            child: const Icon(
                                              Icons.delete_rounded,
                                              color: Colors.red,
                                            ))
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
              ],
            ),
          ),
        ],
      ),
      drawer: const Sidebar(),
    );
  }
}

// if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (snapshot.hasError) {
//                       return const Text('Error fetching data');
//                     } else {
//                       if (snapshot.hasData) {
//                         ApiResponse apiResponse = snapshot.data!;
//                         if (apiResponse.error != null) {
//                           return const Text('Data error');
//                         } else {
//                           List<dynamic> categories = (apiResponse.data
//                               as Map<String, dynamic>)['categories'];
//                           return ListView.builder(
//                             itemCount: categories.length,
//                             itemBuilder: (context, index) {
//                               return ListTile(
//                                 title:
//                                     Text(categories[index]['name'] as String),
//                               );
//                             },
//                           );
//                         }
//                       } else {
//                         return const Text('No data available');
//                       }
//                     }
