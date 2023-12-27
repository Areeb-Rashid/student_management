import 'package:flutter/material.dart';
import 'package:student_management/Functionality/department.dart';

class ManageStudents extends StatefulWidget {
  const ManageStudents({super.key});

  @override
  State<ManageStudents> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Portal'),
        centerTitle: true,
        backgroundColor: Colors.brown,

      ),
      body: DepartmentGrid()
    );
  }
}
