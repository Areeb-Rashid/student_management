import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_management/Functionality/departmentdetailss.dart';

class DepartmentGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, // Number of columns in the grid
      crossAxisSpacing: 10.0, // Spacing between columns
      mainAxisSpacing: 10.0, // Spacing between rows
      padding: const EdgeInsets.all(10.0), // Padding around the grid
      children: <Widget>[
        DepartmentCard('Computer Science', () => _handleTap(context, 'Computer Science')),
        DepartmentCard('Software Engineering', ()=> _handleTap(context, 'Software Engineering')),
        DepartmentCard('Artificial Intelligence',()=> _handleTap(context, 'Artificial Intelligence')),
        DepartmentCard('BBA',()=> _handleTap(context, 'BBA')),
        DepartmentCard('IT',()=> _handleTap(context, 'IT')),
        DepartmentCard('Humanities',()=> _handleTap(context, 'Humanities')),
        DepartmentCard('Mathematics',()=> _handleTap(context, 'Mathematics'))
        
      ],

    );
  }
}

void _handleTap(BuildContext context, String departmentName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DepartmentDetails(depname: departmentName),
    ),
  );
}


class DepartmentCard extends StatelessWidget {
  final String departmentName;
  final VoidCallback onTap;

  DepartmentCard(this.departmentName, this.onTap );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              departmentName,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}