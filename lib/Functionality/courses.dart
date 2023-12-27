import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_management/Functionality/Home.dart';
import 'package:student_management/Functionality/addcourses.dart';

class Courses extends StatefulWidget {
  const Courses({Key? key}) : super(key: key);

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Courses', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Courses').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (BuildContext context, index){
                var document = snapshot.data?.docs[index];
                var courseName = document?['CourseName'] ?? 'Null';
                var courseCode = document?['CourseCode'] ?? 'Null';
                var creditHours = document?['CreditHours'] ?? 'Null';
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Dismissible(
                      onDismissed: (direction){
                        deleteItem(courseCode, context);
                      }

                      ,
                      key: UniqueKey(),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              const SizedBox(height: 20),
                              Text('Course Name: $courseName'),

                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text('Course code: $courseCode'),
                              const SizedBox(width: 20),
                              Text('Credit Hours: $creditHours'),
                            ],
                          ),

                        ),
                      ),
                    ),
                  );
                }
            );

          },
        ),
      ),
    );
  }
  void deleteItem(String code, BuildContext context) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      CollectionReference reference = firebaseFirestore.collection('Courses');

      // Query for the document with the matching CNIC
      QuerySnapshot querySnapshot = await reference.where('CourseCode', isEqualTo: code).get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the document
        await reference.doc(querySnapshot.docs.first.id).delete();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course removed successfully')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(e.toString())));
    }
  }
}

