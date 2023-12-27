import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_management/Auth%20Screens/signup_screen.dart';
import 'package:student_management/Firebase%20services/auth.dart';
import 'package:student_management/sanjhi/loading.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = GlobalKey<FormState>();
  final _auth = ServicesState();
  bool isPasswordVisible = false;
  String email = '';
  String password = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Loading();
    } else {
      return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _key,
          child:  SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Welcome image
                // Lottie.network
                //   ('https://lottie.host/051fdefd-c706-45a1-8a41-95029a83722d/Dndq3gyI0r.json',
                //   height: 300),
                Lottie.asset('assets/Login.json',
                height: 300
                ),


                const SizedBox(height: 40),
                // Email
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Provide email to login';
                    }
                    if (!text.contains('@gmail.com')) {
                      return "Invalid email ";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Password
                TextFormField(
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      child: Icon(
                        isPasswordVisible
                            ? CupertinoIcons.eye_fill
                            : CupertinoIcons.eye_slash_fill,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Provide password to login";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                const SizedBox(height: 40),

                // Login button
                InkWell(
                  onTap: () async {
                    if (_key.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      await _auth.signEmailPassword(
                          context, email, password);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: Center(
                    child: Container(
                      width: 500,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.brown
                      ),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Do not have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => const Signup()),
                        );
                      },
                      child: const Text(
                        "Signup",
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
    }
  }
}
