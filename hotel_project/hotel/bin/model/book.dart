import 'admin.dart';
import 'room.dart';
import 'user.dart';

class Book {
  static int count = 0;
  int? id;
  int? duration;
  DateTime? bookingDate;
  double? bill;
  User? user;
  Room? room;
  Admin? admin;

  Book() {
    id = ++count;
  }
}
