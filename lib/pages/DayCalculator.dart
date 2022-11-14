
import 'package:day_counter/service/DayService.dart';
import 'package:flutter/material.dart';

import '../Database.dart';

class DayCalculator extends StatefulWidget {
  const DayCalculator({super.key});

  @override
  State<StatefulWidget> createState() => _DayCalculatorState();
}

class _DayCalculatorState extends State<DayCalculator> {

  DateTimeRange dateRange = DateTimeRange(
      start: DateTime(DayService.getToday().year, DayService.getToday().month, DayService.getToday().day),
      end: DateTime(DayService.getToday().year, DayService.getToday().month, DayService.getToday().day)
  );

  var dateTimestampController = TextEditingController();

  bool isInputAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text('Od', style: TextStyle(color: Colors.white)),
          Text(DayService.dateToString(dateRange.start),
              style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
          ElevatedButton(
              onPressed: () async {
                DateTimeRange newDates = await pickDate(dateRange);
                setState(() {
                  dateRange = newDates;
                });
              },
              child: const Text("wybierz daty")),
          const Text('Do', style: TextStyle(color: Colors.white)),
          Text(
              DayService.dateToString(dateRange.end),
              style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),

          Text('wychodzi: ${DayService.daysBetweenDates(dateRange.start, dateRange.end)} dni',
              style: const TextStyle(color: Colors.white, fontSize: 30)),
          const Divider(color: Colors.white, thickness: 5),
          TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            controller: dateTimestampController,
            onChanged: (input) {
              setState(() {
                if (input.isNotEmpty) {
                  isInputAvailable = true;
                  return;
                }
                isInputAvailable = false;
              });
            },
            decoration: const InputDecoration(labelText: 'Timestamp name',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, style: BorderStyle.solid))),
          ),
          ElevatedButton(
              onPressed: isInputAvailable ? () => _createNew() : null,
              child: const Text('zapisz', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  Future pickDate(DateTimeRange dateRange) async {
    DateTimeRange? dateTimeRange = await showDateRangePicker(
        locale : const Locale('pl',''),
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(DateTime.now().year - 3),
        lastDate: DateTime(DateTime.now().year + 3));

    if (dateTimeRange == null) return dateRange;

    return dateTimeRange;
  }

  void _createNew() async  {
    var startDate = DayService.getToday() == dateRange.start ?
    'null' : DayService.dateToString(dateRange.start);

    var endDate = DayService.getToday() == dateRange.end ?
    'null' : DayService.dateToString(dateRange.end);

    await Database.create(dateTimestampController.text,
      startDate,
      endDate
    );
  }
}