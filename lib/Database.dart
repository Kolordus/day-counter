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

  static Future<int> create(String name, String startDate, String endDate) async {
    var eventTimestamp = EventTimestamp(name,
        DayService.stringToDate(startDate), DayService.stringToDate(endDate));
    return await Hive.box(_boxName).add(eventTimestamp);
  }

  static Future<List<EventTimestamp>> getAll() async {
    List<EventTimestamp> list = [];
    Hive.box(_boxName).values.forEach((eventTimeStamp) {
      list.add(eventTimeStamp);
    });

    return Future.value(list);
  }

  static Future<EventTimestamp> read(int index) async {
    var event = await Hive.box(_boxName).get(index);

    if (event is EventTimestamp) {
      return event;
    }
    return EventTimestamp.fromJson(event);
  }

  static void delete(int index) async {
    await Hive.box(_boxName).deleteAt(index);
  }

  static Future<int> clearAll() async {
    return await Hive.box(_boxName).clear();
  }

  static Future<void> replace(List<EventTimestamp> allDates) async {
    await clearAll();
    await Hive.box(_boxName).addAll(allDates);
  }

  static Future<void> stopCounting(String name) async {
    var index = _getIndex(name);
    var toChange = await read(index);
    toChange.endDate = DayService.getToday();
    await Hive.box(_boxName).put(index, toChange);
  }

  static int _getIndex(String name) {
    for (int key in Hive.box(_boxName).keys) {
      EventTimestamp event = Hive.box(_boxName).get(key);
      if (event.name == name) {
        return key;
      }
    }

    return -1;
  }
}
