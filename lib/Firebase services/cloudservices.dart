import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_management/Functionality/Home.dart';
import 'package:student_management/Functionality/addStudent.dart';
import 'package:student_management/Functionality/addcourses.dart';
import 'package:student_management/Models/coursemodel.dart';
import 'package:student_management/Models/studentmodel.dart';
import 'package:student_management/Models/usermodel.dart';

class CloudServices extends StatefulWidget {
  const CloudServices({super.key});

  @override
  State<CloudServices> createState() => CloudServicesState();
}

class CloudServicesState extends State<CloudServices> {
  bool isLoading = false;
  final _db = FirebaseFirestore.instance;

  Future<bool> checkCourse(String id) async {
    try {
      CollectionReference studentsCollection = _db.collection('Courses');
      QuerySnapshot querySnapshot =
      await studentsCollection.where('CourseCode', isEqualTo: id).get();

      return querySnapshot.docs.isEmpty; // Return true if CNIC doesn't exist
    } catch (e) {
      //print('Error checking CNIC: $e');
      return false;
    }
  }

  Future<bool> checkCnic(String cnic) async {
    try {
      CollectionReference studentsCollection = _db.collection('Students');
      QuerySnapshot querySnapshot =
      await studentsCollection.where('CNIC', isEqualTo: cnic).get();

      return querySnapshot.docs.isEmpty; // Return true if CNIC doesn't exist
    } catch (e) {
      //print('Error checking CNIC: $e');
      return false;
    }
  }
  Future<bool> checkRegNo(String regno) async {
    try {
      CollectionReference studentsCollection = _db.collection('Students');
      QuerySnapshot querySnapshot =
      await studentsCollection.where('ID', isEqualTo: regno).get();

      return querySnapshot.docs.isEmpty; // Return true if CNIC doesn't exist
    } catch (e) {
      //print('Error checking CNIC: $e');
      return false;
    }
  }

  Future<void> student(StudentModel s, BuildContext context) async {
    try {
      // Check if CNIC already exists
      bool isCnicUnique = await checkCnic(s.cnic);
      bool isIDunique   = await checkRegNo(s.id);
      if (!isCnicUnique) {
         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const addStudent()), (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CNIC already exists')),
        );

      }
      else if (!isIDunique){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const addStudent()), (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration number already exists, try a different one')),
        );

      }
      else {
        await _db.collection("Students").add(s.tocloud());
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Record Added successfully')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    //  print(e);
    }
  }

  Future<void> addCourse(CourseModel cm, BuildContext context) async {
    try {
      bool isCourseCodeUnique = await checkCourse(cm.CourseCode);

    if (!isCourseCodeUnique) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course already exist')),
        );

      }
      else {

      await _db.collection('Courses').add(cm.tocloud());
      ScaffoldMessenger.of(context).
      showSnackBar(
        const SnackBar(content: Text('Course Added Successfully')),
      );

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      //print(e);
    }
  }

  Future<void> userdata(User user) async {
    try {
      await _db.collection('User').add(user.toCloud());
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
