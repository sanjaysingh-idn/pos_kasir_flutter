import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_kasir/screens/category.dart';
import 'package:pos_kasir/screens/login.dart';
import 'package:pos_kasir/screens/produk.dart';
import 'package:pos_kasir/screens/transaksi.dart';
import 'package:pos_kasir/screens/user.dart';
import 'package:pos_kasir/services/user_services.dart';

import '../models/api_response.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../services/transaction_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;
  late Future<List<TransactionElement>> _transactionsFuture;
  late double _totalPrice;
  late int _transactionCount;

  Future<List<TransactionElement>> fetchTransactions() async {
    ApiResponse response = await getTransactionToday();
    if (response.data != null) {
      // Check if response.data is a Map<String, dynamic>
      if (response.data is Map<String, dynamic>) {
        // Explicitly cast response.data to Map<String, dynamic>
        var dataMap = response.data as Map<String, dynamic>;

        // Extract the list of transactions from the map and perform null check
        var transactionList = dataMap['transaction'] as List<dynamic>?;
        if (transactionList != null) {
          return List<TransactionElement>.from(
            transactionList.map((item) => TransactionElement.fromJson(item)),
          );
        }
      }
    }
    return [];
  }

  Future<User?> getUser() async {
    ApiResponse response = await profile();
    if (response.error == null) {
      return response.data as User?;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // Load transactions data when the page is initialized
    _transactionsFuture = fetchTransactions();
    // Initialize the total price and transaction count to 0
    _totalPrice = 0;
    _transactionCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout_sharp),
        //     onPressed: () {
        //       // Implement the logout functionality here
        //       // For example, call the logout() method to handle the logout process
        //       logout().then((value) {
        //         Navigator.of(context).pushAndRemoveUntil(
        //           MaterialPageRoute(builder: (context) => const Login()),
        //           (route) => false,
        //         );
        //       });
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: [
          FutureBuilder<User?>(
            future: getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Data user gagal dimuat, silahkan cek koneksi anda.",
                  ),
                );
              } else {
                final user = snapshot.data;
                if (user != null) {
                  return Container(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 15,
                      right: 15,
                      bottom: 80,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Selamat datang ${user.name}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  FutureBuilder<List<TransactionElement>>(
                                    future: _transactionsFuture,
                                    initialData: const [],
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return const Center(
                                          child: Text('Error fetching data'),
                                        );
                                      } else if (snapshot.hasData) {
                                        List<TransactionElement> transactions =
                                            snapshot.data!;
                                        _totalPrice = 0;
                                        for (var transaction in transactions) {
                                          _totalPrice += transaction.totalPrice;
                                        }

                                        _transactionCount = transactions.length;

                                        return Column(
                                          children: [
                                            Text(
                                              'Rp. ${NumberFormat('#,##0').format(_totalPrice)}',
                                              style: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            const Text(
                                              'Jumlah Transaksi hari ini',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              '$_transactionCount',
                                              style: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const Center(
                                          child:
                                              Text('No transactions available'),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Manajemen',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          padding: const EdgeInsets.all(10),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            if (user.role == "admin") ...[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Category(),
                                    ),
                                  );
                                },
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.category_rounded,
                                      size: 40,
                                      color: Colors.brown,
                                    ),
                                    SizedBox(height: 8),
                                    Text("Kategori",
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.pop(context, const Product());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Product(),
                                    ),
                                  );
                                },
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.trolley,
                                      size: 40,
                                      color: Colors.purple,
                                    ),
                                    SizedBox(height: 8),
                                    Text("Produk",
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const UserList(),
                                    ),
                                  );
                                },
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people,
                                      size: 40,
                                      color: Colors.black,
                                    ),
                                    SizedBox(height: 8),
                                    Text("User",
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ],
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Transaksi(),
                                  ),
                                );
                              },
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.attach_money_rounded,
                                    size: 40,
                                    color: Colors.green,
                                  ),
                                  SizedBox(height: 8),
                                  Text("Transaksi",
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Transaksi(),
                                  ),
                                );
                              },
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.file_copy_rounded,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 8),
                                  Text("Laporan",
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                logout().then((value) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                    (route) => false,
                                  );
                                });
                              },
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout_sharp,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                  SizedBox(height: 8),
                                  Text("Logout",
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text("User detail not available");
                }
              }
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Transaksi()));
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
