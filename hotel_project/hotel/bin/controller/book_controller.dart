import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:intl/intl.dart';
import 'package:cli_table/cli_table.dart';
import '../model/book.dart';
import '../model/user.dart';
import 'admin_controller.dart';
import 'room_controller.dart';
import 'user_controller.dart';

class BookingController {
  List<Book> bookingData = [];
  List<Book> removeBooking = [];
  RoomController roomController = RoomController();
  UserController userController = UserController();
  AdminController adminController = AdminController();
  void update() {
    bool isApply = true;
    try {
      if (bookingData.isEmpty) {
        color('No data to update', front: Styles.BG_RED, isBold: true);
      } else {
        showBookingData();
        color('enter the id you want to update : ',
            front: Styles.BG_LIGHT_GREEN, isBold: true);
        int bookingNum = int.parse(stdin.readLineSync()!);
        color('Enter new duration : ',
            front: Styles.BG_LIGHT_GREEN, isBold: true);
        int duration = int.parse(stdin.readLineSync()!);

        for (var element in bookingData) {
          if (element.id == bookingNum) {
            for (var i = 0; i < bookingData.length; i++) {
              if (element.id != bookingData[i].id &&
                  isDatesBetween(
                      bookingData[i].bookingDate!,
                      bookingData[i]
                          .bookingDate!
                          .add(Duration(days: bookingData[i].duration!)),
                      element.bookingDate!.add(Duration(days: duration)))) {
                isApply = false;
                break;
              }
            }

            if (isApply == true) {
              //!
              element.duration = duration;
              element.bill = element.room!.price * duration;
            }
          }
        }
        if (isApply == false) {
          color('this is conflict...', front: Styles.BG_RED, isBold: true);
        }
      }
    } catch (e) {
      color('something is wrong', front: Styles.BG_RED, isBold: true);
    }
  }

  Book getById(int id) {
    Book? book;
    try {
      bookingData.forEach((element) {
        if (element.id == id) {
          book = element;
        }
      });
    } catch (e) {
      color('Not found...', front: Styles.BG_RED, isBold: true);
    }

    return book!;
  }

  void showBookingData() {
    if (bookingData.isEmpty) {
      color('No data to show', front: Styles.BG_RED, isBold: true);
    } else {
      final table = Table(
        header: [
          {
            'content': 'BOOKING',
            'colSpan': 7,
            'hAlign': HorizontalAlign.center
          },
        ],
      );
      table.add([
        'id',
        'username',
        "room",
        "bill",
        "duration",
        "booking date",
        "admin"
      ]);
      for (var i = 0; i < bookingData.length; i++) {
        table.add([
          bookingData[i].id,
          bookingData[i].user!.name,
          bookingData[i].room!.details,
          bookingData[i].bill,
          bookingData[i].duration,
          '${bookingData[i].bookingDate!.year}/${bookingData[i].bookingDate!.month}/${bookingData[i].bookingDate!.day}',
          bookingData[i].admin!.name
        ]);
      }
      print(table.toString());
    }
  }

  DateTime returnDate() {
    try {
      color('Enter the reservation date (dd/MM/yyyy): ',
          front: Styles.BG_LIGHT_GREEN, isBold: true);
      String date = stdin.readLineSync()!;
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      return dateFormat.parse(date);
    } catch (e) {
      color('Date formating not correct,Try again...',
          front: Styles.BG_RED, isBold: true);

      return returnDate();
    }
  }

  bool isDatesBetween(DateTime startDate, DateTime endDate, DateTime d) {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    for (var i = 0; i < dates.length; i++) {
      if (d == dates[i]) {
        return true;
      }
    }
    return false;
  }

  bool isConflitRoom(int roomId, DateTime? date) {
    for (var i = 0; i < bookingData.length; i++) {
      if (bookingData[i].room!.id == roomId &&
          (bookingData[i].bookingDate == date ||
              isDatesBetween(
                  bookingData[i].bookingDate!,
                  bookingData[i]
                      .bookingDate!
                      .add(Duration(days: bookingData[i].duration!)),
                  date!))) {
        return true;
      }
    }
    return false;
  }

  void deleteBooking() {
    try {
      if (bookingData.isEmpty) {
        color('No data to remove', front: Styles.BG_RED, isBold: true);
      } else {
        showBookingData();

        color('enter the id you want to remove : ',
            front: Styles.BG_LIGHT_GREEN, isBold: true);
        int bookingNum = int.parse(stdin.readLineSync()!);
        Book book = getById(bookingNum);
        removeBooking.add(book);
        userController.delete(book.user!.id!);

        ///if more than one room in booking
        int count = 0;
        for (var i = 0; i < bookingData.length; i++) {
          if (book.room!.id == bookingData[i].room!.id) {
            count++;
          }
        }
        if (count > 1) {
          roomController.updateStatuse(book.room!.id, 'not available');
        } else {
          roomController.updateStatuse(book.room!.id, 'available');
        }
        bookingData.removeWhere((element) => bookingNum == element.id);
      }
    } catch (e) {
      color('something is wrong', front: Styles.BG_RED, isBold: true);
    }
  }

  void addNewBooking(int adminId) {
    try {
      Book book = Book();
      //duration
      color('Enter the Booking duration : ',
          front: Styles.BG_LIGHT_GREEN, isBold: true);
      book.duration = int.parse(stdin.readLineSync()!);
      //!date
      book.bookingDate = returnDate();
      //room , bill
      roomController.showRoom();
      color('Enter the number of the room : ',
          front: Styles.BG_LIGHT_GREEN, isBold: true);
      int roomId = int.parse(stdin.readLineSync()!);
      //conflit room
      if (isConflitRoom(roomId, book.bookingDate)) {
        //or not available
        color('This room is already booked.',
            front: Styles.BG_RED, isBold: true);
        Book.count--;
      } else {
        book.room = roomController.getRoomById(roomId);
        roomController.updateStatuse(roomId, 'not available'); //! testing
        book.bill = book.room!.price * book.duration!;
        //user
        User user = User();
        color('Enter username : ', front: Styles.BG_LIGHT_GREEN, isBold: true);
        user.name = stdin.readLineSync()!.toLowerCase();
        book.user = user;
        UserController.usersData.add(user);
        book.admin = adminController.getAdminById(adminId);
        bookingData.add(book);
      }
      // roomId = 0;//!
    } catch (e) {
      Book.count--;
    }
  }

  void searchByUser(String username) {
    var result = bookingData
        .where(
          (element) => element.user!.name == username.toLowerCase(),
        )
        .toList();
    if (result.isEmpty) {
      color('No data to show', front: Styles.BG_RED, isBold: true);
    } else {
      final table = Table(
        header: [
          {
            'content': 'BOOKING',
            'colSpan': 7,
            'hAlign': HorizontalAlign.center
          },
        ],
      );
      table.add([
        'id',
        'username',
        "room",
        "bill",
        "duration",
        "booking date",
        "admin"
      ]);
      for (var i = 0; i < result.length; i++) {
        table.add([
          result[i].id,
          result[i].user!.name,
          result[i].room!.details,
          result[i].bill,
          result[i].duration,
          '${result[i].bookingDate!.year}/${result[i].bookingDate!.month}/${result[i].bookingDate!.day}',
          result[i].admin!.name
        ]);
      }
      print(table.toString());
    }
  }

  void removedBooking() {
    if (removeBooking.isEmpty) {
      color('No data to show', front: Styles.BG_RED, isBold: true);
    } else {
      final table = Table(
        header: [
          {
            'content': 'BOOKING',
            'colSpan': 7,
            'hAlign': HorizontalAlign.center
          },
        ],
      );
      table.add([
        'id',
        'username',
        "room",
        "bill",
        "duration",
        "booking date",
        "admin"
      ]);
      for (var i = 0; i < removeBooking.length; i++) {
        table.add([
          removeBooking[i].id,
          removeBooking[i].user!.name,
          removeBooking[i].room!.details,
          removeBooking[i].bill,
          removeBooking[i].duration,
          '${removeBooking[i].bookingDate!.year}/${removeBooking[i].bookingDate!.month}/${removeBooking[i].bookingDate!.day}',
          removeBooking[i].admin!.name
        ]);
      }
      print(table.toString());
    }
  }
}
