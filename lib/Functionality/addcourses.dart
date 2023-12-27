import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:student_management/Firebase%20services/cloudservices.dart';
import 'package:student_management/Models/coursemodel.dart';
import 'package:student_management/sanjhi/wave.dart';

import 'courses.dart';

class AddCourses extends StatefulWidget {
  const AddCourses({super.key});

  @override
  State<AddCourses> createState() => _AddCoursesState();
}

class _AddCoursesState extends State<AddCourses> {

  // Is Loading
  bool isLoading = false;

  // Key
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  // Cloud
  final _db = CloudServicesState();

  // Controllers
  final _coursetitle = TextEditingController();
  final _coursecode = TextEditingController();
  final _credithours = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading? const Wave() : Scaffold(
      appBar: AppBar(
        title: const Text('Add course',style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              // Course Name
              TextFormField(
                controller: _coursetitle,
                validator:(text){
                  if (text == ''){
                    return "Course Name Required";
                  }
                },
                decoration: const InputDecoration(
                  label: Text("Course Title"),
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),

              ),

              const SizedBox( height: 30),

              // Course Code
              TextFormField(
                controller: _coursecode,
                validator:(text){
                  if (text == '' ){
                    return "Course number Required";
                  }
                },
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '000-000',
                    filter: {'0' : RegExp(r'[0-9 || A-Z]')}
                  )
                ],
                decoration: const InputDecoration(
                  label: Text("Course Code"),
                  hintText: 'HUM-101',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),

              ),

              const SizedBox(height: 30),

              // Credit Hours
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: _credithours,
                      validator:(text){
                        if (text == ''|| text == null){
                          return "Course Name Required";
                        }

                        try{
                          int number = int.parse(text);
                          if (number <= 4){
                            return null;
                          }
                          else {
                            return 'Less or equal to 4';
                          }
                        } catch (e){
                          print(e.toString());
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text("Credit Hours"),
                        hintText: '1-4',
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1)
                      ],

                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              Row(
                children: [

                  // Add button
                  ElevatedButton(
                      onPressed: () async {
                        if (_key.currentState!.validate()){

                          setState(() {
                            isLoading = true;
                          });

                          final cm = CourseModel(CourseName: _coursetitle.text, CourseCode: _coursecode.text, CreditHours: _credithours.text);

                          await _db.addCourse(cm,context);
                          Navigator.pop(context);

                        }
                      }, child: const Text('Add')),

                  const SizedBox(width: 40),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: const Text("Cancel"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
