import 'package:flutter/material.dart';
import 'package:pos_kasir/constant.dart';
import 'package:pos_kasir/models/api_response.dart';
import 'package:pos_kasir/models/user.dart';
import 'package:pos_kasir/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  bool loading = false;

  void _loginUser() async {
    try {
      setState(() {
        loading = true;
      });

      ApiResponse response = await login(txtEmail.text, txtPassword.text);

      if (response.error == null) {
        _saveAndRedirectToHome(response.data as User);
      } else {
        setState(() {
          loading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during login')),
      );
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.all(25.0),
          children: [
            Image.asset(
              "assets/img_default/logo.png",
              width: 250,
              height: 250,
            ),

            // Margin top

            // Nama Toko
            // Center(
            //   child: Text('TOKO SRI REJEKI',
            //       style: GoogleFonts.koulen(
            //         textStyle: const TextStyle(
            //             color: Colors.lightBlue,
            //             fontSize: 20,
            //             letterSpacing: 2,
            //             fontWeight: FontWeight.bold),
            //       )),
            // ),

            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              validator: (val) =>
                  val!.isEmpty ? 'Email tidak boleh kosong.' : null,
              decoration: kInputDecoration('Email'),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: txtPassword,
              obscureText: true,
              validator: (val) =>
                  val!.isEmpty ? 'Password tidak boleh kosong.' : null,
              decoration: kInputDecoration('Password'),
            ),

            const SizedBox(height: 15),

            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : kTextButton('Login', () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _loginUser();
                      });
                    }
                  }),
          ],
          // sampe on pressed
        ),
      ),
    );
  }
}
