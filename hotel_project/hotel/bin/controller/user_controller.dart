import 'dart:io';

import 'package:cli_table/cli_table.dart';
import 'package:colorize/colorize.dart';

import '../model/user.dart';

class UserController {
  static List<User> usersData = [];

  void addUser() {
    User user = User();
    try {
      color('Enter user name : ', front: Styles.BG_LIGHT_GREEN, isBold: true);
      user.name = stdin.readLineSync()!.toLowerCase();
    } catch (e) {
      User.count--;
      color('something is wrong...', front: Styles.BG_RED, isBold: true);
    }
  }

  List<User> getAllUsers() => usersData;
  User getSingleUser(int id) {
    User? user;
    try {
      for (var element in usersData) {
        if (element.id == id) {
          user = element;
        }
      }
    } catch (e) {
      color('user not found...', front: Styles.BG_RED, isBold: true);
    }

    return user!;
  }

  void showUsers() {
    final table = Table(
      header: [
        {'content': 'Users', 'colSpan': 2, 'hAlign': HorizontalAlign.center},
      ],
      // columnWidths: [10, 20],
    );
    table.add([
      'Id',
      'Name',
    ]);
    if (usersData.isEmpty) {
      color('No data to show', front: Styles.BG_RED, isBold: true);
    } else {
      for (var i = 0; i < usersData.length; i++) {
        table.add([usersData[i].id, usersData[i].name]);
      }
      print(table.toString());
    }
  }

  void delete(int id) {
    try {
      usersData.removeWhere((element) => element.id == id);
    } catch (e) {
      color('something is wrong...', front: Styles.BG_RED, isBold: true);
    }
  }
}
