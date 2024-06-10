class User {
  static int count = 0;
  int? id;
  String? name;
  User() {
    id = ++count;
  }
}
