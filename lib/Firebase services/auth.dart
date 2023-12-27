import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Auth Screens/login_screen.dart';
import '../Functionality/Home.dart';


class Services extends StatefulWidget {
  @override
  State<Services> createState() => ServicesState();
}

class ServicesState extends State<Services> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> signEmailPassword(BuildContext context, String email, String pass) async {

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context)=> Home(username: email)), (route) => false);

    } on FirebaseAuthException catch (e) {

      print(e.toString());


      showCupertinoDialog(context: context, builder:(c)
      {
        return CupertinoAlertDialog(

          title: const Text("Invalid email / password", style: TextStyle(color: Colors.black),),
          actions: [
            CupertinoDialogAction(
              child:const Text('Ok'),
              onPressed: (){
              Navigator.of(context).pop();
            },
            )
          ],
        );

      }
      );
    }
  }

  Future<void> createAccount(BuildContext context,String email, String pass) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));

    } on FirebaseAuthException catch (e) {
      //print(e.toString());

      showCupertinoDialog(context: context, builder:(c)
      {
        return CupertinoAlertDialog(
          title: const Text("Invalid email / password", style: TextStyle(color: Colors.black),),
          actions: [
            CupertinoDialogAction(child:const Text('Ok'),onPressed: (){
              Navigator.of(context).pop();
            },)
          ],
        );
      }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement your widget here
    // Replace the line below with your widget implementation
    return Container();
  }
}
