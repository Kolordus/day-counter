import 'package:day_counter/pages/HomePage.dart';
import 'package:day_counter/service/DayService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Database.dart';

class DayAdder extends StatefulWidget {
  const DayAdder({super.key});

  @override
  State<StatefulWidget> createState() => _DayAdderState();
}

class _DayAdderState extends State<DayAdder> {
  var dateTimestampController = TextEditingController();
  bool isInputAvailable = false;
  DateTime selected = DateTime.now();
  bool actionAdd = true;
  DateTime result = DayService.getToday();
  int daysValue = 0;

  @override
  Widget build(BuildContext context) {
    var currentYear = DateTime.now().year;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text('Od', style: TextStyle(color: Colors.white)),
          Text(DayService.dateToString(selected),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(currentYear - 2),
                    lastDate: DateTime(currentYear + 2));
                setState(() {
                  if (picked == null) {
                    selected = DayService.getToday();
                    return;
                  }

                  selected = picked;
                  recalculateResult();
                });
              },
              child: const Text("wybierz daty")),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  actionAdd = !actionAdd;
                });
              },
              child: actionAdd ? const Text('dodaj') : const Text('odejmij')),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => {
                setState(() {
                  if (value == '') {
                    result = selected;
                    return;
                  }
                  daysValue = int.parse(value);
                  recalculateResult();
                })
              },
              decoration: const InputDecoration(labelText: "Podaj liczbę dni"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
          Text('Wyszla taka data: \n${DayService.dateToString(result)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center),

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
            decoration: const InputDecoration(
                labelText: 'Timestamp name',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white, style: BorderStyle.solid))),
          ),
          ElevatedButton(
            onPressed: isInputAvailable
                ? () => {
                      _createNew(),
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      )
                    }
                : null,
            child: const Text(
              'zapisz',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void recalculateResult() {
    result = actionAdd
        ? DayService.addDaysDays(selected, daysValue)
        : DayService.subtractDays(selected, daysValue);
  }

  void _createNew() async {
    var startDate = DayService.dateToString(selected);
    var endDate = DayService.dateToString(result);

    await Database.create(dateTimestampController.text, startDate, endDate);
  }
}
