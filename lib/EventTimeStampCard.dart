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

  EventTimestampCard({required this.name, this.startDate, this.endDate});

  final String name;
  final DateTime? startDate;
  final DateTime? endDate;

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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            name,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const Divider(),
        noStartDate
            ? Text("")
            : Text("Od ${DayService.formatDate(startDate!)}",
                style: const TextStyle(fontSize: 20)),
        noEndDate
            ? Text("")
            : Text("Do ${DayService.formatDate(endDate!)}",
                style: const TextStyle(fontSize: 20)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Text(_calculateText(noEndDate, noStartDate)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${_calculateDays(noStartDate, noEndDate)} dni",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ],
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
        ? DayService.daysBetweenDates(startDate!, DayService.getToday()).toString()
        : DayService.daysBetweenDates(startDate!, endDate!).toString();
  }

  bool _bothInPast() {
    DateTime today = DateTime.now();
    return endDate!.add(const Duration(minutes: 1)).isBefore(today);
  }
}
