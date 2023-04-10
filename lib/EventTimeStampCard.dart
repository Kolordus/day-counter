import 'package:day_counter/Database.dart';
import 'package:day_counter/service/DayService.dart';
import 'package:flutter/material.dart';

class EventTimestampCard extends StatelessWidget {
  static EventTimestampCard eventCountingToFuture(
      String name, DateTime endDate) {
    return EventTimestampCard(name: name, startDate: null, endDate: endDate);
  }

  static EventTimestampCard eventCountingFromPast(
      String name, DateTime startDate) {
    return EventTimestampCard(name: name, startDate: startDate, endDate: null);
  }

  static EventTimestampCard eventCounting(
      String name, DateTime startDate, DateTime endDate) {
    return EventTimestampCard(
        name: name, startDate: startDate, endDate: endDate);
  }

  EventTimestampCard(
      {super.key,
      required this.name,
      this.startDate,
      this.endDate,
      this.refresh});

  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function? refresh;

  @override
  Widget build(BuildContext context) {
    var countingToFuture = startDate == null;
    var countingFromPast = endDate == null;

    return Row(
      children: [
        Expanded(
            child: Card(
          color: getColor(countingToFuture, countingFromPast),
          child: _cardContent(name, startDate, endDate),
        )),
      ],
    );
  }

  ColorSwatch<int> getColor(bool countingToFuture, bool countingFromPast) {
    if (countingToFuture) return Colors.indigoAccent;
    if (countingFromPast) return Colors.red;
    if (_bothInPast()) return Colors.yellow;
    return Colors.deepPurpleAccent; // from past to now
  }

  Widget _cardContent(String name, DateTime? startDate, DateTime? endDate) {
    var noStartDate = startDate == null;
    var noEndDate = endDate == null;
    var days = _calculateDays(noStartDate, noEndDate);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Divider(),
            Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 20),
                ),
                noStartDate
                    ? Text("")
                    : Text("Od ${DayService.dateToString(startDate)}",
                        style: const TextStyle(fontSize: 20)),
                noEndDate
                    ? ElevatedButton(
                        onPressed: () => {noEndDate = false, _stopCounting()},
                        child: const Text("stop counting"))
                    : Text("Do ${DayService.dateToString(endDate)}",
                        style: const TextStyle(fontSize: 20)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Text(
                _calculateText(noEndDate, noStartDate),
                style: const TextStyle(fontSize: 23),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "$days dni",
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${_calculateWeeks(days)} tygodni",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateText(bool countingToFuture, bool countingFromPast) {
    if (countingToFuture) return "minęło";

    if (countingFromPast && _bothInPast()) {
      return "minęło";
    }

    return countingFromPast ? "pozostało" : "minęło";
  }

  String _calculateDays(bool countingToFuture, bool countingFromPast) {
    if (countingToFuture) {
      return DayService.daysBetweenDates(DayService.getToday(), endDate!)
          .toString();
    }

    return countingFromPast
        ? DayService.daysBetweenDates(startDate!, DayService.getToday())
            .toString()
        : DayService.daysBetweenDates(startDate!, endDate!).toString();
  }

  String _calculateWeeks(String days) {
    var parse = int.parse(days);
    return (parse / 7).toInt().toString();
  }

  bool _bothInPast() {
    DateTime today = DateTime.now();
    return endDate!.add(const Duration(minutes: 1)).isBefore(today);
  }

  Future<void> _stopCounting() async {
    refresh!();
    await Database.create(name, DayService.dateToString(startDate!),
        DayService.dateToString(DayService.getToday()));
  }
}
