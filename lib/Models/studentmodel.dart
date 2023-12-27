class StudentModel {
  final String fname;
  final String lname;
  final String fathername;
  final String id;
  final String cnic;
  final String city;
  final String gender;
  final String department;

  StudentModel(
  {
    required this.fname,
    required this.lname,
    required this.fathername,
    required this.id,
    required this.cnic,
    required this.city,
    required this.gender,
    required this.department
}
      );

  tocloud(){
    return{
      "FirstName" :fname ,
      "LastName" : lname ,
      "FatherName" :fathername ,
      "ID" : id,
      "CNIC" : cnic,
      "City" : city,
      "Gender" : gender,
      "Department": department
    };


  }

}