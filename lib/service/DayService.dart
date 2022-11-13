
class DayService {

  static int daysBetweenDates(DateTime earlier, DateTime after) {
    return earlier.difference(after).inDays.abs();
  }

  static String formatDate(DateTime date) {
    return date.toString().substring(0, 10);
  }

  static DateTime getToday() {
    return DateTime.now();
  }

}