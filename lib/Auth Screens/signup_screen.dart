
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_management/Firebase%20services/auth.dart';
import 'package:student_management/Firebase%20services/cloudservices.dart';
import 'package:student_management/Models/usermodel.dart';

import 'login_screen.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  // Cloud service

  final _db = CloudServicesState();


  // Obscure text
  bool isSeen = false;

  final _key = GlobalKey<FormState>();
  final ServicesState _auth = ServicesState();
  String email = " ";
  String password = " ";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30,right: 30),
        child: Form(
          key: _key,
          child:SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Lottie.asset('assets/Signup.json', height: 300),
                    const SizedBox(height: 40),
                    TextFormField(
                      validator: (text){
                        if (text == null || text == "" ){
                          return "Email is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.brown
                            )
                          ),
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.auto),
                      onChanged: (val){
                        setState(() {
                          email = val;
                        });
                      },

                    ),


                const SizedBox(height: 20),

               TextFormField(
                      validator: (text){
                        if (text == null || text == ""){
                          return "Password is required";
                        }
                        if(text.length < 8){
                          return "Password must contain at-least 8 characters";
                        }
                        if (!RegExp(r"[A-Z]").hasMatch(text)) {
                          return 'Password must contain at least one uppercase letter.';
                        }

                        if (!RegExp(r'[a-z]').hasMatch(text)) {
                          return 'Password must contain at least one lowercase letter.';
                        }

                        if (!RegExp(r'[!@#%^&*(),.?":{}|<>]').hasMatch(text)) {
                          return 'Password must contain at least one special character.';
                        }
                        return null;
                      },
                      obscureText: isSeen,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffix: GestureDetector(
                          onTap: (){
                            setState(() {
                              isSeen = !isSeen;
                            });
                          },
                            child: Icon(
                              isSeen? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill )
                            ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.pink
                              )
                          ),
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.auto),
                      onChanged: (val){
                        setState(() {
                          password = val;
                        });
                      },

                    ),


                const SizedBox(height: 30),


                InkWell(
                  onTap:isLoading ? null :
                      () async  {

                    if (_key.currentState!.validate()){
                      setState(() {
                        isLoading = true;
                      });

                      final user = User(name: email, pass: password);
                     // print('user success');
                      await  _auth.createAccount(context, email, password);
                     // print('Account success');
                      await  _db.userdata(user);
                    //  print('storing success');

                    }
                    setState(() {
                      isLoading = false;
                    });

                  },

                  child: Center(
                    child: Container(
                      width: 500,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.brown
                      ),

                        child:isLoading? const CircularProgressIndicator() :
                        const Center(child: Text('Register',style: TextStyle(color: Colors.white, fontSize: 21)))),
                  ),
                ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context) => const Login() ));
                        },
                        child: const Text('Login',style: TextStyle(color: Colors.brown)))
                  ],
                )
              ],
            ),
          ) ,

        ),
      ),
    );

  }
}
