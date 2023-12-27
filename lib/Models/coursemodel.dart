class CourseModel {
  String CourseName;
  String CourseCode;
  String CreditHours;

  CourseModel(
  {
    required this.CourseName,
    required this.CourseCode,
    required this.CreditHours
}
      );

  tocloud(){
    return {
      'CourseName':CourseName,
      'CourseCode': CourseCode,
      'CreditHours': CreditHours
    };
  }
}