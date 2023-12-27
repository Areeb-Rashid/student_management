import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_management/Auth%20Screens/login_screen.dart';
import 'package:student_management/Functionality/addStudent.dart';
import 'package:student_management/Functionality/addcourses.dart';
import 'package:student_management/Functionality/courses.dart';
import 'package:student_management/Functionality/managestudent.dart';

class Home extends StatefulWidget {
  final String? username;
  const Home({Key? key, this.username}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Map<String, int>> studentCountByDepartment;

  // Added global key for RefreshIndicator
  final GlobalKey<RefreshIndicatorState> _refreshKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    studentCountByDepartment = fetchStudentCountByDepartment();
  }

  Future<Map<String, int>> fetchStudentCountByDepartment() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Students').get();

      Map<String, int> departmentCount = {};

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
      in querySnapshot.docs) {
        String department = document['Department'] ?? 'Unknown';

        if (departmentCount.containsKey(department)) {
          departmentCount[department] = departmentCount[department]! + 1;
        } else {
          departmentCount[department] = 1;
        }
      }

      return departmentCount;
    } catch (e) {
      print("Error fetching student count by department: $e");
      return {};
    }
  }

  Future<void> _refreshData() async {
    try {
      setState(() {
        studentCountByDepartment = fetchStudentCountByDepartment();
      });
      await studentCountByDepartment; // Wait for the future to complete
    } catch (e) {
      print("Error refreshing data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.brown,
              ),
              child: Text('Hi ${widget.username?.split('@')[0]}'),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Add a student"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const addStudent()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts_sharp),
              title: const Text("Manage Students"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManageStudents()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.score),
              title: const Text("Add Courses"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddCourses()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text("Courses information"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Courses()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                showCupertinoDialog(
                    context: context,
                    builder: (c) {
                      return CupertinoAlertDialog(
                        title: const Text('Do you want to Logout?'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('Logout'),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => const Login()),
                                      (route) => false);
                            },
                          )
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        child: Center(
          child: FutureBuilder(
            future: studentCountByDepartment,
            builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading data'));
              } else {
                Map<String, int> departmentCount = snapshot.data ?? {};
                return DataTable(
                  columns: const [
                    DataColumn(label: Text('Department')),
                    DataColumn(label: Text('Number of Students')),
                  ],
                  rows: departmentCount.entries.map((entry) {
                    return DataRow(cells: [
                      DataCell(Text(entry.key)),
                      DataCell(Text(entry.value.toString())),
                    ]);
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
