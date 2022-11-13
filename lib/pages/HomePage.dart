import 'package:day_counter/EventTimeStampCard.dart';
import 'package:day_counter/service/DayService.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black87,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              EventTimestampCard.eventCounting(
                "między dniami do dzisiaj",
                DateTime.now().subtract(const Duration(days: 5)),
                DateTime.now(),
              ),
              EventTimestampCard.eventCounting(
                "między dniami w przesłości",
                DateTime.now().subtract(const Duration(days: 5)),
                DateTime.now().subtract(const Duration(days: 3)),
              ),
              EventTimestampCard.eventCountingFromPast(
                  "od daty startowej",
                  DateTime.now().subtract(const Duration(days: 5))),
              EventTimestampCard.eventCountingToFuture(
                "do daty koncowej", DateTime.now().add(const Duration(days: 5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
