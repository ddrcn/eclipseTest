import 'package:hive/hive.dart';

class HiveProvider {
  isExists({required String boxName}) async {
    bool isExist = await Hive.boxExists(boxName);
    if (isExist == false) return false;
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  addBoxes<T>(List<T> items, String boxName) async {
    final openBox = await Hive.openBox(boxName);

    for (var item in items) {
      openBox.add(item);
    }
  }

  getBoxes<T>(String boxName) async {
    List<T> boxList = [];
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i));
    }

    return boxList;
  }
}
