import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DepartmentDetails extends StatelessWidget {

  String depname;

  DepartmentDetails(
  {
    required this.depname
}
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(depname,style: const TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
       body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Students').where('Department', isEqualTo: depname ).snapshots(),
        builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot){
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting ){
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data?.docs.isEmpty == true){
            return const Center(
                child: Text('No student enrolled currently'));
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (BuildContext context, index){

                var document = snapshot.data?.docs[index];
                var FirstName = document?['FirstName'] ?? 'Null';
                var LastName = document?['LastName'] ?? 'Null';
                var FatherName = document?['FatherName'] ?? 'Null';
                var ID = document?['ID'] ?? 'Null';
                var City = document?['City'] ?? 'Null';
                var CNIC = document?['CNIC'] ?? 'Null';
                var Gender = document?['Gender'] ?? 'Null';
                var Department = document?['Department'] ?? 'Null';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Dismissible(
                    onDismissed: (direction) {
                      deleteItem(CNIC, context);
                    },

                    key: GlobalKey(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: ListTile(
                        title: Column(
                          children: [

                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Text('First Name: $FirstName',style: const TextStyle(fontWeight: FontWeight.bold),),
                                const Spacer(),
                                Text('Last Name: $LastName',style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              children: [
                                Text('ID: $ID',style: const TextStyle(fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Text('Father Name: $FatherName',style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Gender: $Gender',style: const TextStyle(fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Text('City: $City',style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Department: $Department',style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              children: [
                                Text('CNIC: $CNIC',style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            )

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
    );
  }

  void deleteItem(String cnic, BuildContext context) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      CollectionReference reference = firebaseFirestore.collection('Students');

      // Query for the document with the matching CNIC
      QuerySnapshot querySnapshot = await reference.where('CNIC', isEqualTo: cnic).get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the document
        await reference.doc(querySnapshot.docs.first.id).delete();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student deleted successfully')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(e.toString())));
    }
  }



}


