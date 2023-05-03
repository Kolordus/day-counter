import 'package:day_counter/model/EventTimestamp.dart';
import 'package:day_counter/service/DayService.dart';
import 'package:hive/hive.dart';

class Database {
  static const String _boxName = 'dates';

  /*
  // data ma następujce rzeczy -> stardate,enddate
  moze to wygldac tak:
  null,enddate
  startdate,null
  startdate,enddate
   */

  static Future<int> create(
      String name, String startDate, String endDate) async {
    var eventTimestamp = EventTimestamp(name, DayService.stringToDate(startDate), DayService.stringToDate(endDate));
    return await Hive.box(_boxName).add(eventTimestamp.toJson());
  }

  static Future<List<EventTimestamp>> getAll() async {
    List<EventTimestamp> list = [];
    Hive.box(_boxName)
        .values
        .forEach((e) { print(e); list.add(EventTimestamp.fromJson(e)); } );

    return Future.value(list);
  }

  static EventTimestamp read(String name) {
    Map<String, Object> json = Hive.box(_boxName).get(name);
    return EventTimestamp.fromJson(json);
  }

  static void delete(String name) {
    var box = Hive.box<EventTimestamp>(_boxName);

    for (var element in box.keys) {
      if (box.get(element)?.name == name) {
        box.deleteAt(element);
      }
    }
  }

  static void clearAll() {
    Hive.box(_boxName).clear();
  }
}
