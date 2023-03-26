
class DayService {

  static int daysBetweenDates(DateTime earlier, DateTime after) {
    return earlier.difference(after).inDays.abs();
  }

  static String dateToString(DateTime date) {
    return date.toString().substring(0, 10);
  }

  static DateTime? stringToDate(String date) {
    if (date == "null") {
      return null;
    }

    return DateTime.parse(date);
  }

  static DateTime getToday() {
    return DateTime.parse(DayService.dateToString(DateTime.now()));
  }

  static DateTime subtractDays(DateTime givenDate, int days) {
    return givenDate.subtract(Duration(days: days));
  }

  static DateTime addDaysDays(DateTime givenDate, int days) {
    return givenDate.add(Duration(days: days));
  }
}
