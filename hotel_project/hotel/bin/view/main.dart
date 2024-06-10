import 'dart:io';

import 'package:colorize/colorize.dart';

import '../controller/admin_controller.dart';
import '../controller/book_controller.dart';
import '../controller/room_controller.dart';
import '../controller/user_controller.dart';
import '../model/admin.dart';

String maskPassword() {
  color('Enter your password [4 attempts to password] : ',
      front: Styles.BG_LIGHT_GREEN, isBold: true);
  String password = '';
  while (true) {
    // Read a single character
    stdin.echoMode = false;
    String char = stdin.echoMode == false
        ? String.fromCharCode(stdin.readByteSync())
        : stdin.readLineSync()!;
    if (char == "\n" || char == "\r") {
      break; // User pressed Enter or Return
    }

    // Mask the character with an asterisk (*)
    password += char;
    stdin.echoMode = true;
    stdout.write("*");
  }
  stdout.write("\n"); // Add newline after masked input
  stdin.echoMode = true;
  stdin.readLineSync();
  return password;
}

Admin login() {
  int attempts = 0;
  Admin? admin;
  AdminController adminController = AdminController();
  color('Enter your email : ', front: Styles.BG_LIGHT_GREEN, isBold: true);
  String adminEmail = stdin.readLineSync()!;
  String adminPassword = maskPassword(); //! fix it
  // print('Enter your password : ');
  // String adminPassword = stdin.readLineSync()!; //! fix it
  while (attempts < 3) {
    admin = adminController.adminList.firstWhere(
      (element) =>
          element.email == adminEmail && element.password == adminPassword,
      orElse: () => Admin(id: 0, name: '', email: '', password: ''), //
    );
    if (admin.id != 0) {
      attempts = 4;
    }
    if (admin.id == 0) {
      attempts++;
      color('email/password incorrect...try again',
          front: Styles.BG_LIGHT_GREEN, isBold: true);
      color('Enter your email : ', front: Styles.BG_LIGHT_GREEN, isBold: true);
      adminEmail = stdin.readLineSync()!;
      adminPassword = maskPassword();
    }
  }
  if (attempts == 3) {
    color('Your attempts is over.', front: Styles.BG_RED, isBold: true);
  }
  return admin!;
}

void main(List<String> args) {
  bool serviceDone = true;
  AdminController adminController = AdminController();
  BookingController bookingController = BookingController();
  RoomController roomController = RoomController();
  UserController userController = UserController();
  Admin adminLogin = login();
  if (adminLogin.id != 0) {
    while (serviceDone) {
      adminController.adminListMenu();
      color('Enter service number : ',
          front: Styles.BG_LIGHT_GREEN, isBold: true);
      int serviceNum = int.parse(stdin.readLineSync()!);
      switch (serviceNum) {
        case 1:
          bookingController.addNewBooking(adminLogin.id);
          color('Enter 1 to exit ,2 to continue',
              front: Styles.BG_LIGHT_GREEN, isBold: true);
          int isExit = int.parse(stdin.readLineSync()!);
          if (isExit == 1) {
            color('Exit...', front: Styles.BG_LIGHT_GREEN, isBold: true);
            serviceDone = false;
          }
          break;
        case 2:
          bookingController.update();
          //
          color('Enter 1 to exit ,2 to continue',
              front: Styles.BG_LIGHT_GREEN, isBold: true);
          int isExit = int.parse(stdin.readLineSync()!);
          if (isExit == 1) {
            color('Exit...', front: Styles.BG_LIGHT_GREEN, isBold: true);
            serviceDone = false;
          }
          break;
        case 3:
          bookingController.deleteBooking();
          color('Enter 1 to exit ,2 to continue',
              front: Styles.BG_LIGHT_GREEN, isBold: true);
          int isExit = int.parse(stdin.readLineSync()!);
          if (isExit == 1) {
            color('Exit...', front: Styles.BG_LIGHT_GREEN, isBold: true);
            serviceDone = false;
          }
          break;
        case 4:
          bookingController.showBookingData();
          color('Enter 1 to exit ,2 to continue',
              front: Styles.BG_LIGHT_GREEN, isBold: true);
          int isExit = int.parse(stdin.readLineSync()!);
          if (isExit == 1) {
            color('Exit...', front: Styles.BG_LIGHT_GREEN, isBold: true);
            serviceDone = false;
          }
          break;
        case 5:
          color('Enter username to search for booking : ',
              front: Styles.BG_LIGHT_GREEN, isBold: true);
          String input = stdin.readLineSync()!;
          bookingController.searchByUser(input);
          color('Enter 1 to exit ,2 to continue',
              front: Styles.BG_LIGHT_GREEN, isBold: true);
          int isExit = int.parse(stdin.readLineSync()!);
          if (isExit == 1) {
            color('Exit...', front: Styles.BG_LIGHT_GREEN, isBold: true);
            serviceDone = false;
          }
          break;
        case 6:
          userController.showUsers();
          color('Enter 1 to exit ,2 to continue',
              front: Styles.BG_LIGHT_GREEN, isBold: true);
          int isExit = int.parse(stdin.readLineSync()!);
          if (isExit == 1) {
            color('Exit...', front: Styles.BG_LIGHT_GREEN, isBold: true);
            serviceDone = false;
          }
          break;
        case 7:
          roomController.showRoom();
          color('Enter 1 to exit ,2 to continue',
              front: Styles.BG_LIGHT_GREEN, isBold: true);
          int isExit = int.parse(stdin.readLineSync()!);
          if (isExit == 1) {
            color('Exit...', front: Styles.BG_LIGHT_GREEN, isBold: true);
            serviceDone = false;
          }
          break;
        case 8:
          bookingController.removedBooking();
          color('Enter 1 to exit ,2 to continue',
              front: Styles.BG_LIGHT_GREEN, isBold: true);
          int isExit = int.parse(stdin.readLineSync()!);
          if (isExit == 1) {
            color('Exit...', front: Styles.BG_LIGHT_GREEN, isBold: true);
            serviceDone = false;
          }
          break;
        case 9:
          adminController.showAdmin();
          color('Enter 1 to exit ,2 to continue',
              front: Styles.BG_LIGHT_GREEN, isBold: true);
          int isExit = int.parse(stdin.readLineSync()!);
          if (isExit == 1) {
            color('Exit...', front: Styles.BG_LIGHT_GREEN, isBold: true);
            serviceDone = false;
          }
          break;
        default:
          color('this servic not found.', front: Styles.BG_RED, isBold: true);
      }
    }
  }
}
