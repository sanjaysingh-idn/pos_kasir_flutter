import 'package:flutter/material.dart';

import '../models/api_response.dart';
import '../models/user.dart';
import '../services/user_services.dart';
import 'add_user.dart';
import 'detail_user.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Color backgroundColor = Colors.lightBlue;
  TextStyle greenBoldTextStyle = const TextStyle(
    color: Colors.lightBlue,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar User'),
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
        future: getUserList(),
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
                var responseData = apiResponse.data;
                if (responseData != null &&
                    responseData is Map<String, dynamic> &&
                    responseData.containsKey('user')) {
                  List<dynamic> users = responseData['user'];
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var item = users[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        'Nama  : ${item['name']}',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Role  : ${item['role']}',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(item['email']),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    final user = User.fromJson(
                                        item); // Assuming `item` is a JSON object
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserDetail(user: user),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.edit_document,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // GestureDetector(
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) =>
                                //             EditUser(users: item),
                                //       ),
                                //     );
                                //   },
                                //   child: const Icon(
                                //     Icons.edit_document,
                                //     color: Colors.green,
                                //   ),
                                // ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    deleteUser(item['id']).then((value) {
                                      setState(() {
                                        // User deleted, trigger rebuild
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('User deleted successfully'),
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
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('No data available');
                }
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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddUser()));
        },
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
