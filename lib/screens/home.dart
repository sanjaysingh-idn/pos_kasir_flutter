import 'package:flutter/material.dart';
import 'package:pos_kasir/screens/category.dart';
import 'package:pos_kasir/screens/produk.dart';
import 'package:pos_kasir/services/user_services.dart';

import 'login.dart';
import 'transaksi.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Card(
                color: Colors.lightBlue,
                elevation: 20,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        'Total Omset Hari ini',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Rp. 250,000',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Jumlah Transaksi hari ini',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '7',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Manajemen',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Category()));
                },
                tileColor: Colors.lightBlue,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                leading: const Icon(
                  Icons.category_rounded,
                  color: Colors.white,
                ),
                title: const Text('Kategori'),
                textColor: Colors.white,
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: Colors.lightBlue,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                leading: const Icon(
                  Icons.trolley,
                  color: Colors.white,
                ),
                title: const Text('Produk'),
                textColor: Colors.white,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Produk()));
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: Colors.lightBlue,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                leading: const Icon(
                  Icons.attach_money_rounded,
                  color: Colors.white,
                ),
                title: const Text('Transaksi'),
                textColor: Colors.white,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Transaksi()));
                },
              ),
              const SizedBox(height: 10),
              const ListTile(
                tileColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                leading: Icon(
                  Icons.file_copy,
                  color: Colors.white,
                ),
                title: Text('Laporan'),
                textColor: Colors.white,
                // onTap: () {},
              ),
            ],
          ),
        ),
      ),
      drawer: const Sidebar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_rounded),
            label: 'Transaksi',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
            if (currentIndex == 0) {
              // Navigate to the home page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            } else if (currentIndex == 1) {
              // Navigate to the transaksi page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Transaksi()),
              );
            }
          });
        },
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(height: 25),
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y'),
                  ),
                  Text('Profile',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  SizedBox(height: 10),
                  Text('User Name', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          ListTile(
            tileColor: Colors.lightBlue,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            leading: const Icon(
              Icons.home_rounded,
              color: Colors.white,
            ),
            title: const Text('Home'),
            textColor: Colors.white,
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Home()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 5),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Category()));
            },
            tileColor: Colors.lightBlue,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            leading: const Icon(
              Icons.category_rounded,
              color: Colors.white,
            ),
            title: const Text('Kategori'),
            textColor: Colors.white,
          ),
          const SizedBox(height: 5),
          ListTile(
            tileColor: Colors.lightBlue,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            leading: const Icon(
              Icons.trolley,
              color: Colors.white,
            ),
            title: const Text('Produk'),
            textColor: Colors.white,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Produk()));
            },
          ),
          const SizedBox(height: 5),
          const ListTile(
            tileColor: Colors.lightBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            leading: Icon(
              Icons.people_rounded,
              color: Colors.white,
            ),
            title: Text('User'),
            textColor: Colors.white,
            // onTap: () {},
          ),
          const SizedBox(height: 5),
          const ListTile(
            tileColor: Colors.lightBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            leading: Icon(
              Icons.person_pin_circle_rounded,
              color: Colors.white,
            ),
            title: Text('Profile'),
            textColor: Colors.white,
            // onTap: () {},
          ),
          const SizedBox(height: 5),
          ListTile(
            tileColor: Colors.lightBlue,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            leading: const Icon(
              Icons.logout_sharp,
              color: Colors.white,
            ),
            title: const Text('Logout'),
            textColor: Colors.white,
            onTap: () {
              logout().then((value) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
