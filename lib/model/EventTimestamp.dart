
class EventTimestamp {

  String _name;
  DateTime _startDate;
  DateTime? _endDate;

  EventTimestamp(this._name, this._startDate, this._endDate);

  static EventTimestamp fromToday(String name) {
    return EventTimestamp(name, DateTime.now(), null);
  }

  static EventTimestamp fromTodayToOtherDate(String name, DateTime endDate) {
    return EventTimestamp(name, DateTime.now(), endDate);
  }

  static EventTimestamp withStartDateOnly(String name, DateTime startDate) {
    return EventTimestamp(name, startDate, null);
  }

  static EventTimestamp withStartAndEndDates(String name, DateTime startDate, DateTime endDate) {
    return EventTimestamp(name, startDate, endDate);
  }

}