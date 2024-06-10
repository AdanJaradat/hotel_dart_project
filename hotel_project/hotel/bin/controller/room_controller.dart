import 'package:cli_table/cli_table.dart';
import 'package:colorize/colorize.dart';

import '../model/room.dart';

class RoomController {
  static List<Room> roomsData = [
    Room(id: 1, details: 'room1 details', stause: 'available', price: 120),
    Room(id: 2, details: 'room2 details', stause: 'available', price: 100),
    Room(id: 3, details: 'room3 details', stause: 'available', price: 110),
    Room(id: 4, details: 'room4 details', stause: 'available', price: 130),
    Room(id: 5, details: 'room5 details', stause: 'available', price: 120),
    Room(id: 6, details: 'room6 details', stause: 'available', price: 140.50),
    Room(id: 7, details: 'room7 details', stause: 'available', price: 120),
    Room(id: 8, details: 'room8 details', stause: 'available', price: 90),
    Room(id: 9, details: 'room9 details', stause: 'available', price: 130),
    Room(id: 10, details: 'room10 details', stause: 'available', price: 160),
  ];
  List<Room> get roomsListData => roomsData;
  Room getSingleROom(int index) => roomsData.elementAt(index);
  int roomsListDataLength() => roomsData.length;

  Room getRoomById(int id) {
    Room? room;
    try {
      roomsData.forEach((element) {
        if (element.id == id) {
          room = element;
        }
      });
    } catch (e) {
      color('This room does not exist.', front: Styles.BG_RED, isBold: true);
    }

    return room!;
  }

  void updateStatuse(int id, String stats) {
    try {
      for (var element in roomsData) {
        if (id == element.id) {
          element.stause = stats;
        }
      }
    } catch (e) {
      color('something is wrong', front: Styles.BG_RED, isBold: true);
    }
  }

  void showRoom() {
    final table = Table(
      header: [
        {'content': 'ROOMS', 'colSpan': 4, 'hAlign': HorizontalAlign.center},
      ],
    );
    table.add([
      'Id',
      'Details ',
      'Status ',
      'price ',
    ]);
    for (int i = 0; i < roomsData.length; i++) {
      table.add([
        roomsData[i].id,
        roomsData[i].details,
        roomsData[i].stause,
        roomsData[i].price
      ]);
    }
    print(table.toString());
  }
}
