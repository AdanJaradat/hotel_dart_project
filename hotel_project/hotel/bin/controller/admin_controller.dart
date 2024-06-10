import 'package:cli_table/cli_table.dart';
import 'package:colorize/colorize.dart';

import '../model/admin.dart';

class AdminController {
  List<Admin> adminList = [
    Admin(id: 1, name: 'ahmad', email: 'ahmad@gmail.com', password: '123456'),
    Admin(id: 2, name: 'ali', email: 'ali@gmail.com', password: '123456'),
    Admin(id: 3, name: 'omar', email: 'omar@gmail.com', password: '123456'),
  ];

  List<Admin> get adminListData => adminList;
  Admin getSingleAdmin(int index) => adminList.elementAt(index);
  int adminListDataLength() => adminList.length;

  Admin getAdminById(int id) {
    Admin? admin;
    try {
      adminList.forEach((element) {
        if (element.id == id) {
          admin = element;
        }
      });
    } catch (e) {
      color('something is wrong', front: Styles.BG_RED, isBold: true);
    }

    return admin!;
  }

  void showAdmin() {
    final table = Table(
      header: [
        {'content': 'Admins', 'colSpan': 3, 'hAlign': HorizontalAlign.center},
      ],
    );
    table.add([
      'Id',
      'Name',
      'Email',
    ]);
    if (adminList.isEmpty) {
      color('No data to show', front: Styles.BG_RED, isBold: true);
    } else {
      for (var i = 0; i < adminList.length; i++) {
        table.add([adminList[i].id, adminList[i].name, adminList[i].email]);
      }
      print(table.toString());
    }
  }

  void adminListMenu() {
    color('*********' * 5, front: Styles.BG_BLUE, isBold: true);
    color('*            ADMIN-SERVICES                 *',
        front: Styles.BG_BLUE, isBold: true);
    color('*********' * 5, front: Styles.BG_BLUE, isBold: true);
    color('1- Add Booking                              *',
        front: Styles.BG_BLUE, isBold: true);
    color('2- Update Booking Duration                  *',
        front: Styles.BG_BLUE, isBold: true);
    color('3- Delete Booking                           *',
        front: Styles.BG_BLUE, isBold: true);
    color('4- Get All Booking                          *',
        front: Styles.BG_BLUE, isBold: true);
    color('5- Search for booking by username           *',
        front: Styles.BG_BLUE, isBold: true);
    color('6- Get All Users                            *',
        front: Styles.BG_BLUE, isBold: true);
    color('7- Get All Rooms                            *',
        front: Styles.BG_BLUE, isBold: true);
    color('8- Get All Remove Booking                   *',
        front: Styles.BG_BLUE, isBold: true);
    color('9- Get All Admins                           *',
        front: Styles.BG_BLUE, isBold: true);
  }
}
