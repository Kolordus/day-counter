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

  static Future<void> create(String name, String startDate, String endDate) async {
    String dateToSave = '$startDate,$endDate';
    return await Hive.box(_boxName)
        .put(name, dateToSave);
  }

  static EventTimestamp read(String name) {
    String value = Hive.box(_boxName).get(name);
    List<String> split = value.split(",");

    var startDate = DayService.stringToDate(split[0]);
    var endDate = DayService.stringToDate(split[1]);

    return EventTimestamp(name, startDate, endDate);
  }

  static Future<List<EventTimestamp>> getAll() async {
    return Hive.box(_boxName)
        .keys
        .map((e) => read(e))
        .toList();
  }

  static void delete(String name) => Hive.box(_boxName).delete(name);

  static void clearAll() {
    Hive.box(_boxName).clear();
  }
}
