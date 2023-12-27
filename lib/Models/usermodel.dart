class User {
  String name;
  String pass;

  User(
  {
    required this.name,
    required this.pass

}
      );

  toCloud(){
    return {
      'UserName': name,
      'Password': pass
    };
  }
}