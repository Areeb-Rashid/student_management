import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:student_management/Firebase%20services/cloudservices.dart';
import 'package:student_management/Functionality/Home.dart';
import 'package:student_management/Models/studentmodel.dart';
import '../sanjhi/wave.dart';

class addStudent extends StatefulWidget {
  const addStudent({super.key});

  @override
  State<addStudent> createState() => _addStudentState();
}

class _addStudentState extends State<addStudent> {
  // Loading
  bool isLoading = false;

  // For cloud Firestore
  final _db = CloudServicesState();

  // For cities drop down
  String selectedCity = 'Select Your City';
  List<String> cities = ['Select Your City', 'Lahore', 'Islamabad', 'Gujrat', 'Gojra'];

  // For gender drop down
  List<String> genders = ['Select Gender', 'Male', 'Female', 'Prefer not to say'];
  String selectedGender = "Select Gender";

  // For department dropdown
  String selectedDep = 'Select Department';
  List<String> departments = [
    'Select Department',
    'Computer Science',
    'Software Engineering',
    'BBA',
    'Artificial Intelligence',
    'Mathematics',
    'Humanities',
    'IT'
  ];

  // Key
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  // Text controllers
  final fname = TextEditingController();
  final lname = TextEditingController();
  final fathername = TextEditingController();
  final cnic = TextEditingController();
  final regno = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Wave()
        : Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("Fill in the form to add student",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(13, 25, 13, 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First name
                  TextFormField(
                    controller: fname,
                    validator: (text) {
                      if (text == '') {
                        return 'First name Required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("First Name"),
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      focusColor: Colors.brown
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Last name
                  TextFormField(
                    controller: lname,
                    validator: (text) {
                      if (text == '') {
                        return 'Last name Required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        focusColor: Colors.brown,
                      label: Text("Last Name"),
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Father name
                  TextFormField(
                    controller: fathername,
                    validator: (text) {
                      if (text == '') {
                        return 'Father name Required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("Father Name"),
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                        focusColor: Colors.brown
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // CNIC
                  TextFormField(
                    controller: cnic,
                    validator: (text) {
                      if (text == '') {
                        return 'CNIC Required';
                      }

                      return null;
                    },
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '00000-0000000-0',
                        filter: {'0': RegExp(r'[0-9]')},
                      )
                    ],
                    decoration: const InputDecoration(
                      label: Text("CNIC"),
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                        focusColor: Colors.brown
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),
                  // Registration Number
                  TextFormField(
                    controller: regno,
                    validator: (text) {
                      if (text == '') {
                        return 'Registration number Required';
                      }
                      // if (checkCnic(text)) {
                      //   return 'Registration number already exists';
                      // }
                      return null;
                    },
                    inputFormatters: [
                      MaskTextInputFormatter(
                          mask: '0000-000-000',
                          filter: {'0': RegExp(r'[A-Z || 0-9]')})
                    ],
                    decoration: const InputDecoration(
                      label: Text("Registration Number"),
                      hintText: 'SP22-BCS-021',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                        focusColor: Colors.brown
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // City
                  Row(
                    children: [
                      // City Dropdown
                      DropdownButton<String>(
                        value: selectedCity,
                        onChanged: (String? newItem) {
                          setState(() {
                            if (newItem != 'Select Your City') {
                              selectedCity = newItem ?? 'Select Your City';
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Choose a valid option")));
                            }
                          });
                        },
                        items: cities.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30),
                      const SizedBox(
                        width: 40,
                      ),
                      // Gender Dropdown
                      DropdownButton<String>(
                        value: selectedGender,
                        onChanged: (String? newItem) {
                          setState(() {
                            if (newItem != 'Select Gender') {
                              selectedGender = newItem ?? 'Select Gender';
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Choose a valid option")));
                            }
                          });
                        },
                        items: genders.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Department DropDown
                  DropdownButton(
                    value: selectedDep,
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue != 'Select Department') {
                          selectedDep = newValue ?? 'Select Department';
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Not a valid choice')));
                        }
                      });
                    },
                    items: departments.map((String items) {
                      return DropdownMenuItem<String>(
                          value: items, child: Text(items));
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Add button
                      ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              final s = StudentModel(
                                fname: fname.text,
                                lname: lname.text,
                                fathername: fathername.text,
                                id: regno.text,
                                cnic: cnic.text,
                                city: selectedCity,
                                gender: selectedGender,
                                department: selectedDep,
                              );

                              await _db.student(s, context);

                            }
                          },
                          child: const Text('Add')),
                      const SizedBox(
                        width: 40,
                      ),
                      // Cancel button
                      ElevatedButton(
                          onPressed: () {
                          //  print(cnic.text);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>  const Home()));
                          },
                          child: const Text('Cancel'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

}
