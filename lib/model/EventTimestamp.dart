import 'package:day_counter/service/DayService.dart';
import 'package:hive/hive.dart';

part 'EventTimestamp.g.dart';

@HiveType(typeId: 0)
class EventTimestamp {
  @HiveField(0)
  String name;
  @HiveField(1)
  DateTime? startDate;
  @HiveField(2)
  DateTime? endDate;

  EventTimestamp(this.name, this.startDate, this.endDate);

  Map<String, Object?> toJson() => {
        'name': name,
        'startDate':
            startDate == null ? null : DayService.dateToString(startDate!),
        'endDate': endDate == null ? null : DayService.dateToString(endDate!),
      };

  static EventTimestamp fromJson(Map<String, dynamic> json) {
    DateTime? startDate =
        json['startDate'] == null ? null : DateTime.parse(json['startDate']);
    DateTime? endDate =
        json['endDate'] == null ? null : DateTime.parse(json['endDate']);

    var eventTimestamp = EventTimestamp(json['name'], startDate, endDate);

    return eventTimestamp;
  }

  @override
  String toString() {
    return 'EventTimestamp{name: $name, startDate: $startDate, endDate: $endDate}';
  }
}
